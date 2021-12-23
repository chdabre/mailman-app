import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:mailman/platform/platform_utils.dart';
import 'package:mailman/environment.dart';

DioForNative? _dioForNative;

DioForNative _client() {
  _dioForNative ??= DioForNative();
  return _dioForNative!;
}

Future<Map<String, dynamic>> _getApi(ApiRequest request) async {
  var client = _client();
  client.options = BaseOptions(
    baseUrl: request.baseUrl,
    headers: request.headers,
    contentType: 'application/json',
  );
  Response response = await client.get(
    request.path,
    queryParameters: request.parameters,
  );

  if (response.data is Map<String, dynamic>) {
    return response.data as Map<String, dynamic>;
  }

  throw response.data;
}

Future<Map<String, dynamic>> _postApi(ApiRequest request) async {
  var client = _client();
  _client().options = BaseOptions(
    baseUrl: request.baseUrl,
    headers: request.headers,
    contentType: 'application/json',
  );

  final response = await client.post(
    request.path,
    data: request.parameters,
  );

  if (response.data is Map<String, dynamic>) {
    return response.data as Map<String, dynamic>;
  }
  return {};
}

Future<Map<String, dynamic>> _patchApi(ApiRequest request) async {
  var client = _client();
  _client().options = BaseOptions(
    baseUrl: request.baseUrl,
    headers: request.headers,
    contentType: 'application/json',
  );
  final response = await client.patch(
    request.path,
    data: request.parameters,
  );
  if (response.data is Map<String, dynamic>) {
    return response.data as Map<String, dynamic>;
  }
  return {};
}

Future<Map<String, dynamic>> _putApi(ApiRequest request) async {
  var client = _client();
  _client().options = BaseOptions(
    baseUrl: request.baseUrl,
    headers: request.headers,
    contentType: 'application/json',
  );
  final response = await client.put(
    request.path,
    data: request.parameters,
  );
  if (response.data is Map<String, dynamic>) {
    return response.data as Map<String, dynamic>;
  }

  return {};
}

Future<Map<String, dynamic>> _deleteApi(ApiRequest request) async {
  var client = _client();
  _client().options = BaseOptions(
    baseUrl: request.baseUrl,
    headers: request.headers,
    contentType: 'application/json',
  );
  final response = await client.delete(
    request.path,
    data: request.parameters,
  );
  if (response.data is Map<String, dynamic>) {
    return response.data as Map<String, dynamic>;
  }

  return {};
}


void _rootIsolateListener(SendPort isolateToMainStream) {
  ReceivePort mainToIsolateStream = ReceivePort();
  isolateToMainStream.send(mainToIsolateStream.sendPort);

  mainToIsolateStream.listen((request) async {
    Map<String, dynamic> response = {};
    if (request is ApiRequest) {
      try {
        switch (request.method) {
          case 'get':
            response = await _getApi(request);
            break;
          case 'post':
            response = await _postApi(request);
            break;
          case 'put':
            response = await _putApi(request);
            break;
          case 'patch':
            response = await _patchApi(request);
            break;
          case 'delete':
            response = await _deleteApi(request);
            break;
        }
        isolateToMainStream.send(
          ApiResponse(
            apiRequest: request,
            data: response,
          ),
        );
      } catch (error, stacktrace) {
        if (kDebugMode) {
          print('Failed requesting ${request.path} with ${request.parameters}');
          print(stacktrace);
        }
        if (error is DioError) {
          var data = error.response?.data;
          if (data is String) {
            data = {
              'errors': data,
            };
          }

          var message = (data != null ? data['errors'] : null) ??
              error.response?.statusMessage;

          isolateToMainStream.send(
            IOError(
              apiRequest: request,
              data: data,
              code: error.response?.statusCode,
              message: message,
              type: _fromDioErrorType(error.type),
            ),
          );
        } else {
          isolateToMainStream.send(
            IOError(
              apiRequest: request,
              data: response,
              message: error.toString(),
              type: IOErrorType.response,
            ),
          );
        }
      }
    }
  });
}

class ApiClient {
  final Logger _log = Logger('ApiClient');

  String? _token;
  String? _languageCode;
  String? _version;

  String _baseUrl;
  late Isolate _clientIsolate;
  late SendPort _senderToIsolate;

  final Map<ApiRequest, Completer<Map<String, dynamic>>> requests = {};

  ApiClient({required String baseUrl}) : _baseUrl = baseUrl;

  Future<void> initialize() async {
    _senderToIsolate = await _initIsolate();
  }

  Future<void> close() async {
    _clientIsolate.kill();
  }

  Future<SendPort> _initIsolate() async {
    Completer<SendPort> completer = Completer<SendPort>();
    var _receivePort = ReceivePort();

    _receivePort.listen((data) {
      if (data is SendPort) {
        SendPort mainToIsolateStream = data;
        completer.complete(mainToIsolateStream);
      } else if (data is ApiResponse) {
        var requestCompleter = requests.remove(data.apiRequest);
        requestCompleter?.complete(data.data);
      } else if (data is IOError) {
        var requestCompleter = requests.remove(data.apiRequest);
        requestCompleter?.completeError(data);
      }
    });

    _clientIsolate = await Isolate.spawn(
      _rootIsolateListener,
      _receivePort.sendPort,
      debugName: 'ApiClient',
    );
    return completer.future;
  }

  Future<Map<String, dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    var apiRequest = ApiRequest(
      baseUrl: _baseUrl,
      method: 'get',
      path: path,
      headers: _buildHeader(),
      parameters: queryParameters,
    );
    _senderToIsolate.send(apiRequest);
    var requestCompleter = Completer<Map<String, dynamic>>();
    requests[apiRequest] = requestCompleter;

    return requestCompleter.future;
  }

  Future<Map<String, dynamic>> put(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    var apiRequest = ApiRequest(
      baseUrl: _baseUrl,
      method: 'put',
      path: path,
      headers: _buildHeader(),
      parameters: queryParameters,
    );
    _senderToIsolate.send(apiRequest);
    var requestCompleter = Completer<Map<String, dynamic>>();
    requests[apiRequest] = requestCompleter;

    return requestCompleter.future;
  }

  Future<Map<String, dynamic>> post(
      String path, {
        Map<String, dynamic>? data,
      }) async {
    var apiRequest = ApiRequest(
      baseUrl: _baseUrl,
      method: 'post',
      path: path,
      headers: _buildHeader(),
      parameters: data,
    );
    _senderToIsolate.send(apiRequest);
    var requestCompleter = Completer<Map<String, dynamic>>();
    requests[apiRequest] = requestCompleter;

    return requestCompleter.future;
  }

  Future<Map<String, dynamic>> patch(
      String path, {
        Map<String, dynamic>? data,
      }) async {
    var apiRequest = ApiRequest(
      baseUrl: _baseUrl,
      method: 'patch',
      path: path,
      headers: _buildHeader(),
      parameters: data,
    );
    _senderToIsolate.send(apiRequest);
    var requestCompleter = Completer<Map<String, dynamic>>();
    requests[apiRequest] = requestCompleter;

    return requestCompleter.future;
  }

  Future<Map<String, dynamic>> delete(
      String path, {
        Map<String, dynamic>? data,
      }) async {
    var apiRequest = ApiRequest(
      baseUrl: _baseUrl,
      method: 'delete',
      path: path,
      headers: _buildHeader(),
      parameters: data,
    );
    _senderToIsolate.send(apiRequest);
    var requestCompleter = Completer<Map<String, dynamic>>();
    requests[apiRequest] = requestCompleter;

    return requestCompleter.future;
  }

  Map<String, String> _buildHeader() {
    var languageCode = _languageCode;
    var version = _version;
    return {
      if (_token != null) 'Authorization': 'Token  $_token',
      if (languageCode != null) 'Accept-Language': languageCode,
      if (PlatformUtils.isAndroid && version != null)
        'Android-App-Version': version,
      if (PlatformUtils.isIOS && version != null) 'iOS-App-Version': version,
      'content-type': 'application/json',
    };
  }

  void setEnvironment(Environment environment) {
    _log.info('Updating API url to ${environment.apiUrl}');
    _baseUrl = environment.apiUrl;
  }

  void setLanguage(String languageCode) {
    _languageCode = languageCode;
  }

  void setApplicationVersion(String version) {
    _version = version;
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  /// Fetches JSON response and converts into `List<T>`.
  /// Throws [HttpError] if request raised [IOError].
  ///
  /// Note about `factory` argument:
  /// *   it is a callable which must accept `Map<String, dynamic>` and return `T`.
  /// *  it must create an instance of T from JSON object.
  static Future<List<T>> fetchMany<T>(ApiClient client, String path,
      {Map<String, dynamic>? queryParameters,
        required T Function(Map<String, dynamic> o) factory}) async {
    var response = await client.get(path, queryParameters: queryParameters);
    var jsonObjects = List<Map<String, dynamic>>.from(response['data']);
    return List<T>.from(jsonObjects.map((item) => factory(item)));
  }

  /// Fetches JSON response and creates single instance of T.
  /// T class has to implement static method.
  /// Example: `static Booth fromJson(Map<String, dynamic> data)`.
  /// Throws [HttpError] if request raised [IOError].
  ///
  /// Note about `factory` argument:
  /// *   it is a callable which must accept `Map<String, dynamic>` and return `T`.
  /// *  it must create an instance of T from JSON object.
  static Future<T> fetchOne<T>(ApiClient client, String path,
      {Map<String, dynamic>? queryParameters,
        required T Function(Map<String, dynamic> o) factory}) async {
    var response = await client.get(path, queryParameters: queryParameters);
    var jsonObject = Map<String, dynamic>.from(response);
    return factory(jsonObject);
  }
}

class ApiRequest extends Equatable {
  static int requestCounter = 0;

  final int _counter;
  final String baseUrl;
  final String method;
  final String path;
  final Map<String, String> headers;
  final Map<String, dynamic>? parameters;

  ApiRequest({
    required this.baseUrl,
    required this.method,
    required this.path,
    required this.headers,
    this.parameters,
  }) : _counter = requestCounter++;

  @override
  List<Object?> get props => [
    baseUrl,
    method,
    path,
    headers,
    parameters,
    _counter,
  ];
}

class ApiResponse extends Equatable {
  final ApiRequest apiRequest;
  final Map<String, dynamic> data;

  const ApiResponse({
    required this.apiRequest,
    required this.data,
  });

  @override
  List<Object?> get props => [data, apiRequest];
}

class IOError implements Exception {
  final ApiRequest apiRequest;
  final Map<String, dynamic>? data;
  final dynamic message;
  final int? code;
  final IOErrorType type;

  IOError({
    required this.apiRequest,
    required this.type,
    this.code,
    this.data,
    this.message,
  });
}

enum IOErrorType {
  /// It occurs when url is opened timeout.
  connectTimeout,

  /// It occurs when url is sent timeout.
  sendTimeout,

  ///It occurs when receiving timeout.
  receiveTimeout,

  /// When the server response, but with a incorrect status, such as 404, 503...
  response,

  /// When the request is cancelled, dio will throw a error with this type.
  cancel,

  /// Default error type, Some other Error. In this case, you can
  /// use the DioError.error if it is not null.
  other,
}

IOErrorType _fromDioErrorType(DioErrorType type) {
  switch (type) {
    case DioErrorType.CONNECT_TIMEOUT:
      return IOErrorType.connectTimeout;
    case DioErrorType.SEND_TIMEOUT:
      return IOErrorType.sendTimeout;
    case DioErrorType.RECEIVE_TIMEOUT:
      return IOErrorType.receiveTimeout;
    case DioErrorType.RESPONSE:
      return IOErrorType.response;
    case DioErrorType.CANCEL:
      return IOErrorType.cancel;
    case DioErrorType.DEFAULT:
    default:
      return IOErrorType.other;
  }
}
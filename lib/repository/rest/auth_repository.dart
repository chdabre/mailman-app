import 'package:logging/logging.dart';
import 'package:mailman/entity/authentication_result_entity.dart';
import 'package:mailman/model/authentication_result.dart';
import 'package:mailman/repository/auth_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/secured_storage.dart';

class AuthRestRepository extends AuthRepository {
  final Logger _log = Logger('AuthRepository');
  final ApiClient _client;
  final SecuredStorage _securedStorage;

  AuthRestRepository(
    this._client,
    this._securedStorage
  );

  @override
  Future<void> init() async {
    var token = await _securedStorage.getToken();
    if (token != null) {
      _client.setToken(token);
      _log.info('API client is now using $token');
    }
  }

  @override
  Future<AuthenticationResult?> login({required String username, required String password}) async {
    try {
      var params = {
        'username': username,
        'password': password,
      };

      _log.info('Trying to login with $params');

      var response = await _client.post('/api/v1/auth/login/',
          data: params
      );

      _log.info('Success');
      return AuthenticationResult.fromEntity(
        AuthenticationResultEntity.fromJson(
          Map<String, dynamic>.from(response),
        )
      );
    } on IOError catch (error, stacktrace) {
      _log.info('Failed to login', error.data, stacktrace);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    if (await hasToken()) {
      try {
        _log.info('Trying to logout');

        await _client.post('/api/v1/auth/logout/');

        _log.info('Success');
      } on IOError catch (error, stacktrace) {
        _log.info('Failed to logout', error, stacktrace);
        rethrow;
      } finally {
        deleteToken();
      }
    }
  }

  @override
  Future<AuthenticationResult?> register({required String username, String email = "", required String password1, required String password2}) async {
    try {
      var params = {
        'username': username,
        if (email.isNotEmpty) 'email': email,
        'password1': password1,
        'password2': password2,
      };

      _log.info('Trying to register with $params');

      var response = await _client.post('/api/v1/auth/registration/',
          data: params
      );

      _log.info('Success');
      return AuthenticationResult.fromEntity(
          AuthenticationResultEntity.fromJson(
            Map<String, dynamic>.from(response),
          )
      );
    } on IOError catch (error, stacktrace) {
      _log.info('Failed to register', error, stacktrace);
      rethrow;
    }
  }

  @override
  Future<bool> hasToken() async {
    return _securedStorage.hasToken();
  }

  @override
  Future<String?> getToken() async {
    return _securedStorage.getToken();
  }

  @override
  Future<void> persistToken(String token) async {
    _client.setToken(token);
    await _securedStorage.persistToken(token);
  }

  @override
  Future<void> deleteToken() async {
    _client.clearToken();
    await _securedStorage.deleteToken();
  }
}
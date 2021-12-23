import 'package:logging/logging.dart';
import 'package:mailman/entity/credentials_entity.dart';
import 'package:mailman/model/credentials.dart';
import 'package:mailman/repository/credentials_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';

class CredentialsRestRepository extends CredentialsRepository {
  final Logger _log = Logger('CredentialsRepository');
  final ApiClient _client;

  CredentialsRestRepository(this._client);

  @override
  Future<void> init() async {}

  @override
  Future<List<Credentials>> list() async {
    try {
      _log.info('Fetching credentials');
      var response = await _client.get('/api/v1/credentials/',);
      _log.info('Fetched credentials');

      return _mapCredentialsFromJson(response['data']);
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to fetch credentials', error, stacktrace);
      return List<Credentials>.empty();
    }
  }

  @override
  Future<Credentials?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Credentials?> create(Credentials credentials) async {
    try {
      var entity = credentials.toEntity();
      var requestData = entity.toJson();
      _log.info('Creating new credentials with request data $requestData');

      var response = await _client.post('/api/v1/credentials/',
        data: requestData,
      );

      _log.info('Created credentials $response');

      return Credentials.fromEntity(
        CredentialsEntity.fromJson(response)
      );
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to create credentials', error, stacktrace);
    }
  }

  List<Credentials> _mapCredentialsFromJson(List<dynamic> json) {
    return json
        .map<Credentials>(
          (element) => Credentials.fromEntity(
        CredentialsEntity.fromJson(element as Map<String, dynamic>),
      ),
    ).toList();
  }
}


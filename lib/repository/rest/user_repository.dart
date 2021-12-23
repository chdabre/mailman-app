import 'package:logging/logging.dart';
import 'package:mailman/entity/user_entity.dart';
import 'package:mailman/model/user.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/repository/user_repository.dart';

class UserRestRepository extends UserRepository {
  final Logger _log = Logger('UserRepository');
  final ApiClient _client;

  UserRestRepository(
    this._client,
  );

  @override
  Future<void> init() async {
  }

  @override
  Future<User?> getUser() async {
    try {
      _log.info('Trying to fetch user');

      var response = await _client.get('/api/v1/auth/user/');

      _log.info('Success');

      return User.fromEntity(
          UserEntity.fromJson(Map<String, dynamic>.from(response),)
      );
    } on IOError catch (error, stacktrace) {
      _log.info('Failed to fetch user', error.data, stacktrace);
      rethrow;
    }
  }

  @override
  Future<User?> updateUser(UserEntity userEntity) async {
  }
}


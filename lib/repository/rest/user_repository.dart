import 'package:logging/logging.dart';
import 'package:mailman/entity/fcm_device.dart';
import 'package:mailman/entity/user_entity.dart';
import 'package:mailman/model/user.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/repository/user_repository.dart';
import 'package:mailman/secured_storage.dart';
import 'package:mailman/services/cloud_notification_service.dart';

import '../../platform/platform_utils.dart';

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

  @override
  Future<FCMDeviceEntity?> registerFCMId() async {
    try {
      var securedStorage = SecuredStorage();
      var notificationService = CloudNotificationService.instance;
      var entity = FCMDeviceEntity(
        deviceId: await securedStorage.getInitialDeviceId(),
        registrationId: await notificationService.getRegistrationId(),
        type: PlatformUtils.isIOS ? 'ios' : PlatformUtils.isAndroid ? 'android' : 'web',
      );
      _log.info('Trying to register FCM id $entity');

      var response = await _client.post('/api/v1/users/devices/',
          data: entity.toJson(),
      );

      _log.info('Success');

      return FCMDeviceEntity.fromJson(response);
    } on IOError catch (error, stacktrace) {
      _log.info('Failed to register FCM Id', error.data, stacktrace);
      rethrow;
    }
  }
}


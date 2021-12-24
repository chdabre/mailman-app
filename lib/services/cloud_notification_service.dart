import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

class CloudNotificationService {
  static CloudNotificationService? _instance;
  final Logger _log = Logger('CloudNotificationService');

  final _fbMessaging = FirebaseMessaging.instance;

  CloudNotificationService._();

  static CloudNotificationService get instance => _instance ??= CloudNotificationService._();

  Future<void> init() async {
    _fbMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<bool> requestNotificationPermission() async {
    _log.info("Requesting notification permissions");

    NotificationSettings settings = await _fbMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _log.info('User granted permission');
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      _log.info('User granted provisional permission');
      return true;
    }

    _log.info('User declined or has not accepted permission');
    return false;
  }

  Future<bool> hasNotificationPermissions() async {
    var settings = await _fbMessaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      return true;
    }
    return false;
  }

  Future<String?> getRegistrationId() async {
    return _fbMessaging.getToken();
  }
}
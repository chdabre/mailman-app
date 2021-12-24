import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'environment.dart';

const String _storageEnvironmentFlavorKey = 'environment_flavor';
const String _storageTokenNameKey = 'token';
const String _storageInitialAppVersionKey = 'initial_app_version';
const String _storageFirstAppOpenKey = 'first_app_open';
const String _storageInitialDeviceIdKey = 'initial_device_id';

class SecuredStorage {
  final Logger _log = Logger('SecuredStorage');
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Map<String, String?> _localCache = {};

  Future<void> initialize() async {
    // keychain is not removed on iOS but shared preferences are;
    // this is to make sure when users re-installs the app will clear everything from the previous installation
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('first_run') ?? true) {
      // backward compatibility: old users should not re-register on upgrade
      String? initialAppVersion = await getInitialAppVersion();

      bool shouldClearStorage = true;
      if (initialAppVersion != null) {
        var split = initialAppVersion.split('.');
        int version = int.parse(split[0]);
        int minor = int.parse(split[1]);
        int patch = int.parse(split[2]);

        shouldClearStorage = version >= 1 || minor >= 5 || patch >= 4;
      }

      if (shouldClearStorage) {
        _log.info('Removing token, flavor');

        await deleteToken();
        await deleteEnvironmentFlavor();
      }

      prefs.setBool('first_run', false);
    }
    try {
      // Workaround for white screen
      // https://github.com/mogol/flutter_secure_storage/issues/43
      await getInitialAppVersion();
    } on PlatformException catch (_) {
      _log.warning('Exception while initialising secured storage... '
          'Resetting storage.');
      _storage.deleteAll();
    }
  }

  Future<String?> _getString(String key) async {
    var value = _localCache[key] ?? await _storage.read(key: key);
    _localCache[key] = value;
    return value;
  }

  Future<void> _setString(String key, String? value) async {
    if (value == null) {
      await _storage.delete(key: key);
      _localCache.remove(key);
      return;
    }
    _localCache[key] = value;
    _storage.write(key: key, value: value);
  }

  Future<bool> hasToken() async {
    String? token = await getToken();
    return token != null;
  }

  Future<String?> getToken() async {
    return _getString(_storageTokenNameKey);
  }

  Future<void> persistToken(String token) async {
    await _setString(_storageTokenNameKey, token);
  }

  Future<void> deleteToken() async {
    await _setString(_storageTokenNameKey, null);
  }

  Future<bool> hasInitialAppVersion() async {
    String? appVersion = await getInitialAppVersion();
    return appVersion != null;
  }

  Future<bool> hasFirstAppOpenDateTime() async {
    String? firstAppOpenDateTime = await getFirstAppOpenDateTime();
    return firstAppOpenDateTime != null;
  }

  Future<String?> getInitialAppVersion() async {
    return _getString(_storageInitialAppVersionKey);
  }

  Future<bool> hasInitialDeviceId() async {
    String? deviceId = await getInitialDeviceId();
    return deviceId != null;
  }

  Future<String?> getInitialDeviceId() async {
    return _getString(_storageInitialDeviceIdKey);
  }

  Future<void> persistInitialDeviceId(String deviceId) async {
    await _setString(_storageInitialDeviceIdKey, deviceId);
  }

  Future<void> persistInitialAppVersion(String appVersion) async {
    await _setString(_storageInitialAppVersionKey, appVersion);
  }

  Future<void> persistFirstAppOpenDateTime(String dateTime) async {
    await _setString(_storageFirstAppOpenKey, dateTime);
  }

  Future<String?> getFirstAppOpenDateTime() async {
    return _getString(_storageFirstAppOpenKey);
  }

  Future<bool> hasEnvironment() async {
    Environment? environment = await getEnvironment();
    return environment != null;
  }

  Future<Environment?> getEnvironment() async {
    var envAsString = await _getString(_storageEnvironmentFlavorKey);
    if (envAsString == null) {
      return null;
    }

    return Environment.fromMap(json.decode(envAsString));
  }

  Future<void> persistEnvironment(Environment environment) async {
    await _setString(
      _storageEnvironmentFlavorKey,
      json.encode(environment.toMap()),
    );
  }

  Future<void> deleteEnvironmentFlavor() async {
    await _setString(_storageEnvironmentFlavorKey, null);
  }
}

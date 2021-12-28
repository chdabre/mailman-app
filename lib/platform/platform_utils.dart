// ignore_for_file: prefer_const_declarations

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

class PlatformUtils {
  static final bool isLinux = kIsWeb ? false : Platform.isLinux;
  static final bool isWeb = kIsWeb;
  static final bool isMacOS = kIsWeb ? false : Platform.isMacOS;
  static final bool isWindows = kIsWeb ? false : Platform.isWindows;
  static final bool isAndroid = kIsWeb ? false : Platform.isAndroid;
  static final bool isIOS = kIsWeb ? false : Platform.isIOS;
  static final bool isFuchsia = kIsWeb ? false : Platform.isFuchsia;
  static final String platformName = kIsWeb ? 'web' : Platform.operatingSystem;

  static final bool isMobile =
  kIsWeb ? false : (Platform.isIOS || Platform.isAndroid);

  static Future<String> get getID async =>
      isAndroid ? await _androidID() : (isIOS ? await _iOSID() : 'web');

  static Future<String> _iOSID() async =>
      (await DeviceInfoPlugin().iosInfo).identifierForVendor;

  static Future<String> _androidID() async =>
      (await DeviceInfoPlugin().androidInfo).androidId;
}

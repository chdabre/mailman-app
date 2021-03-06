// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcICN4gEgncpsnTfHKYO5-_vF_E_IhQxs',
    appId: '1:951777836444:android:19dd57abf6809529259c59',
    messagingSenderId: '951777836444',
    projectId: 'mailman-postcards',
    storageBucket: 'mailman-postcards.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0HfbtZ9-caNX7DADAHI63gZz1UUgzZsc',
    appId: '1:951777836444:ios:9a192c2ecd0b93d7259c59',
    messagingSenderId: '951777836444',
    projectId: 'mailman-postcards',
    storageBucket: 'mailman-postcards.appspot.com',
    androidClientId: '951777836444-b5qkn0of7pngdl96ia7v0buta2eladum.apps.googleusercontent.com',
    iosClientId: '951777836444-nejsm4381qfrsvc92gaekh8i1p764tu5.apps.googleusercontent.com',
    iosBundleId: 'ch.imakethings.mailman',
  );
}

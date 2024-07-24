// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '',
    appId: '1:',
    messagingSenderId: '',
    projectId: 'loadiot-3f724',
    authDomain: '',
    databaseURL: '',
    storageBucket: 'loadiot-3f724.appspot.com',
    measurementId: 'G-S7X8DGD2WW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '1:992935456108:android:2a9f3cc1ef7ab5c7571749',
    messagingSenderId: '',
    projectId: 'loadiot-3f724',
    databaseURL: '',
    storageBucket: 'loadiot-3f724.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '1:992935456108:ios:779decbd2578688b571749',
    messagingSenderId: '',
    projectId: 'loadiot-3f724',
    databaseURL: '',
    storageBucket: 'loadiot-3f724.appspot.com',
    iosBundleId: 'com.example.load',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: 'loadiot-3f724',
    databaseURL: '',
    storageBucket: 'loadiot-3f724.appspot.com',
    iosBundleId: 'com.example.load.RunnerTests',
  );
}
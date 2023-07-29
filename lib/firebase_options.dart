// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCjhTj4NO1b4R5NoSK_s92dp7njqJxHriU',
    appId: '1:803948448282:web:ab1441567fccd8327c9fa3',
    messagingSenderId: '803948448282',
    projectId: 'ysf-frappuccino-prod',
    authDomain: 'ysf-frappuccino-prod.firebaseapp.com',
    storageBucket: 'ysf-frappuccino-prod.appspot.com',
    measurementId: 'G-VVM0FN8886',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXagUi7rY-cc9QHBjGmBLAu5v4LWAt4uI',
    appId: '1:803948448282:android:85f38b612bdbb57b7c9fa3',
    messagingSenderId: '803948448282',
    projectId: 'ysf-frappuccino-prod',
    storageBucket: 'ysf-frappuccino-prod.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyXCjqxhwHwS0Gw-GEwkiLOz9UVwXclKA',
    appId: '1:803948448282:ios:4e1a1f29262d6c367c9fa3',
    messagingSenderId: '803948448282',
    projectId: 'ysf-frappuccino-prod',
    storageBucket: 'ysf-frappuccino-prod.appspot.com',
    iosClientId:
        '803948448282-4nve17llqcgc28hnqll14k8ujsjb8r5u.apps.googleusercontent.com',
    iosBundleId: 'net.ysf-frappuccino.frappuccino',
  );
}
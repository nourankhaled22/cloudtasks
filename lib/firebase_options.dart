// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB0gDh-RbsG5zMwz0jbfBCBBZGjeFzH1ko',
    appId: '1:607541438976:web:ca83c18cff1605686946e5',
    messagingSenderId: '607541438976',
    projectId: 'nournotifyapp',
    authDomain: 'nournotifyapp.firebaseapp.com',
    storageBucket: 'nournotifyapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFFx3h5pzVu7Ec-vxpXIVAaBeEcm9WhJM',
    appId: '1:607541438976:android:c7866774a788f4c06946e5',
    messagingSenderId: '607541438976',
    projectId: 'nournotifyapp',
    storageBucket: 'nournotifyapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmD_I_trNlzuVzfrRBCohGm6LZM5hzpuo',
    appId: '1:607541438976:ios:34ac0d6cfba171766946e5',
    messagingSenderId: '607541438976',
    projectId: 'nournotifyapp',
    storageBucket: 'nournotifyapp.firebasestorage.app',
    iosBundleId: 'com.example.notify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmD_I_trNlzuVzfrRBCohGm6LZM5hzpuo',
    appId: '1:607541438976:ios:34ac0d6cfba171766946e5',
    messagingSenderId: '607541438976',
    projectId: 'nournotifyapp',
    storageBucket: 'nournotifyapp.firebasestorage.app',
    iosBundleId: 'com.example.notify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB0gDh-RbsG5zMwz0jbfBCBBZGjeFzH1ko',
    appId: '1:607541438976:web:3de150afaf96fc756946e5',
    messagingSenderId: '607541438976',
    projectId: 'nournotifyapp',
    authDomain: 'nournotifyapp.firebaseapp.com',
    storageBucket: 'nournotifyapp.firebasestorage.app',
  );
}

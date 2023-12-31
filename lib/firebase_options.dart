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
    apiKey: 'AIzaSyC1_0mFFiYsPgirXuPCIKnSPqUtO62p-1E',
    appId: '1:487897094521:web:4377f0a811a05674ae37a8',
    messagingSenderId: '487897094521',
    projectId: 'soundsphere-2023',
    authDomain: 'soundsphere-2023.firebaseapp.com',
    storageBucket: 'soundsphere-2023.appspot.com',
    measurementId: 'G-WFRXYZLK6S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYjqk2HfLh4sDLsD0-S5u1vfcGjl3Hhhs',
    appId: '1:487897094521:android:886c9e80e8a6bf20ae37a8',
    messagingSenderId: '487897094521',
    projectId: 'soundsphere-2023',
    storageBucket: 'soundsphere-2023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDAD92wsX08aBF_DALLWWWfVB7yIX8axE',
    appId: '1:487897094521:ios:4d07a1f67b8c13aeae37a8',
    messagingSenderId: '487897094521',
    projectId: 'soundsphere-2023',
    storageBucket: 'soundsphere-2023.appspot.com',
    iosBundleId: 'com.example.SoundSphere',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDAD92wsX08aBF_DALLWWWfVB7yIX8axE',
    appId: '1:487897094521:ios:d40cf4278d3ea363ae37a8',
    messagingSenderId: '487897094521',
    projectId: 'soundsphere-2023',
    storageBucket: 'soundsphere-2023.appspot.com',
    iosBundleId: 'com.example.SoundSphere.RunnerTests',
  );
}

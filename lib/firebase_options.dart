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
    apiKey: 'AIzaSyDppwlSmneUUBuNCSKXDK632104eT6fngk',
    appId: '1:686273089557:web:3aa0afffca3a2309257e1c',
    messagingSenderId: '686273089557',
    projectId: 'dyota-9a490',
    authDomain: 'dyota-9a490.firebaseapp.com',
    storageBucket: 'dyota-9a490.appspot.com',
    measurementId: 'G-DZKEGWJ4GP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXxzeNG74wKmQNmYqWOW0e0VilUQ9xdwM',
    appId: '1:686273089557:android:e95be09a04fd9f65257e1c',
    messagingSenderId: '686273089557',
    projectId: 'dyota-9a490',
    storageBucket: 'dyota-9a490.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKnx0iSMDUyp-dwBq35gJuX-POJePdzdY',
    appId: '1:686273089557:ios:ceb7be951713a53f257e1c',
    messagingSenderId: '686273089557',
    projectId: 'dyota-9a490',
    storageBucket: 'dyota-9a490.appspot.com',
    iosBundleId: 'com.example.dyota',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKnx0iSMDUyp-dwBq35gJuX-POJePdzdY',
    appId: '1:686273089557:ios:e8594a066d8fe6b8257e1c',
    messagingSenderId: '686273089557',
    projectId: 'dyota-9a490',
    storageBucket: 'dyota-9a490.appspot.com',
    iosBundleId: 'com.example.dyota.RunnerTests',
  );
}

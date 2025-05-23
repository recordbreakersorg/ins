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
    apiKey: 'AIzaSyD46bEORPmEdAwt3qmknaI-NOdjLeyzkqI',
    appId: '1:825679026565:web:e548108e78baf72a51ccec',
    messagingSenderId: '825679026565',
    projectId: 'intranet-of-schools',
    authDomain: 'intranet-of-schools.firebaseapp.com',
    storageBucket: 'intranet-of-schools.firebasestorage.app',
    measurementId: 'G-B1F8Y6G9JP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA09Z9t3uA5c2XFVnQnPUFr0x0Y9MM_sZs',
    appId: '1:825679026565:android:7a78426133e769e151ccec',
    messagingSenderId: '825679026565',
    projectId: 'intranet-of-schools',
    storageBucket: 'intranet-of-schools.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4dSFrcgD1grtcOPRAHVH24uguRNv1CHs',
    appId: '1:825679026565:ios:5c0543657f25fc6751ccec',
    messagingSenderId: '825679026565',
    projectId: 'intranet-of-schools',
    storageBucket: 'intranet-of-schools.firebasestorage.app',
    iosClientId:
        '825679026565-ofd8h39r51kdcp8m0kjureq8o88jsfc0.apps.googleusercontent.com',
    iosBundleId: 'com.example.ins',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4dSFrcgD1grtcOPRAHVH24uguRNv1CHs',
    appId: '1:825679026565:ios:5c0543657f25fc6751ccec',
    messagingSenderId: '825679026565',
    projectId: 'intranet-of-schools',
    storageBucket: 'intranet-of-schools.firebasestorage.app',
    iosClientId:
        '825679026565-ofd8h39r51kdcp8m0kjureq8o88jsfc0.apps.googleusercontent.com',
    iosBundleId: 'com.example.ins',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD46bEORPmEdAwt3qmknaI-NOdjLeyzkqI',
    appId: '1:825679026565:web:5feefc884170b88c51ccec',
    messagingSenderId: '825679026565',
    projectId: 'intranet-of-schools',
    authDomain: 'intranet-of-schools.firebaseapp.com',
    storageBucket: 'intranet-of-schools.firebasestorage.app',
    measurementId: 'G-PXRCW0SJQ0',
  );
}

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUiIiYO8b3KXhA24JXycNDRunS2a1Avis',
    appId: '1:539677818693:android:fb771587509264182f482c',
    messagingSenderId: '539677818693',
    projectId: 'animators-918eb',
    databaseURL: 'https://animators-918eb-default-rtdb.firebaseio.com',
    storageBucket: 'animators-918eb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTuOiIdkTCCGofyvDF2GrqLRjbqrCJn4Y',
    appId: '1:539677818693:ios:69298cc0e367d2682f482c',
    messagingSenderId: '539677818693',
    projectId: 'animators-918eb',
    databaseURL: 'https://animators-918eb-default-rtdb.firebaseio.com',
    storageBucket: 'animators-918eb.appspot.com',
    iosClientId: '539677818693-pnevookmfi4ae2vi69p1t3vkcor17amj.apps.googleusercontent.com',
    iosBundleId: 'org.animators.main.animators',
  );
}

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  // ------------------------------
  //           WEB CONFIG
  // ------------------------------
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyXXXXXXX_REDACTED_WEB_XXXXXXXXXXXX',
    appId: '1:XXXXXXXXXXXX:web:XXXXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );

  // ------------------------------
  //         ANDROID CONFIG
  // ------------------------------
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyXXXXXXX_REDACTED_ANDROID_XXXXXXXX',
    appId: '1:XXXXXXXXXXXX:android:XXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.firebasestorage.app',
  );

  // ------------------------------
  //            iOS CONFIG
  // ------------------------------
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY_REDACTED',
    appId: '1:YOUR_APP_ID:ios:YOUR_IOS_APP_ID_REDACTED',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    iosBundleId: 'com.example.app',
    storageBucket: 'your-project-id.appspot.com',
  );

  // ------------------------------
  //           macOS CONFIG
  // ------------------------------
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY_REDACTED',
    appId: '1:YOUR_APP_ID:macos:YOUR_MACOS_APP_ID_REDACTED',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    iosBundleId: 'com.example.app',
    storageBucket: 'your-project-id.appspot.com',
  );
}
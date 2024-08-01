import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAV1oR9r7TQmQw5vdbGvLB15p77frJpfYU',
    appId: '1:184635870224:android:4a467d8645ad99f8b44e95',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'dodiddone-3-f090d',
    authDomain: 'YOUR_AUTH_DOMAIN',
    storageBucket: 'dodiddone-3-f090d.appspot.com',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAV1oR9r7TQmQw5vdbGvLB15p77frJpfYU',
    appId: '1:184635870224:android:4a467d8645ad99f8b44e95',
    messagingSenderId: '184635870224',
    projectId: 'dodiddone-3-f090d',
    storageBucket: 'dodiddone-3-f090d.appspot.com',
  );
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfigs {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        appId: '1:130824903512:wed:adf313bd92851f69f1232d',
        apiKey: 'AIzaSyCvoutHM-qRCo21PYkriPK398CpVTAunmw',
        projectId: 'quiz-app-b1910465',
        messagingSenderId: '130824903512',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:130824903512:ios:adf313bd92851f69f1232d',
        apiKey: 'AIzaSyCvoutHM-qRCo21PYkriPK398CpVTAunmw',
        projectId: 'quiz-app-b1910465',
        messagingSenderId: '130824903512',
        iosBundleId: 'io.flutter.plugins.firebasecoreexample',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:130824903512:android:adf313bd92851f69f1232d',
        apiKey: 'AIzaSyCvoutHM-qRCo21PYkriPK398CpVTAunmw',
        projectId: 'quiz-app-b1910465',
        messagingSenderId: '130824903512',
      );
    }
  }
}

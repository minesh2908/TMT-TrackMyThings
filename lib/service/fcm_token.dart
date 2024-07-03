import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FCMToken {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  Future<String?>? getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    log(token.toString());

    _firebaseMessaging.onTokenRefresh.listen((event) async {
      log('Event - $event');
    });
    return token;
  }
}

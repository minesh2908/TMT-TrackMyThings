import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:track_my_things/util/permission.dart';

class NotificationService {
  static final _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<dynamic> localNotification() async {
    await notificationPermission();

    const initializeSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    final initializationSettings = InitializationSettings(
      android: initializeSettingAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    await _flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    //calling background notification
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessages);

    //on background notification tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Background Notification Tapped');
        //here we can add navigation for going to specific page or item
      }
    });

    //For foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final payLoad = jsonEncode(message.data);
      print('Got a message in foreground');
      if (message.notification != null) {
        showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payLoad,
        );
      }
    });
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {}

  //initializing background notification
  static Future<dynamic> _firebaseBackgroundMessages(
    RemoteMessage message,
  ) async {
    if (message.notification != null) {
      print('Some Notification Received in background');
    }
  }

  //show a simple notification helping in showing notification in foreground state
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  //for handling in terminated state

  static Future showNotificationFromTerminatedState() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print('Notification from Terminated State');
      Future.delayed(const Duration(seconds: 1), () {});
    }
  }
}

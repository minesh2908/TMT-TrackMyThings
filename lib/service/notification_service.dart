import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:track_my_things/main.dart';
import 'package:track_my_things/routes/routes_names.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<dynamic> requestNotificationPermission() async {
    final notificationPermission = await _firebaseMessaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );

    if (notificationPermission.authorizationStatus ==
        AuthorizationStatus.authorized) {
      log('Permission granted success');
    } else if (notificationPermission.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('Provisional permission granted');
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
      log('Permission granted failed');
    }
  }

  Future<String?>? getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    log(token.toString());

    _firebaseMessaging.onTokenRefresh.listen((event) async {
      log('Event - $event');
    });
    return token;
  }

  static Future<dynamic> initLocalNotification() async {
    log('Local notification called');
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    const initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open Notification');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions();
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed(RoutesName.aboutMe, arguments: notificationResponse);
  }

  //Function to listen foreground notifications
  static Future<dynamic> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    log('Simple notifications');
    const androidNotificationDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'Test Channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

//Function to listen background notifications
  static Future<dynamic> firebaseBackgroundMessageNotification(
    RemoteMessage message,
  ) async {
    if (message.notification != null) {
      log('Some notification received in background');
    }
  }

  //Function to listen terminated notifications

  static Future<dynamic> firebaseTerminatedMessageNotification() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      log('Notification from terminated state');
      Future.delayed(const Duration(seconds: 1), () {
        navigatorKey.currentState!
            .pushNamed(RoutesName.aboutMe, arguments: message);
      });
    }
  }
}

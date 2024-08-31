import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  // Check if the device is running Android 13 or above
  if (Platform.isAndroid && (await _isAndroid13OrAbove())) {
    final status = await Permission.photos.status;
    if (status.isDenied || status.isRestricted) {
      await openAppSettings();
      final result = await Permission.photos.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      return true;
    }
  } else {
    // For Android versions below 13
    final status = await Permission.storage.status;
    if (status.isDenied || status.isRestricted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return true;
    }
  }
}

Future<bool> _isAndroid13OrAbove() async {
  try {
    // Obtain the Android SDK version

    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    final sdkInt = deviceInfo.version.sdkInt;
    log(sdkInt.toString());
    if (sdkInt >= 33) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<String> notificationPermission() async {
  final firebaseMessaging = FirebaseMessaging.instance;
  {
    await firebaseMessaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );
    final userToken = await firebaseMessaging.getToken();
    log('Device Token : $userToken');
    return userToken!;
  }
}

Future<bool> isNotificationOn() async {
  if (await Permission.notification.isGranted) {
    return true;
  } else {
    return false;
  }
}

Future<void> stopNotificationPermission() async {
  if (await isNotificationOn()) {
    await openAppSettings();
  }
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    await openAppSettings();
  } else {
    await Permission.notification.isGranted;
  }
}

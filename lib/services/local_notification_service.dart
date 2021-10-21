import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class localNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializaitonSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    var initializaitonSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializaitonSettingsAndroid, iOS: initializaitonSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (
      String payload,
    ) async {
      if (payload != null) {
        debugPrint('notification payload $payload');
        print(payload);
        // Navigator.of(context).pushNamed(payload);
        Navigator.of(context).pop();
      }
    });
  }

  static void display(Map<String, dynamic> message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Fyrework",
          "Fyrework",
          "GIGS BY HUMANS FOR HUMANS",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      );
      await _notificationsPlugin.show(
        id,
        message['notification']['title'],
        message['notification']['body'],
        notificationDetails,
        payload: message['data']['route'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

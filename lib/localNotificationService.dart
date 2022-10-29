import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    print('uwevfwjfvewjefvwja');
    // return NotificationDetails(
    //     android: AndroidNotificationDetails(
    //   'channel id',
    //   'channel name',
    //   channelDescription: 'channel description',
    //   importance: Importance.max,
    //   enableVibration: true
    // ));
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    final details = await _notificationDetails();
    return _notifications.show(id, title, body, details, payload: payload);
  }

  // Future<void> intitialize() async {
  //   const AndroidInitializationSettings androidInitializationSettings =
  //       AndroidInitializationSettings("@drawable/ic_launcher");
  //   const iosi
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(android: androidInitializationSettings);

  //   await FlutterLocalNotificationsPlugin().initialize(initializationSettings, )
  // }
}

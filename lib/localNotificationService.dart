import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as timezone;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    timezone.initializeTimeZones();
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    await _notifications.initialize(settings);
  }

  static AndroidNotificationDetails _getAndroidNotificationDetails() {
    return const AndroidNotificationDetails(
      "0",
      "habit_tracker",
      importance: Importance.max,
      priority: Priority.defaultPriority,
    );
  }

  // static Future showNotificationsDaily(
  //     {required int id,
  //     String? title,
  //     String? body,
  //     String? payload,
  //     required DateTime reminderTime}) async {
  //   _notifications.showDailyAtTime(
  //       id,
  //       title,
  //       body,
  //       Time(reminderTime.hour, reminderTime.minute),
  //       NotificationDetails(
  //           android: _getAndroidNotificationDetails(),
  //           iOS: const DarwinNotificationDetails()),
  //       payload: payload);
  // }

  static Future showScheduledNotification(
      {required int id,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledTime}) async {
      // scheduledTime.subtract(const Duration(days: 1));
    _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
            android: _getAndroidNotificationDetails(),
            iOS: const DarwinNotificationDetails()),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
  }

  static cancelNotifcation(int notificationId){
    _notifications.cancel(notificationId);
  }
}

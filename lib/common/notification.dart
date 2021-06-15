import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// ローカル通知
int scheduleLocalNotification(Duration duration) {
  print('notification scheduled.');
  FlutterLocalNotificationsPlugin().initialize(InitializationSettings(
    android: AndroidInitializationSettings('app_icon'),
    iOS: IOSInitializationSettings(),
  ));
  int notificationId = DateTime.now().hashCode;
  FlutterLocalNotificationsPlugin().zonedSchedule(
    notificationId,
    'Hello',
    ':) :) :)',
    tz.TZDateTime.now(tz.local).add(duration),
    NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max, priority: Priority.high),
      iOS: IOSNotificationDetails(),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
  );
  return notificationId;
}

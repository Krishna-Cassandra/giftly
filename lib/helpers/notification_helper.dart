import 'dart:async';
import 'package:giftly/helpers/db_helper.dart';

void scheduleNotification({
  required DateTime triggerTime,
  required String notificationMessage,
}) {
  final delay = triggerTime.difference(DateTime.now());
  if (delay.isNegative) return;

  Timer(delay, () {
    print("Timer triggered for notification: $notificationMessage");
    DbHelper.insertNotification(notificationMessage);
  });
}


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     const AndroidInitializationSettings androidInitialization =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitialization);

//     _notificationsPlugin.initialize(initializationSettings);
//     tz.initializeTimeZones();
//   }

//   static Future<void> scheduleNotification(
//       int id, String title, String body, DateTime scheduledTime) async {
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'reminder_channel',
//           'Reminder Notifications',
//           channelDescription: 'Channel for reminder notifications',
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   static Future<void> cancelNotification(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }
// }

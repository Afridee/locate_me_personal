import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void scheduleAlarm(DateTime scheduledNotificationDateTime, int ID, String title, String body) async {

  tz.initializeTimeZones();
/*  final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));*/

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'Todo_notif',
    'Todo_notif',
    'Channel for Todo notification',
    icon: 'locate_me_icon',
    sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    largeIcon: DrawableResourceAndroidBitmap('locate_me_icon'),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);


  await flutterLocalNotificationsPlugin.zonedSchedule(
      ID,
      title,
      body,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local).add(const Duration(seconds: 0)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime);
}
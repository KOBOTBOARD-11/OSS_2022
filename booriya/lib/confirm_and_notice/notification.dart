import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
showNotification() async {
  var android = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high);

  var ios = IOSNotificationDetails();
  var detail = NotificationDetails(android: android, iOS: ios);

  await notifications.show(
    0,
    '단일 Notification',
    '단일 Notification 내용',
    detail,
    payload: 'Hello Flutter',
  );
}

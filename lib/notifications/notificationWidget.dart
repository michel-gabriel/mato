import 'package:my_mato/notifications/message.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



final notifications = FlutterLocalNotificationsPlugin();

  void showNotification() {
    showOngoingNotification(notifications,
        title: 'Break Approaching', body: '30 seconds until your break!');
  }

  void showBreakNotification() {
    showOngoingNotification(notifications,
        title: 'Break Ending', body: '30 seconds until your break is over!');
  }
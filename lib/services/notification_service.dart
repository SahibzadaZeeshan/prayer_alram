import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  void initNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Prayer time notifications',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFFFFFFFF),
          importance: NotificationImportance.High,

        ),
      ],
    );
  }

  void scheduleNotification(String title, String body, DateTime dateTime) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }
}


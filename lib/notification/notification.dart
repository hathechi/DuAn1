import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'channel_name',
          channelDescription: 'description',
          priority: Priority.max,
          playSound: true,
          importance: Importance.max),
    );
  }

  static Future<void> intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidInitializationSettings);
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    // String? payload,
  }) async =>
      await _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
      );
}

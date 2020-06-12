import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.az.medeasy', 'medeasy', 'notification');
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flnp.show(0, 'Title', 'Boby', platformChannelSpecifics,
        payload: 'This is Payload');
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime dateTime) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.az.medeasy', 'medeasy', 'notification');
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flnp.schedule(id, title, body, dateTime, platformChannelSpecifics);
    print('Added schedule notification $id');
  }

  Future<void> showDailyAtTime(int id, String title, String body, DateTime dateTime) async {
    Time time = Time(dateTime.hour, dateTime.minute, 0);
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('com.az.medeasy', 'medeasy', 'notification');
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flnp.showDailyAtTime(id, title, body, time, platformChannelSpecifics);
  }

  Future<void> cancelNotification(int id)async{
    await flnp.cancel(id);
  }
}

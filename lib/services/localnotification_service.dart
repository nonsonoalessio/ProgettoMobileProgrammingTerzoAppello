import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNoti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = null;
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails('channelId', 'channelName',
            playSound: true,
            // sound: RawResourceAndroidNotificationSound('notification'),
            importance: Importance.max,
            priority: Priority.high);

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails());
    await fln.show(0, title, body, not);
  }
}

/* Il bottone dovrà essere:
child: ElevatedButton(
  onPressed(){
     LocalNoti.showBigTextNotification(title, body, fln: flutterLocalNotificationsPlugin);
  }, child: Text("click"),
),
*/
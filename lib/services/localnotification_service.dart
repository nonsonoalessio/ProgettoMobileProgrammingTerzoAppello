import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNoti {
  final FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Configurazione per Android
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    // Configurazione per iOS
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // Inizializzazione delle notifiche
    await flp.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
    }

    notificationDetails() {
      return const NotificationDetails(
          android: AndroidNotificationDetails('channelId', 'channelName',
              importance: Importance.max),
          iOS: DarwinNotificationDetails());
  }

  Future showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    return flp.show(id, title, body, await notificationDetails());
  }
}

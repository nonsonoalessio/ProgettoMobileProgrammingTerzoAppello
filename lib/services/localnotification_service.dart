import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNoti {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin) async {
    // Configurazione per Android
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');

    // Configurazione per iOS
    const IOSInitializationSettings iOSInitialize = IOSInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);

    // Inizializzazione delle notifiche
    await flutterLocalNotificationPlugin.initialize(initializationSettings);

    // Richiesta permessi per iOS
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    // Configurazione specifica per Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    // Configurazione specifica per iOS
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true, 
      presentSound: true, 
    );

    // Configurazione complessiva delle notifiche
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Mostra la notifica
    await fln.show(id, title, body, platformChannelSpecifics, payload: payload);
  }
}

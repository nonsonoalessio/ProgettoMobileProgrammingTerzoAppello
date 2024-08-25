import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:progetto_mobile_programming/services/localnotification_service.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    
    // Inizializzazione del plugin per le notifiche locali
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await LocalNoti.initialize(flutterLocalNotificationsPlugin);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while in foreground!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message.data}');

      // Mostra la notifica usando flutter_local_notifications
      LocalNoti.showBigTextNotification(
        title: message.notification?.title ?? 'Nessun titolo',
        body: message.notification?.body ?? 'Nessun contenuto',
        fln: flutterLocalNotificationsPlugin,
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<DeviceNotification> _notifications = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SafeArea(
        child: ListView.builder(
          // ignora per ora l'eccezione, dobbiamo definire i model prima
          itemBuilder: (context, index) =>
              NotificationCard(notification: _notifications[index]),
        ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final DeviceNotification notification;
  const NotificationCard({super.key, required this.notification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Qui si implementa la singola notifica."),
    );
  }
}

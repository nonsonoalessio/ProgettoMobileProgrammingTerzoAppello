import 'package:flutter/material.dart';

import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<DeviceNotification> _notifications = [
    DeviceNotification(
      title: "Titolo 1",
      description: "Testo notifica 1",
      device: Light(deviceName: 'Luce di emergenza', room: '1'),
      type: NotificationType.security,
      deliveryTime: DateTime.now().millisecondsSinceEpoch,
      isRead: false,
    ),
    DeviceNotification(
      title: "Titolo 2",
      description: "Testo notifica 2",
      device: Thermostat(
          deviceName: 'Termostato cucina',
          room: '1',
          desiredTemp: 25,
          detectedTemp: 30),
      type: NotificationType.automationExecution,
      deliveryTime: DateTime.now().millisecondsSinceEpoch,
      isRead: true,
    ),
  ];

  void _markAsRead(DeviceNotification notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifiche'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              // Quando una notifica non letta viene cliccata, la segniamo come letta
              if (!_notifications[index].isRead) {
                _markAsRead(_notifications[index]);
              }
              // Naviga pagina dettagli
            },
            child: NotificationCard(notification: _notifications[index]),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final DeviceNotification notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: notification.isRead
                ? Colors.grey
                : Colors
                    .green, // Mostra icona verde per le notifiche non lette e icona grigia per le notifiche già lette
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  notification.description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: notification.isRead ? Colors.grey : Colors.black,
                  ),
                )
              ],
            ),
          ),
          if (!notification.isRead)
            Icon(
              Icons.circle,
              color: Colors.orange, // Notifiche non lette = pallino arancione
              size: 12.0,
            ),
        ],
      ),
    );
  }
}

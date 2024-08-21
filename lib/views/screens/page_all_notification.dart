import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:progetto_mobile_programming/providers/notifications_provider.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  /*
  final List<DeviceNotification> _notifications = [
    DeviceNotification(
      title: "Titolo 1",
      description: "Testo notifica 1",
      device: Light(deviceName: 'Luce di emergenza', room: '1',
      id: 
      ),
      type: NotificationType.security,
      deliveryTime: DateTime.now().millisecondsSinceEpoch,
      isRead: false,
    ),
  ];
*/

  void _markAsRead(DeviceNotification notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsList = ref.watch(notificationsNotifierProvider);

    print(notificationsList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifiche'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: notificationsList.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              // Quando una notifica non letta viene cliccata, la segniamo come letta
              if (!notificationsList[index].isRead) {
                _markAsRead(notificationsList[index]);
              }
              // Naviga pagina dettagli
            },
            child: NotificationCard(notification: notificationsList[index]),
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
      padding: const EdgeInsets.all(16.0),
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
          const SizedBox(width: 16.0),
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
                const SizedBox(height: 4.0),
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
            const Icon(
              Icons.circle,
              color: Colors.orange, // Notifiche non lette = pallino arancione
              size: 12.0,
            ),
        ],
      ),
    );
  }
}

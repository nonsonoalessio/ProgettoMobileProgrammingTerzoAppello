import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/providers/notifications_provider.dart';
import 'package:progetto_mobile_programming/views/screens/page_device_detail.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  void _markAsRead(DeviceNotification notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _navigateToDeviceDetail(Device device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailPage(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationsList = ref.watch(notificationsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifiche'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: notificationsList.length,
          itemBuilder: (context, index) {
            final notification = notificationsList[index];
            return GestureDetector(
              onTap: () {
                // Quando una notifica non letta viene cliccata, la segniamo come letta
                if (!notification.isRead) {
                  _markAsRead(notification);
                }
                // Naviga alla pagina di dettaglio del dispositivo associato
                _navigateToDeviceDetail(notification.device);
              },
              child: NotificationCard(notification: notification),
            );
          },
        ),
      ),
    );
  }
}


class NotificationCard extends StatelessWidget {
  final DeviceNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

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
                : Colors.green, // Mostra icona verde per le notifiche non lette e icona grigia per le notifiche già lette
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${notification.title} - ${notification.device.deviceName}",
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
                ),
                const SizedBox(height: 4.0),
                Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(notification.deliveryTime),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Logica per eliminare la notifica
            },
          ),
          PopupMenuButton<NotificationType>(
            onSelected: (NotificationType type) {
              // Logica per categorizzare la notifica
            },
            itemBuilder: (BuildContext context) {
              return NotificationType.values.map((NotificationType type) {
                return PopupMenuItem<NotificationType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList();
            },
            icon: const Icon(Icons.category),
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
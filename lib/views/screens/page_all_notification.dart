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
  // TODO: opera con provider anziché state locale
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

// stato: notificaLetta (bool), Set<String> categories
class NotificationCard extends StatefulWidget {
  final DeviceNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
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
            color: widget.notification.isRead ? Colors.grey : Colors.green,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the notification title and device name
                Text(
                  "${widget.notification.title} - ${widget.notification.device.deviceName}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: widget.notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                // Display the notification description
                Text(
                  widget.notification.description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                        widget.notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                // Display the notification delivery time
                Text(
                  MaterialLocalizations.of(context)
                      .formatTimeOfDay(widget.notification.deliveryTime),
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                        widget.notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                // Display the notification category
                Text(
                  "Category: ", // New line to display category
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                        widget.notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Logic to delete the notification
            },
          ),
          PopupMenuButton<NotificationType>(
            onSelected: (NotificationType type) {
              // Logic to categorize the notification
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
          if (!widget.notification.isRead)
            const Icon(
              Icons.circle,
              color: Colors.orange,
              size: 12.0,
            ),
        ],
      ),
    );
  }
}

class CategoriesChooserModal extends ConsumerStatefulWidget {
  // final ValueChanged<List<String>> onValueChanged;
  const CategoriesChooserModal({super.key});

  @override
  ConsumerState<CategoriesChooserModal> createState() =>
      _CategoriesChooserModalState();
}

class _CategoriesChooserModalState
    extends ConsumerState<CategoriesChooserModal> {
  @override
  Widget build(BuildContext context) {
    // Set<String> categories = ref.watch(NotificationCategoriesNotifierProvider);
    return const Placeholder();
  }
}

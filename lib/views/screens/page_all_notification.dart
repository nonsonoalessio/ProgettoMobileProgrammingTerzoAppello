import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
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

  void _deleteNotification(DeviceNotification notification) {
    ref.read(notificationsNotifierProvider.notifier).deleteNotification(notification);
    // Notify Flutter that the state has changed
    setState(() {});
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
                if (!notification.isRead) {
                  _markAsRead(notification);
                  ref.read(notificationsNotifierProvider.notifier).markNotificationAsRead(notification);
                }
                _navigateToDeviceDetail(notification.device);
              },
              child: NotificationCard(
                notification: notification,
                onDelete: () => _deleteNotification(notification),
              ),
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
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  void _chooseCategories() async {
    // Open the categories chooser modal and wait for the selected categories
    final selectedCategories = await showDialog<List<String>>(
      context: context,
      builder: (context) => CategoriesChooserModal(
        selectedCategories: widget.notification.categories,
      ),
    );

    // If the user confirmed their selection, update the notification categories
    if (selectedCategories != null) {
      setState(() {
        widget.notification.categories = selectedCategories.toSet();
      });
    }
  }

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
                Text(
                  widget.notification.description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget.notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  MaterialLocalizations.of(context)
                      .formatTimeOfDay(widget.notification.deliveryTime),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget.notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Category: ${widget.notification.categories.join(', ')}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget.notification.isRead ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onDelete,
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _chooseCategories, // Open the categories chooser modal
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
  final Set<String> selectedCategories;

  const CategoriesChooserModal({
    super.key,
    required this.selectedCategories,
  });

  @override
  ConsumerState<CategoriesChooserModal> createState() =>
      _CategoriesChooserModalState();
}

class _CategoriesChooserModalState
    extends ConsumerState<CategoriesChooserModal> {
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the categories from the provider
    final categories = ref.watch(notificationCategoriesNotifierProvider);

    return AlertDialog(
      title: const Text('Select Categories'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories.elementAt(index);
            final isSelected = _selectedCategories.contains(category);

            return CheckboxListTile(
              title: Text(category),
              value: isSelected,
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null), // Cancel the selection
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () =>
              Navigator.pop(context, _selectedCategories.toList()), // Confirm selection
          child: const Text('OK'),
        ),
      ],
    );
  }
}


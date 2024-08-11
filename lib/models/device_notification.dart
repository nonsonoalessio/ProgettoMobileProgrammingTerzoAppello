import 'package:progetto_mobile_programming/models/device.dart';

enum NotificationType { security, automationExecution, highEnergyConsumption }

class DeviceNotification {
  String title;
  String description; // Added description for the notification content
  Device device;
  NotificationType type;
  int deliveryTime;
  bool isRead; // Added to track whether the notification is read

  DeviceNotification({
    required this.title,
    required this.description, // Initialize description
    required this.device,
    required this.type,
    required this.deliveryTime,
    this.isRead = false, // Default to unread
  });
}

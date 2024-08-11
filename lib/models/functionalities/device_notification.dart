import 'package:progetto_mobile_programming/models/objects/device.dart';

enum NotificationType { security, automationExecution, highEnergyConsumption }

class DeviceNotification {
  String title;
  Device device;
  NotificationType type;
  int deliveryTime;
  bool isRead;
  String description;

  DeviceNotification({
    required this.title,
    required this.device,
    required this.type,
    required this.deliveryTime,
    this.isRead = false,
    this.description = "",
  });

  /*
  factory DeviceNotification.fromMap(Map<String, dynamic> map) {
    return DeviceNotification(
      title: map['deviceName'] as String,
      device: map['room'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {'deviceName': deviceName, 'room': room, 'isActive': isActive};
  }
  */
}

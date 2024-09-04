import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'dart:math';

enum NotificationType { security, automationExecution, highEnergyConsumption }

class DeviceNotification {
  int id;
  String title;
  Device device;
  TimeOfDay deliveryTime;
  bool isRead;
  String description;
  Set<String> categories;

  DeviceNotification(
      {required this.id,
      required this.title,
      required this.device,
      required this.deliveryTime,
      this.isRead = false,
      this.description = "",
      categories})
      : categories = categories ?? {};

  static int generateUniqueId() {
    final int timestamp =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final int randomPart = Random().nextInt(1000);
    return (timestamp % 1000000) * 1000 + randomPart;
  }

  DeviceNotification._fromMap(
      {required this.id,
      required this.title,
      required this.device,
      required this.deliveryTime,
      this.isRead = false,
      this.description = "",
      categories})
      : categories = categories ?? {};

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'device': device.toMap(),
      'deliveryTime': deliveryTime,
      'isRead': isRead ? 1 : 0,
      'description': description,
    };
  }
}

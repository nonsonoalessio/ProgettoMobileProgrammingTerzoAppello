import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

part 'notifications_provider.g.dart';

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  DatabaseHelper db = DatabaseHelper.instance;
  // campo non final: per ogni operazione, viene riassegnata una nuova lista

  List<DeviceNotification> notifications = [];

  Future<void> _initStatus() async {
    // await db.fetchDevices();
    // await db.fetchAutomations();
    await db.fetchNotifications();
    // await db.fetchIndex();

    // si sfrutta il passaggio per riferimento, quindi non viene allocata una nuova lista
    // piuttosto, viene passato l'indirizzo di memoria della lista presente in DbHelper
    // devices = db.devices;
    // automations = db.automations;
    state = db.notifications;
    //lastIndexForId = db.lastIndexForId;
  }

  @override
  List<DeviceNotification> build() {
    _initStatus();
    return notifications;
  }

  void addNotification(DeviceNotification notification) {
    _addNotificationToDb(notification);
    _initStatus();
  }

  Future<void> _addNotificationToDb(DeviceNotification notification) async {
    await db.insertNotification(notification);
  }

  Future<void> _markNotificationAsRead(DeviceNotification notification) async {
    await db.updateNotification(notification.id);
  }

  Future<void> _deleteNotification(DeviceNotification notification) async {
    await db.removeNotification(notification.id);
  }
}

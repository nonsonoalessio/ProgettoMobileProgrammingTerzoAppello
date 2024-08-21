import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

part 'notifications_provider.g.dart';

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  DatabaseHelper db = DatabaseHelper.instance;
  // campo non final: per ogni operazione, viene riassegnata una nuova lista

  List<DeviceNotification> notifications = [];

  Future<void> initStatus() async {
    // await db.fetchDevices();
    // await db.fetchAutomations();
    await db.fetchNotifications();
    // await db.fetchIndex();

    // si sfrutta il passaggio per riferimento, quindi non viene allocata una nuova lista
    // piuttosto, viene passato l'indirizzo di memoria della lista presente in DbHelper
    // devices = db.devices;
    // automations = db.automations;
    notifications = db.notifications;
    //lastIndexForId = db.lastIndexForId;
  }

  @override
  List<DeviceNotification> build() {
    initStatus();
    return notifications;
  }
}

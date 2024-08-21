import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

part 'devices_provider.g.dart';

@riverpod
class DeviceNotifier extends _$DeviceNotifier {
  DatabaseHelper db = DatabaseHelper.instance;
  // campo non final: per ogni operazione, viene riassegnata una nuova lista
  List<Device> devices = [];
  //List<Automation> automations = [];
  //List<Notification> notifications = [];
  //int lastIndexForId;

  Future<void> initStatus() async {
    await db.fetchDevices();
    // await db.fetchAutomations();
    // await db.fetchNotifications();
    // await db.fetchIndex();

    // si sfrutta il passaggio per riferimento, quindi non viene allocata una nuova lista
    // piuttosto, viene passato l'indirizzo di memoria della lista presente in DbHelper
    devices = db.devices;
    //automations = db.automations;
    //notifications = db.notifications;
    //lastIndexForId = db.lastIndexForId;
  }

  @override
  List<Device> build() {
    initStatus();
    return devices;
  }
}

@riverpod
Set<String> rooms(ref) {
  List<Device> devices = ref.watch(deviceNotifierProvider);
  final Set<String> rooms = {};
  for (Device d in devices) {
    rooms.add(d.room);
  }
  return rooms;
}

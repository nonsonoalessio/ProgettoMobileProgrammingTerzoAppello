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

  Future<void> _initStatus() async {
    await db.fetchDevices();
    // await db.fetchAutomations();
    // await db.fetchNotifications();
    // await db.fetchIndex();

    // si sfrutta il passaggio per riferimento, quindi non viene allocata una nuova lista
    // piuttosto, viene passato l'indirizzo di memoria della lista presente in DbHelper
    state = db.devices;
    //automations = db.automations;
    //notifications = db.notifications;
    //lastIndexForId = db.lastIndexForId;
  }

  @override
  List<Device> build() {
    _initStatus();
    return devices;
  }

  void addDevice(Device device) {
    _addDeviceToDb(device);
    _initStatus();
  }

  void deleteDevice(Device device) {
    _removeDeviceFromDb(device);
    _initStatus();
  }

  void updateDevice(Device device) {
    _updateDeviceInDb(device);
    _initStatus();
  }

  Future<void> _addDeviceToDb(Device device) async {
    await db.insertDevice(device);
  }

  Future<void> _removeDeviceFromDb(Device device) async {
    await db.removeDevice(device);
  }

  Future<void> _updateDeviceInDb(Device device) async {
    await db.updateDevice(device);
  }

  void addRoom(String room) {
    if (room.isNotEmpty && !_roomExists(room)) {
      db.insertRoom(room); // Salva la stanza nel database
      _initStatus(); // Aggiorna lo stato
    }
  }

  void deleteRoom(String room) {
    if (_roomExists(room)) {
      db.removeRoom(room); // Rimuove la stanza dal database
      _initStatus(); // Aggiorna lo stato
    }
  }

  bool _roomExists(String room) {
    return state.any((device) => device.room == room);
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

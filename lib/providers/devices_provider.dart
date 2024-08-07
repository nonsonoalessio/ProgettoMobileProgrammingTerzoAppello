import 'package:progetto_mobile_programming/models/alarm.dart';
import 'package:progetto_mobile_programming/models/light.dart';
import 'package:progetto_mobile_programming/models/lock.dart';
import 'package:progetto_mobile_programming/models/thermostat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progetto_mobile_programming/models/device.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

part 'devices_provider.g.dart';

@riverpod
class DeviceNotifier extends _$DeviceNotifier {
  DatabaseHelper db = DatabaseHelper.instance;
  final List<Device> _devices = [];

  Future<void> _fetchDevices() async {
    final List<Map<String, dynamic>> mapsOfAlarms =
        await db.database.then((db) => db.query('alarms'));

    final List<Map<String, dynamic>> mapsOfLocks =
        await db.database.then((db) => db.query('locks'));

    final List<Map<String, dynamic>> mapsOfLights =
        await db.database.then((db) => db.query('lights'));

    final List<Map<String, dynamic>> mapsOfthermostats =
        await db.database.then((db) => db.query('thermostats'));

    final alarms = List.generate(mapsOfAlarms.length, (i) {
      final deviceName = mapsOfAlarms[i]['deviceName'];
      final room = mapsOfAlarms[i]['room'];
      final isActive = mapsOfAlarms[i]['isActive'];
      return Alarm(
        deviceName: deviceName as String,
        room: room as String,
        isActive: isActive == 1 ? true : false,
      );
    });

    final locks = List.generate(mapsOfLocks.length, (i) {
      final deviceName = mapsOfLocks[i]['deviceName'];
      final room = mapsOfLocks[i]['room'];
      final isActive = mapsOfLocks[i]['isActive'];
      return Lock(
        deviceName: deviceName as String,
        room: room as String,
        isActive: isActive == 1 ? true : false,
      );
    });

    final lights = List.generate(mapsOfLights.length, (i) {
      final deviceName = mapsOfLights[i]['deviceName'];
      final room = mapsOfLights[i]['room'];
      final isActive = mapsOfLights[i]['isActive'];
      final lightTemperature = mapsOfLights[i]['lightTemperature'];
      return Light(
        deviceName: deviceName as String,
        room: room as String,
        isActive: isActive == 1 ? true : false,
        lightTemperature: lightTemperature as int,
      );
    });

    final thermostats = List.generate(mapsOfthermostats.length, (i) {
      final deviceName = mapsOfthermostats[i]['deviceName'];
      final room = mapsOfthermostats[i]['room'];
      final desiredTemp = mapsOfthermostats[i]['desiderTemp'];
      final detectedTemp = mapsOfthermostats[i]['detectedTemp'];
      return Thermostat(
        deviceName: deviceName as String,
        room: room as String,
        desiredTemp: desiredTemp as double,
        detectedTemp: detectedTemp as double,
      );
    });

    state = [...alarms, ...locks, ...lights, ...thermostats];
  }

  Future<void> addNewDevice(Device d) async {
    await db.insertDevice(d);
    await _fetchDevices(); // Attendi il completamento del fetch
  }

  List<Device> getDevices() {
    _fetchDevices();
    return _devices;
  }

  @override
  List<Device> build() {
    _fetchDevices();
    return _devices;
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

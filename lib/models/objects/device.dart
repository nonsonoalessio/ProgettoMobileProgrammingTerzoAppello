abstract class Device {
  String deviceName;
  String room;
  int id;

  Device({required this.deviceName, this.room = 'NoRoomAssigned!', required this.id});

  Map<String, Object?> toMap();
}

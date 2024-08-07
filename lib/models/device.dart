abstract class Device {
  String deviceName;
  String room;

  Device({required this.deviceName, this.room = 'NoRoomAssigned!'});

  Map<String, Object?> toMap();
}

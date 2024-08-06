abstract class Device {
  String sensorName;
  String room;

  Device({required this.sensorName, this.room = 'NoRoomAssigned!'});

  Map<String, Object?> toMap();
}

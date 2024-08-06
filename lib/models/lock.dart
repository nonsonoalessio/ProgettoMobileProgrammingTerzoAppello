import 'package:progetto_mobile_programming/models/device.dart';

class Lock extends Device {
  bool isActive;
  Lock({required super.sensorName, required super.room, this.isActive = false});

  factory Lock.fromMap(Map<String, dynamic> map) {
    return Lock(
      sensorName: map['sensorName'] as String,
      room: map['room'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {'sensorName': sensorName, 'room': room, 'isActive': isActive};
  }
}

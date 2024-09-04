import 'package:progetto_mobile_programming/models/objects/device.dart';

class Alarm extends Device {
  bool isActive;
  Alarm(
      {required super.deviceName,
      required super.room,
      required super.id,
      this.isActive = false});

  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'] as int,
      deviceName: map['deviceName'] as String,
      room: map['room'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {'id': id, 'isActive': isActive};
  }
}

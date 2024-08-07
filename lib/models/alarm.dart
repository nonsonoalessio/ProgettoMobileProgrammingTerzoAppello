import 'package:progetto_mobile_programming/models/device.dart';

class Alarm extends Device {
  bool isActive;
  Alarm(
      {required super.deviceName, required super.room, this.isActive = false});

  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      deviceName: map['deviceName'] as String,
      room: map['room'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {'deviceName': deviceName, 'room': room, 'isActive': isActive};
  }
}

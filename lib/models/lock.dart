import 'package:progetto_mobile_programming/models/device.dart';

class Lock extends Device {
  bool isActive;
  Lock({required super.deviceName, required super.room, this.isActive = false});

  factory Lock.fromMap(Map<String, dynamic> map) {
    return Lock(
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

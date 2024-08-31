import 'package:progetto_mobile_programming/models/objects/device.dart';

class Lock extends Device {
  bool isActive;
  Lock(
      {required super.deviceName,
      required super.room,
      required super.id,
      this.isActive = false});

  factory Lock.fromMap(Map<String, dynamic> map) {
    return Lock(
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

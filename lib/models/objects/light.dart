import 'package:progetto_mobile_programming/models/objects/device.dart';

class Light extends Device {
  bool isActive;
  int lightTemperature;

  Light({
    required super.deviceName,
    required super.room,
    this.isActive = false,
    this.lightTemperature = 2700,
  });

  factory Light.fromMap(Map<String, dynamic> map) {
    return Light(
      deviceName: map['deviceName'] as String,
      room: map['room'] as String,
      isActive: map['isActive'] as bool,
      lightTemperature: map['lightTemperature'] as int,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'deviceName': deviceName,
      'room': room,
      'isActive': isActive,
      'lightTemperature': lightTemperature,
    };
  }
}

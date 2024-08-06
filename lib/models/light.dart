import 'package:progetto_mobile_programming/models/device.dart';

class Light extends Device {
  bool isActive;
  int lightTemperature;

  Light({
    required super.sensorName,
    required super.room,
    this.isActive = false,
    this.lightTemperature = 2700,
  });

  factory Light.fromMap(Map<String, dynamic> map) {
    return Light(
      sensorName: map['sensorName'] as String,
      room: map['room'] as String,
      isActive: map['isActive'] as bool,
      lightTemperature: map['lightTemperature'] as int,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'sensorName': sensorName,
      'room': room,
      'isActive': isActive,
      'lightTemperature': lightTemperature,
    };
  }
}

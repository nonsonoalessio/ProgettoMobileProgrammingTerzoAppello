import 'package:progetto_mobile_programming/models/objects/device.dart';

class Thermostat extends Device {
  double desiredTemp;
  double detectedTemp;

  Thermostat(
      {required super.deviceName,
      required super.room,
      required this.desiredTemp,
      required this.detectedTemp});

  factory Thermostat.fromMap(Map<String, dynamic> map) {
    return Thermostat(
      deviceName: map['deviceName'] as String,
      room: map['room'] as String,
      desiredTemp: map['desiredTemp'] as double,
      detectedTemp: map['detectedTemp'] as double,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'deviceName': deviceName,
      'room': room,
      'desiredTemp': desiredTemp,
      'detectedTemp': detectedTemp,
    };
  }
}

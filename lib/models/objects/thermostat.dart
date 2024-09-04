import 'package:progetto_mobile_programming/models/objects/device.dart';

class Thermostat extends Device {
  double desiredTemp;
  double detectedTemp;

  Thermostat(
      {required super.deviceName,
      required super.room,
      required super.id,
      required this.desiredTemp,
      required this.detectedTemp});

  factory Thermostat.fromMap(Map<String, dynamic> map) {
    return Thermostat(
      id: map['id'] as int,
      deviceName: map['deviceName'] as String,
      room: map['room'] as String,
      desiredTemp: map['desiredTemp'] as double,
      detectedTemp: map['detectedTemp'] as double,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'desiredTemp': desiredTemp,
      'currentTemp': detectedTemp,
    };
  }
}

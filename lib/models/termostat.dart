import 'package:progetto_mobile_programming/models/device.dart';

class Termostat extends Device {
  double desiredTemp;
  double detectedTemp;

  Termostat(
      {required super.sensorName,
      required super.room,
      required this.desiredTemp,
      required this.detectedTemp});

  factory Termostat.fromMap(Map<String, dynamic> map) {
    return Termostat(
      sensorName: map['sensorName'] as String,
      room: map['room'] as String,
      desiredTemp: map['desiredTemp'] as double,
      detectedTemp: map['detectedTemp'] as double,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'sensorName': sensorName,
      'room': room,
      'desiredTemp': desiredTemp,
      'detectedTemp': detectedTemp,
    };
  }
}

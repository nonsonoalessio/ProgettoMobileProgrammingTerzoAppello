import 'package:progetto_mobile_programming/models/objects/device.dart';

class Camera extends Device {
  String video;

  Camera(
      {required super.deviceName,
      required super.room,
      required super.id,
      required this.video});

  factory Camera.fromMap(Map<String, dynamic> map) {
    return Camera(
      id: map['id'] as int,
      deviceName: map['deviceName'] as String,
      room: map['room'] as String,
      video: map['video'] as String,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {'id': id, 'video': video};
  }
}

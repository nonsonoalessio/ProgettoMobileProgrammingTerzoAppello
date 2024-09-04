import 'package:progetto_mobile_programming/models/objects/device.dart';

abstract class DeviceAction {
  final Device device;

  const DeviceAction({
    required this.device,
  });

  void executeAction();
  Map<String, dynamic> toMap();
}
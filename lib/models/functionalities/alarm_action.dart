import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';

enum AlarmsActions { turnOn, turnOff }

class AlarmAction extends DeviceAction {
  final AlarmsActions action;

  const AlarmAction({
    required super.device,
    required this.action,
  });

  @override
  void executeAction() {
    if (device is Alarm) {
      Alarm alarm = device as Alarm;
      switch (action) {
        case AlarmsActions.turnOn:
          alarm.isActive = true;
          print('L\'allarme è stato attivato correttamente.');
          break;
        case AlarmsActions.turnOff:
          alarm.isActive = false;
          print('L\'allarme è stato disattivato correttamente.');
          break;
      }
    } else {
      print(
          'Dispositivo non valido, l\'azione può essere eseguita solo su allarmi.');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'device': device.id,
      'type': 'alarm',
      'azione': action.toString(),
    };
  }
}

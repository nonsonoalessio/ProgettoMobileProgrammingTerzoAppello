import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';

enum LightsActions { turnOn, turnOff, setColorTemp }

class LightAction extends DeviceAction {
  final LightsActions action;
  int? colorTemperature;

  LightAction({
    required super.device,
    required this.action,
    this.colorTemperature,
  });

  @override
  void executeAction() {
    if (device is Light) {
      Light light = device as Light;
      switch (action) {
        case LightsActions.turnOn:
          light.isActive = true;
          print('Luce accesa correttamente');
          break;
        case LightsActions.turnOff:
          light.isActive = false;
          print('Luce spenta correttamente');
          break;
        case LightsActions.setColorTemp:
          if (colorTemperature != null) {
            light.lightTemperature = colorTemperature!;
            print(
                'Temperatura del colore della luce impostata a: $colorTemperature K');
          } else {
            print(
                'Non hai provvisto nessuna temperatura per il colore della luce');
          }
          break;
      }
    } else {
      print('Dispositivo non valido.');
    }
  }

  @override
  Map<String, dynamic> toMap() {

    if (colorTemperature != null)
        {
          return{
          'device': device.id,
          'type': 'light',
          'azione': action.toString(),
          'temperatura': colorTemperature
          };

        }else{

          return {
          'idDevice': device.id,
          'type': 'light',
          'azione': action.toString(),
          };

        }
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

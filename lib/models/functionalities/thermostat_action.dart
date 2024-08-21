import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';

enum ThermostatsActions { setDesiredTemperature }

class ThermostatAction extends DeviceAction {
  final ThermostatsActions action;
  double? desiredTemp;

  ThermostatAction({
    required super.device,
    required this.action,
    this.desiredTemp,
  });

  @override
  void executeAction() {
    if (device is Thermostat) {
      Thermostat thermostat = device as Thermostat;
      switch (action) {
        case ThermostatsActions.setDesiredTemperature:
          if (desiredTemp != null) {
            thermostat.desiredTemp = desiredTemp!;
            print('Temperatura impostata a: ${thermostat.desiredTemp}°C');
          } else {
            print('Nessuna temperatura provvista.');
          }
          break;
      }
    } else {
      print('Dispositivo non valido. Inserire un termostato.');
    }
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';

enum LocksActions { activate, deactivate }

class LockAction extends DeviceAction {
  final LocksActions action;

  LockAction({
    required super.device,
    required this.action,
  });

  @override
  void executeAction() {
    if (device is Lock) {
      Lock lock = device as Lock;
      switch (action) {
        case LocksActions.activate:
          lock.isActive = true;
          print('La serratura è stata attivata correttamente.');
          break;
        case LocksActions.deactivate:
          lock.isActive = false;
          print('La serratura è stata disattivata correttamente.');
          break;
      }
    } else {
      print(
          'Dispositivo non valido. Questa azione può essere applicata solo ad una serratura.');
    }
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

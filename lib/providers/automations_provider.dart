import 'package:progetto_mobile_programming/models/functionalities/automation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

part 'automations_provider.g.dart';

@riverpod
class AutomationsNotifier extends _$AutomationsNotifier {
  DatabaseHelper db = DatabaseHelper.instance;
  // campo non final: per ogni operazione, viene riassegnata una nuova lista
  // List<Device> devices = [];
  List<Automation> automations = [];
  // List<Notification> notifications = [];
  // int lastIndexForId;

  Future<void> _initStatus() async {
    // await db.fetchDevices();
    await db.fetchAutomations();

    // await db.fetchNotifications();
    // await db.fetchIndex();

    // si sfrutta il passaggio per riferimento, quindi non viene allocata una nuova lista
    // piuttosto, viene passato l'indirizzo di memoria della lista presente in DbHelper
    state = db.automations;
    //automations = db.automations;
    //notifications = db.notifications;
    //lastIndexForId = db.lastIndexForId;
  }

  @override
  List<Automation> build() {
    _initStatus();
    return automations;
  }

  Future<int> ciao() async {
    await _initStatus();
    return 1;
  }

  void addAutomation(Automation automation) {
    _addAutomationToDb(automation);
    _initStatus();
  }

  void deleteAutomation(Automation automation) {
    _removeAutomationFromDb(automation);
    _initStatus();
  }

  void updateAutomation(Automation automation) {
    _updateAutomationInDb(automation);
    _initStatus();
  }

  Future<void> _addAutomationToDb(Automation automation) async {
    await db.insertAutomation(automation);
  }

  Future<void> _removeAutomationFromDb(Automation automation) async {
    await db.removeAutomation(automation.name);
  }

  Future<void> _updateAutomationInDb(Automation automation) async {
    await db.updateAutomation(automation);
  }
}

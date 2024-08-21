// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/functionalities/automation.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';

class AddNewAutomationPage extends ConsumerStatefulWidget {
  const AddNewAutomationPage({super.key});

  @override
  ConsumerState<AddNewAutomationPage> createState() =>
      _AddNewAutomationPageState();
}

class _AddNewAutomationPageState extends ConsumerState<AddNewAutomationPage> {
  final TextEditingController _automationNameController =
      TextEditingController();
  WeatherCondition _selectedWeather = WeatherCondition.sunny;
  int _executionTime = 0;
  Map<Device, List<String>> _selectedActions = {};

  void _handleWeatherConditionChanged(WeatherCondition newCondition) {
    setState(() {
      _selectedWeather = newCondition;
    });
  }

  void _handleExecutionTimeChanged(int time) {
    setState(() {
      _executionTime = time;
    });
  }

  void _handleActionChanged(Device device, List<String> actions) {
    setState(() {
      _selectedActions[device] = actions;
    });
  }

  bool _checkFields() {
    return _automationNameController.text.isNotEmpty &&
        _selectedActions.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final List<Device> devices = ref.watch(deviceNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          // TODO: aggiunta salvataggio automazione
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                "Nuova Automazione",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _automationNameController,
                  decoration: InputDecoration(
                    hintText: 'Inserisci nome dell\'automazione',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Condizione meteorologica',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              WeatherConditionSelector(
                onValueChanged: _handleWeatherConditionChanged,
                currentCondition: _selectedWeather,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Ora di esecuzione',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Azioni',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              for (var device in devices)
                ActionSelector(
                  device: device,
                  onActionChanged: (actions) =>
                      _handleActionChanged(device, actions),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherConditionSelector extends StatelessWidget {
  // Dropdown menu per selezionare una condizione meteorologica
  final ValueChanged<WeatherCondition>
      onValueChanged; // Contiene la nuova condizione dal menu a tendina
  final WeatherCondition
      currentCondition; // Rappresenta la condizione meteo attualmente selezionata

  const WeatherConditionSelector({
    Key? key,
    required this.onValueChanged,
    required this.currentCondition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<WeatherCondition>(
      // Widget che crea il menu a tendina
      value:
          currentCondition, // Mostra la condizione meteorologica attualmente selezionata
      onChanged: (WeatherCondition? newCondition) {
        // Funzione callback che viene eseguita quando l'utente seleziona una nuova opzione
        if (newCondition != null) {
          // Siccome onchanged può accettare valori null facciamo questo controllo
          onValueChanged(newCondition);
        }
      },
      items: WeatherCondition.values.map((WeatherCondition condition) {
        // Qui troviamo mappati i valori: enum WeatherCondition { sunny, cloudy, rainy, hot, cold, snowy }
        return DropdownMenuItem<WeatherCondition>(
          value: condition,
          child: Text(condition.toString().split('.').last),
        );
      }).toList(),
    );
  }
}

// VERIFICARE
class ActionSelector extends StatefulWidget {
  // Mostra i device disponibili e permette di selezionare le azioni per ogni device
  final Device device; // COSTRUTTORE: SOLO DEVICE?????
  final ValueChanged<List<String>> onActionChanged;

  const ActionSelector({
    Key? key,
    required this.device,
    required this.onActionChanged,
  }) : super(key: key);

  @override
  State<ActionSelector> createState() => _ActionSelectorState();
}

class _ActionSelectorState extends State<ActionSelector> {
  List<String> selectedActions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.device.deviceName),
        Wrap(
          children: ['Turn On', 'Turn Off'].map((action) {
            return ChoiceChip(
              label: Text(action),
              selected: selectedActions.contains(action),
              onSelected: (selected) {
                setState(() {
                  selected
                      ? selectedActions.add(action)
                      : selectedActions.remove(action);
                });
                widget.onActionChanged(selectedActions);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

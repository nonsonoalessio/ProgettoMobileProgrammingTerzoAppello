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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  WeatherConditionSelector(
                    onValueChanged: _handleWeatherConditionChanged,
                  ),
                  TimeOfDaySelector(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeOfDaySelector extends StatefulWidget {
  const TimeOfDaySelector({super.key});

  @override
  State<TimeOfDaySelector> createState() => _TimeOfDaySelectorState();
}

class _TimeOfDaySelectorState extends State<TimeOfDaySelector> {
  TimeOfDay selectedTime = TimeOfDay(hour: 09, minute: 41);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _selectTime(context);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.access_time),
          ),
          Text(
            selectedTime.format(context),
          ),
        ],
      ),
    );
  }
}
/*
class WeatherConditionSelector extends StatefulWidget {
  // Dropdown menu per selezionare una condizione meteorologica
  final ValueChanged<WeatherCondition>
      onValueChanged; // Contiene la nuova condizione dal menu a tendina
  // Rappresenta la condizione meteo attualmente selezionata

  const WeatherConditionSelector({
    super.key,
    required this.onValueChanged,
  });

  @override
  State<WeatherConditionSelector> createState() =>
      _WeatherConditionSelectorState();
}

class _WeatherConditionSelectorState extends State<WeatherConditionSelector> {
  WeatherCondition currentCondition = WeatherCondition.sunny;

  String enumToText(WeatherCondition condition) {
    if (condition == WeatherCondition.cloudy) {
      return "☁️ Nuvoloso";
    } else if (condition == WeatherCondition.cold) {
      return "❄️ Freddo";
    } else if (condition == WeatherCondition.hot) {
      return "🔥 Caldo";
    } else if (condition == WeatherCondition.rainy) {
      return "🌧️ Piggia";
    } else if (condition == WeatherCondition.snowy) {
      return "🌨️ Neve";
    } else {
      return "☀️ Sole";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {showModalBottomSheet(context: context, builder: WeatherConditionsModal(onValueChanged: onValueChanged))},
      child: Text(
        enumToText(currentCondition),
      ),
    );
  }
}

class WeatherConditionsModal extends StatefulWidget {
  final ValueChanged<WeatherCondition> onValueChanged;
  const WeatherConditionsModal({super.key, required this.onValueChanged});

  @override
  State<WeatherConditionsModal> createState() => _WeatherConditionsModalState();
}

class _WeatherConditionsModalState extends State<WeatherConditionsModal> {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
*/
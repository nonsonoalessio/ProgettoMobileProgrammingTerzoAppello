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
  TimeOfDay _executionTime = TimeOfDay(hour: 09, minute: 41);
  Map<Device, List<String>> _selectedActions = {};

  void _handleWeatherConditionChanged(WeatherCondition newCondition) {
    setState(() {
      _selectedWeather = newCondition;
    });
  }

  void _handleExecutionTimeChanged(TimeOfDay time) {
    setState(() {
      _executionTime = time;
    });
  }

  bool _checkFields() {
    return _automationNameController.text.isNotEmpty &&
        _selectedActions.isNotEmpty;
  }

  String enumToText(WeatherCondition condition) {
    if (condition == WeatherCondition.cloudy) {
      return "☁️ Nuvoloso";
    } else if (condition == WeatherCondition.cold) {
      return "❄️ Freddo";
    } else if (condition == WeatherCondition.hot) {
      return "🔥 Caldo";
    } else if (condition == WeatherCondition.rainy) {
      return "🌧️ Pioggia";
    } else if (condition == WeatherCondition.snowy) {
      return "🌨️ Neve";
    } else if (condition == WeatherCondition.none) {
      return "🚫 Nessuna condizione";
    } else {
      return "☀️ Sole";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Device> devices = ref.watch(deviceNotifierProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Aggiungi azione'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => WeatherConditionsModal(
                                onValueChanged: _handleWeatherConditionChanged,
                              ));
                    },
                    child: Text(
                      enumToText(_selectedWeather),
                    ),
                  ),
                  TimeOfDaySelector(
                    onValueChanged: _handleExecutionTimeChanged,
                  ),
                ],
              ),
              ListOfActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeOfDaySelector extends StatefulWidget {
  final ValueChanged<TimeOfDay> onValueChanged;

  const TimeOfDaySelector({
    super.key,
    required this.onValueChanged,
  });

  @override
  State<TimeOfDaySelector> createState() => _TimeOfDaySelectorState();
}

class _TimeOfDaySelectorState extends State<TimeOfDaySelector> {
  TimeOfDay selectedTime = TimeOfDay(hour: 09, minute: 41);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 09, minute: 41),
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
        widget.onValueChanged(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _selectTime(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
  String enumToText(WeatherCondition condition) {
    if (condition == WeatherCondition.cloudy) {
      return "☁️ Nuvoloso";
    } else if (condition == WeatherCondition.cold) {
      return "❄️ Freddo";
    } else if (condition == WeatherCondition.hot) {
      return "🔥 Caldo";
    } else if (condition == WeatherCondition.rainy) {
      return "🌧️ Pioggia";
    } else if (condition == WeatherCondition.snowy) {
      return "🌨️ Neve";
    } else if (condition == WeatherCondition.none) {
      return "🚫 Nessuna condizione";
    } else {
      return "☀️ Sole";
    }
  }

  WeatherCondition? _selectedCondition = WeatherCondition.sunny;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: WeatherCondition.values.map((WeatherCondition condition) {
        return RadioListTile<WeatherCondition>(
          title: Text(enumToText(condition)),
          value: condition,
          groupValue: _selectedCondition,
          onChanged: (WeatherCondition? value) {
            setState(() {
              _selectedCondition = value;
              widget.onValueChanged(value as WeatherCondition);
            });
          },
        );
      }).toList(),
    );
  }
}

class ListOfActions extends StatefulWidget {
  const ListOfActions({super.key});

  @override
  State<ListOfActions> createState() => _ListOfActionsState();
}

class _ListOfActionsState extends State<ListOfActions> {
  @override
  Widget build(BuildContext context) {
    return Text("Azione 1");
  }
}

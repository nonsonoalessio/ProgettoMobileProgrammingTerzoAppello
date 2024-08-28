// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/functionalities/alarm_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/automation.dart';
import 'package:progetto_mobile_programming/models/functionalities/light_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/lock_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/thermostat_action.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
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
  final Map<Device, List<DeviceAction>> _selectedActions = {};

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

  void addAction() {
    Device? selectedDevice;
    DeviceAction? newAction;
    AlarmsActions? selectedAlarmAction;
    LightsActions? selectedLightAction;
    LocksActions? selectedLockAction;
    ThermostatsActions? selectedThermostatAction;
    int? colorTemperature;
    double? desiredTemp;
    List<DeviceAction> actions = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the BottomSheet can scroll
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nuova Azione',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      final devices = ref.watch(deviceNotifierProvider);

                      return devices.isEmpty
                          ? const Text('Nessun dispositivo disponibile')
                          : DropdownButtonFormField<Device>(
                              decoration: InputDecoration(
                                labelText: 'Seleziona Dispositivo',
                                border: OutlineInputBorder(),
                              ),
                              items: devices.map((device) {
                                return DropdownMenuItem<Device>(
                                  value: device,
                                  child: Text(device.deviceName),
                                );
                              }).toList(),
                              onChanged: (device) {
                                setState(() {
                                  selectedDevice = device;
                                  newAction = null; // Reset dell'azione
                                });
                              },
                            );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (selectedDevice != null) ...[
                    if (selectedDevice is Alarm) ...[
                      DropdownButtonFormField<AlarmsActions>(
                        decoration: InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: AlarmsActions.values.map((action) {
                          return DropdownMenuItem<AlarmsActions>(
                            value: action,
                            child: Text(action.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAlarmAction = value;
                            newAction = AlarmAction(
                                device: selectedDevice!, action: value!);
                          });
                        },
                      ),
                    ],
                    if (selectedDevice is Light) ...[
                      DropdownButtonFormField<LightsActions>(
                        decoration: InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: LightsActions.values.map((action) {
                          return DropdownMenuItem<LightsActions>(
                            value: action,
                            child: Text(action.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLightAction = value;
                            newAction = LightAction(
                                device: selectedDevice!, action: value!);
                          });
                        },
                      ),
                      if (selectedLightAction == LightsActions.setColorTemp)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Temperatura Colore (K)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                colorTemperature = int.tryParse(value);
                                if (newAction != null) {
                                  newAction = LightAction(
                                    device: selectedDevice!,
                                    action: (newAction as LightAction).action,
                                    colorTemperature: colorTemperature,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                    ],
                    if (selectedDevice is Lock) ...[
                      DropdownButtonFormField<LocksActions>(
                        decoration: InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: LocksActions.values.map((action) {
                          return DropdownMenuItem<LocksActions>(
                            value: action,
                            child: Text(action.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLockAction = value;
                            newAction = LockAction(
                                device: selectedDevice!, action: value!);
                          });
                        },
                      ),
                    ],
                    if (selectedDevice is Thermostat) ...[
                      DropdownButtonFormField<ThermostatsActions>(
                        decoration: InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: ThermostatsActions.values.map((action) {
                          return DropdownMenuItem<ThermostatsActions>(
                            value: action,
                            child: Text(action.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedThermostatAction = value;
                            newAction = ThermostatAction(
                                device: selectedDevice!, action: value!);
                          });
                        },
                      ),
                      if (selectedThermostatAction ==
                          ThermostatsActions.setDesiredTemperature)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Temperatura Desiderata (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                desiredTemp = double.tryParse(value);
                                if (newAction != null) {
                                  newAction = ThermostatAction(
                                    device: selectedDevice!,
                                    action:
                                        (newAction as ThermostatAction).action,
                                    desiredTemp: desiredTemp,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (newAction != null) {
                        Navigator.pop(context,
                            newAction); // Pass the new action back to the previous screen
                      }
                    },
                    child: Text('Aggiungi Azione'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          _selectedActions[selectedDevice as Device]?.add(result as DeviceAction);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Device> devices = ref.watch(deviceNotifierProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addAction();
        },
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

class DeviceSelectionModal extends StatefulWidget {
  const DeviceSelectionModal({super.key});

  @override
  State<DeviceSelectionModal> createState() => _DeviceSelectionModalState();
}

class _DeviceSelectionModalState extends State<DeviceSelectionModal> {
  Device? _selectedDevice;

  void _handleSelectedDevice(Device d) {
    setState(() {
      _selectedDevice = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DevicesListInModal(
                      onDeviceSelected: _handleSelectedDevice,
                    ),
                  );
                },
                child: Text(_selectedDevice == null
                    ? "Scegli dispositivo"
                    : (_selectedDevice as Device).deviceName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevicesListInModal extends ConsumerStatefulWidget {
  final ValueChanged<Device> onDeviceSelected;

  const DevicesListInModal({
    super.key,
    required this.onDeviceSelected,
  });

  @override
  ConsumerState<DevicesListInModal> createState() => _DevicesListInModalState();
}

class _DevicesListInModalState extends ConsumerState<DevicesListInModal> {
  Device? selectedOption;

  @override
  Widget build(BuildContext context) {
    List<Device> options = ref.watch(deviceNotifierProvider);
    return Dialog(
      child: ListView(
        children: options.map((option) {
          return RadioListTile<Device>(
            title: Text(option.deviceName),
            value: option,
            groupValue: selectedOption,
            onChanged: (Device? value) {
              setState(() {
                selectedOption = value;
                widget.onDeviceSelected(value as Device);
                Navigator.pop(context);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

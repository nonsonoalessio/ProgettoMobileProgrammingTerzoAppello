import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/functionalities/alarm_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/automation.dart';
import 'package:progetto_mobile_programming/models/functionalities/light_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/lock_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/thermostat_action.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';

String lightsActionsToStr(LightsActions action) {
  if (action == LightsActions.setColorTemp) {
    return "Imposta temperatura colore";
  } else if (action == LightsActions.turnOff) {
    return "Spegni";
  } else {
    return "Accendi";
  }
}

String alarmsActionsToStr(AlarmsActions action) {
  return action == AlarmsActions.turnOn
      ? "Inserisci allarme"
      : "Disinserisci allarme";
}

String locksActionsToStr(LocksActions action) {
  return action == LocksActions.activate ? "Attiva" : "Disattiva";
}

String thermostatsActionsToStr(ThermostatsActions action) {
  return "Imposta temperatura desiderata";
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

class AutomationDetailPage extends ConsumerStatefulWidget {
  final Automation automation;

  const AutomationDetailPage({Key? key, required this.automation})
      : super(key: key);

  @override
  _AutomationDetailPageState createState() => _AutomationDetailPageState();
}

class _AutomationDetailPageState extends ConsumerState<AutomationDetailPage> {
  late String _name;
  late TimeOfDay _executionTime;
  WeatherCondition? _weatherCondition;
  late List<DeviceAction> _actions;
  final Map<Device, List<DeviceAction>> _selectedActions = {};

  @override
  void initState() {
    super.initState();
    _name = widget.automation.name;
    // _executionTime = widget.automation.executionTime;
    _weatherCondition = widget.automation.weather;
    _actions = List.from(widget.automation.actions);
  }

  Future<void> _updateAutomation() async {
    // Implementa il metodo per aggiornare l'automazione nel database
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _executionTime,
    );
    if (picked != null && picked != _executionTime) {
      setState(() {
        _executionTime = picked;
      });
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
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Usa setModalState per aggiornare lo stato all'interno del modal
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
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
                              decoration: const InputDecoration(
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
                                setModalState(() {
                                  // Aggiorna lo stato del modal
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
                        decoration: const InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: AlarmsActions.values.map((action) {
                          return DropdownMenuItem<AlarmsActions>(
                            value: action,
                            child: Text(alarmsActionsToStr(action)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedAlarmAction = value;
                            newAction = AlarmAction(
                                device: selectedDevice!, action: value!);
                          });
                        },
                      ),
                    ],
                    if (selectedDevice is Light) ...[
                      DropdownButtonFormField<LightsActions>(
                        decoration: const InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: LightsActions.values.map((action) {
                          return DropdownMenuItem<LightsActions>(
                            value: action,
                            child: Text(lightsActionsToStr(action)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
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
                            decoration: const InputDecoration(
                              labelText: 'Temperatura Colore (K)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setModalState(() {
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
                        decoration: const InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: LocksActions.values.map((action) {
                          return DropdownMenuItem<LocksActions>(
                            value: action,
                            child: Text(locksActionsToStr(action)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedLockAction = value;
                            newAction = LockAction(
                                device: selectedDevice!, action: value!);
                          });
                        },
                      ),
                    ],
                    if (selectedDevice is Thermostat) ...[
                      DropdownButtonFormField<ThermostatsActions>(
                        decoration: const InputDecoration(
                          labelText: 'Seleziona Azione',
                          border: OutlineInputBorder(),
                        ),
                        items: ThermostatsActions.values.map((action) {
                          return DropdownMenuItem<ThermostatsActions>(
                            value: action,
                            child: Text(thermostatsActionsToStr(action)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
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
                            decoration: const InputDecoration(
                              labelText: 'Temperatura Desiderata (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setModalState(() {
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
                    child: const Text('Aggiungi Azione'),
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
          if (_selectedActions.containsKey(selectedDevice as Device)) {
            _selectedActions[selectedDevice as Device]
                ?.add(result as DeviceAction);
          } else {
            _selectedActions[selectedDevice as Device] = [
              result as DeviceAction
            ];
          }
        });
      }
    });
  }

  void _removeAction(int index) {
    setState(() {
      _actions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Automazione'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _updateAutomation();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nome automazione',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _name = value,
              controller: TextEditingController(text: _name),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Orario di esecuzione'),
              subtitle: Text(MaterialLocalizations.of(context)
                  .formatTimeOfDay(_executionTime)),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<WeatherCondition>(
              decoration: const InputDecoration(
                labelText: 'Condizioni meteo',
                border: OutlineInputBorder(),
              ),
              value: _weatherCondition,
              items: WeatherCondition.values.map((WeatherCondition condition) {
                return DropdownMenuItem<WeatherCondition>(
                  value: condition,
                  child: Text(condition.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _weatherCondition = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Azioni:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _actions.length,
              itemBuilder: (context, index) {
                final action = _actions[index];
                return ListTile(
                  title: Text(action.runtimeType.toString().split('.').last),
                  subtitle: Text('Dispositivo: ${action.device.deviceName}'),
                  leading: const Icon(Icons.device_unknown),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeAction(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
import 'package:progetto_mobile_programming/providers/automations_provider.dart';

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

class AutomationDetailPage extends ConsumerStatefulWidget {
  final Automation automation;
  final TimeOfDay executionTime;
  final List<Action> actions;

  AutomationDetailPage({
    super.key,
    required this.automation,
    TimeOfDay? initialExecutionTime,
    List<Action>? initialActions,
  })  : executionTime =
            initialExecutionTime ?? const TimeOfDay(hour: 09, minute: 41),
        actions = initialActions ?? <Action>[];

  @override
  ConsumerState<AutomationDetailPage> createState() =>
      AutomationDetailPageState();
}

class AutomationDetailPageState extends ConsumerState<AutomationDetailPage> {
  final TextEditingController automationNameController =
      TextEditingController();

  late WeatherCondition selectedWeather;
  late TimeOfDay? executionTime;
  Set<DeviceAction> actions = {};
  late bool isTimeDependent;

  void _handleWeatherConditionChanged(WeatherCondition newCondition) {
    setState(() {
      selectedWeather = newCondition;
    });
  }

  void _handleExecutionTimeChanged(TimeOfDay time) {
    setState(() {
      executionTime = time;
    });
  }

  String enumToText(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.cloudy:
        return "☁️ Nuvoloso";
      case WeatherCondition.cold:
        return "❄️ Freddo";
      case WeatherCondition.hot:
        return "🔥 Caldo";
      case WeatherCondition.rainy:
        return "🌧️ Pioggia";
      case WeatherCondition.snowy:
        return "🌨️ Neve";
      case WeatherCondition.none:
        return "🚫 Nessuna condizione";
      default:
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

    actions.addAll(widget.automation.actions);

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
          actions.add(result);
        });
      }
    });
  }

  void _handleTimeDependency(bool value) {
    setState(() {
      isTimeDependent = value;
    });
  }

  @override
  void initState() {
    super.initState();
    automationNameController.text = widget.automation.name;
    selectedWeather = widget.automation.weather ?? WeatherCondition.none;
    executionTime = widget.automation.executionTime ??
        const TimeOfDay(hour: 09, minute: 41);
    isTimeDependent = widget.automation.executionTime == null ? true : false;
    actions.addAll(widget.automation.actions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addAction,
        label: const Text('Aggiungi azione'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Modifica automazione'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'modifica') {
                if (automationNameController.text.trim().isEmpty) {
                  // Mostra un messaggio di errore se il nome è vuoto
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Il nome dell\'automazione non può essere vuoto.'),
                    ),
                  );
                  return; // Interrompe l'operazione di modifica
                }
                Automation updatedAutomation = Automation(
                  name: automationNameController.text,
                  executionTime: isTimeDependent
                      ? executionTime
                      : const TimeOfDay(hour: 00, minute: 00),
                  actions: actions,
                );
                ref
                    .read(automationsNotifierProvider.notifier)
                    .updateAutomation(updatedAutomation);
                Navigator.pop(context);
              } else if (result == 'cancella') {
                ref
                    .read(automationsNotifierProvider.notifier)
                    .deleteAutomation(widget.automation);
                // la logica per cancellare l'automazione
                Navigator.of(context).pop('r');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'modifica',
                child: Text('Modifica automazione'),
              ),
              const PopupMenuItem<String>(
                value: 'cancella',
                child: Text('Cancella automazione'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: automationNameController,
                  decoration: InputDecoration(
                    hintText: widget.automation.name,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("L'automazione non dipende da un orario."),
                  Switch(
                    value: isTimeDependent,
                    onChanged: _handleTimeDependency,
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0, // Spazio orizzontale tra i widget
                runSpacing: 4.0, // Spazio verticale tra le righe
                runAlignment: WrapAlignment.center,

                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => WeatherConditionsModal(
                          onValueChanged: _handleWeatherConditionChanged,
                          automation: widget.automation,
                        ),
                      );
                    },
                    child: Text(
                      enumToText(selectedWeather),
                    ),
                  ),
                  IntrinsicWidth(
                    child: TimeOfDaySelector(
                      onValueChanged: _handleExecutionTimeChanged,
                      timeDependencyChange: _handleTimeDependency,
                      isTimeDependent: isTimeDependent,
                      automation: widget.automation,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListOfActions(
                  setOfActions: actions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeOfDaySelector extends StatefulWidget {
  final ValueChanged<TimeOfDay> onValueChanged;
  final ValueChanged<bool> timeDependencyChange;
  final bool isTimeDependent;
  final Automation automation;

  const TimeOfDaySelector({
    super.key,
    required this.onValueChanged,
    required this.timeDependencyChange,
    required this.isTimeDependent,
    required this.automation,
  });

  @override
  State<TimeOfDaySelector> createState() => _TimeOfDaySelectorState();
}

class _TimeOfDaySelectorState extends State<TimeOfDaySelector> {
  late TimeOfDay selectedTime;
  late bool isTimeDependent;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.automation.executionTime ??
        const TimeOfDay(hour: 00, minute: 00);
    isTimeDependent = widget.automation.executionTime == null ? true : false;
  }

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

    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        widget.onValueChanged(selectedTime);
        widget.timeDependencyChange(false);
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.access_time),
            ),
            Text(
              !widget.isTimeDependent
                  ? selectedTime.format(context)
                  : 'Nessun orario selezionato',
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherConditionsModal extends StatefulWidget {
  final ValueChanged<WeatherCondition> onValueChanged;
  final Automation automation;
  const WeatherConditionsModal({
    super.key,
    required this.onValueChanged,
    required this.automation,
  });

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

  late WeatherCondition _selectedCondition;

  @override
  void initState() {
    super.initState();
    _selectedCondition = widget.automation.weather ?? WeatherCondition.none;
  }

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
              _selectedCondition = value as WeatherCondition;
              widget.onValueChanged(value);
            });
          },
        );
      }).toList(),
    );
  }
}

class ListOfActions extends StatefulWidget {
  final Set<DeviceAction> setOfActions;
  const ListOfActions({super.key, required this.setOfActions});

  @override
  State<ListOfActions> createState() => _ListOfActionsState();
}

class _ListOfActionsState extends State<ListOfActions> {
  @override
  Widget build(BuildContext context) {
    var actions =
        widget.setOfActions.toList(); // per non riscrivere "widget." ogni volta

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            "Passi dell'automazione",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Expanded(
            child: actions.isNotEmpty
                ? ListView.builder(
                    itemCount: actions.length,
                    itemBuilder: (context, index) => DeviceActionsDetail(
                      device: actions[index].device,
                      actions: actions,
                    ),
                  )
                : const Center(
                    child: Text('Nessuna azione da compiere. Aggiungine una!'),
                  ),
          )
        ],
      ),
    );
  }
}

class DeviceActionsDetail extends StatefulWidget {
  final Device device;
  final List<DeviceAction> actions;
  const DeviceActionsDetail({
    super.key,
    required this.device,
    required this.actions,
  });

  @override
  State<DeviceActionsDetail> createState() => _DeviceActionsDetailState();
}

class _DeviceActionsDetailState extends State<DeviceActionsDetail> {
  @override
  Widget build(BuildContext context) {
    Icon icon;
    List<DeviceAction> actions = widget.actions
        .where((action) => action.device == widget.device)
        .toList();

    if (widget.device is Light) {
      icon = const Icon(
        Icons.lightbulb,
        size: 24.0,
      );
    } else if (widget.device is Lock) {
      icon = const Icon(
        Icons.lock,
        size: 24.0,
      );
    } else if (widget.device is Alarm) {
      icon = const Icon(
        Icons.doorbell,
        size: 24.0,
      );
    } else {
      icon = const Icon(
        Icons.thermostat,
        size: 24.0,
      );
    }

    List<Text> actionTexts = [];
    for (DeviceAction a in actions) {
      String str = "";
      if (a is LockAction) {
        str = locksActionsToStr(a.action);
      } else if (a is AlarmAction) {
        str = alarmsActionsToStr(a.action);
      } else if (a is LightAction) {
        if (a.colorTemperature == null) {
          str = '${lightsActionsToStr(a.action)}.';
        } else {
          str =
              '${lightsActionsToStr(a.action)} a ${a.colorTemperature.toString()} K';
        }
      } else {
        str =
            '${thermostatsActionsToStr((a as ThermostatAction).action)} a ${a.desiredTemp.toString()} °C';
      }
      actionTexts.add(Text(
        "- $str",
        style: TextStyle(
          color: Colors.grey[1000000],
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                icon,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.device.deviceName,
                    style: (const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
              ],
            ),
          ),
          ...actionTexts,
          const Divider(),
        ],
      ),
    );
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

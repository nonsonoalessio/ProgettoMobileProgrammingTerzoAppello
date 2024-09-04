import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/camera.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import 'package:progetto_mobile_programming/views/minis.dart';

class AddNewDevicePage extends ConsumerStatefulWidget {
  const AddNewDevicePage({super.key});

  @override
  ConsumerState<AddNewDevicePage> createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends ConsumerState<AddNewDevicePage> {
  final TextEditingController _deviceNameController = TextEditingController();
  DeviceType _selectedDeviceType = DeviceType.light;
  bool _isDeviceOn = true;
  String? _selectedRoom;
  DeviceStatus _deviceStatus = DeviceStatus.on;
  double? _temperaturePicked;
  double? _colorTemperature;

  Future<int> _generateUniqueId() async {
    final devices = ref.watch(deviceNotifierProvider);
    int uniqueId = -1; // Inizializzazione con un valore predefinito
    bool isUnique = false;

    while (!isUnique) {
      final int timestamp =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      final int randomPart = Random().nextInt(1000);
      uniqueId = (timestamp % 1000000) * 1000 + randomPart;

      // Controlla se l'ID è già presente
      isUnique = !devices.any((device) => device.id == uniqueId);
    }

    return uniqueId;
  }

  void _handleDeviceTypeChanged(DeviceType newType) {
    setState(() {
      _selectedDeviceType = newType;
    });
  }

  void _handleDeviceOnOff(bool v) {
    setState(() {
      _isDeviceOn = v;
    });
  }

  void _handleRoomSelection(String room) {
    setState(() {
      _selectedRoom = room;
    });
  }

  void _handleDeviceStatus(DeviceStatus status) {
    setState(() {
      _deviceStatus = status;
    });
  }

  void _handleTemperaturePicker(double value) {
    setState(() {
      _temperaturePicked = value;
    });
  }

  void _handleColorTemperature(double value) {
    setState(() {
      _colorTemperature = value;
    });
  }

  bool _checkfields() {
    return _deviceNameController.text.isNotEmpty && _selectedRoom != null
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                                "Hai delle modifiche non salvate. Uscire?"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: const Text("ESCI"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ANNULLA'),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () async {
                if (_checkfields()) {
                  final uniqueId = await _generateUniqueId();
                  DeviceType deviceType = _selectedDeviceType;
                  Device device;
                  if (deviceType == DeviceType.light) {
                    device = Light(
                      deviceName: _deviceNameController.text,
                      room: _selectedRoom as String,
                      isActive: _deviceStatus == DeviceStatus.on ? true : false,
                      id: uniqueId,
                      // lightTemperature:
                    );
                  } else if (deviceType == DeviceType.alarm) {
                    device = Alarm(
                        deviceName: _deviceNameController.text,
                        room: _selectedRoom as String,
                        isActive:
                            _deviceStatus == DeviceStatus.on ? true : false,
                        id: uniqueId);
                  } else if (deviceType == DeviceType.lock) {
                    device = Lock(
                        deviceName: _deviceNameController.text,
                        room: _selectedRoom as String,
                        isActive:
                            _deviceStatus == DeviceStatus.on ? true : false,
                        id: uniqueId);
                  } else if (deviceType == DeviceType.camera) {
                    device = Camera(
                        deviceName: _deviceNameController.text,
                        room: _selectedRoom as String,
                        video: "",
                        id: uniqueId);
                  } else {
                    // deviceType == DeviceType.thermostat
                    device = Thermostat(
                        deviceName: _deviceNameController.text,
                        room: _selectedRoom as String,
                        detectedTemp: 24.0,
                        desiredTemp: _temperaturePicked ?? 18.0,
                        id: uniqueId);
                  }
                  ref.read(deviceNotifierProvider.notifier).addDevice(device);
                  Navigator.pop(context);
                } else {
                  String message;
                  if (_deviceNameController.text.isEmpty &&
                      _selectedRoom != null) {
                    message = "Impossibile salvare un dispositivo senza nome!";
                  } else if (_deviceNameController.text.isNotEmpty &&
                      _selectedRoom == null) {
                    message =
                        'Impossibile salvare un dispositivo non assegnato a nessuna stanza!';
                  } else {
                    message = 'Assegna un nome e una stanza al dispositivo!';
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                }
              },
              icon: const Icon(Icons.save),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              'Aggiungi nuovo dispositivo',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: DeviceChooser(
                onDeviceTypeChanged: _handleDeviceTypeChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Informazioni generali",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(
                hintText: 'Inserisci nome del dispositivo',
                border: OutlineInputBorder(),
              ),
            ),
            _selectedRoom == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ModalBottomSheetContent(
                                  valueChanged: _handleRoomSelection,
                                );
                              });
                        },
                        child: const Text('Scegli Stanza'),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(_selectedRoom as String),
                        deleteIcon: const Icon(Icons.delete),
                        onDeleted: () {
                          setState(() {
                            _selectedRoom = null;
                          });
                        },
                      ),
                    ),
                  ),
            if (_selectedDeviceType != DeviceType.camera) ...[
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: Text(
                  'Personalizza il dispositivo',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              _detailBuilder(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailBuilder() {
    if (_selectedDeviceType == DeviceType.alarm) {
      return Column(
        children: [
          DeviceStatusSelector(
            onValueChanged: _handleDeviceStatus,
            currentStatus: _deviceStatus,
            deviceType: DeviceType.alarm,
          ),
        ],
      );
    } else if (_selectedDeviceType == DeviceType.thermostat) {
      return Column(
        children: [
          FilledButton(
            child: const Text("Temperatura desiderata"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TemperaturePicker(
                  onValueChanged: _handleTemperaturePicker,
                ),
              );
            },
          ),
          Text("Temperatura scelta: $_temperaturePicked °C."),
        ],
      );
    } else if (_selectedDeviceType == DeviceType.lock) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DeviceStatusSelector(
              onValueChanged: _handleDeviceStatus,
              currentStatus: _deviceStatus,
              deviceType: DeviceType.lock),
        ],
      );
    } else if (_selectedDeviceType == DeviceType.light) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DeviceStatusSelector(
              onValueChanged: _handleDeviceStatus,
              currentStatus: _deviceStatus,
              deviceType: DeviceType.light,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ColorTemperatureSlider(
              onValueChanged: _handleColorTemperature,
            ),
          ),
        ],
      );
    } else if (_selectedDeviceType == DeviceType.camera) {
      return Container();
    } else {
      return Container(
        height: 10.0,
        width: 10.0,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      );
    }
  }
}

enum DeviceType { light, thermostat, lock, alarm, camera }

enum DeviceStatus { on, off }

class DeviceChooser extends StatefulWidget {
  final ValueChanged<DeviceType> onDeviceTypeChanged;

  const DeviceChooser({super.key, required this.onDeviceTypeChanged});

  @override
  State<DeviceChooser> createState() => _DeviceChooserState();
}

class _DeviceChooserState extends State<DeviceChooser> {
  DeviceType deviceType = DeviceType.light;
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: [
        const ButtonSegment<DeviceType>(
            value: DeviceType.light, label: Icon(Icons.lightbulb)),
        const ButtonSegment<DeviceType>(
            value: DeviceType.thermostat, label: Icon(Icons.thermostat)),
        const ButtonSegment<DeviceType>(
            value: DeviceType.alarm, label: Icon(Icons.doorbell)),
        const ButtonSegment<DeviceType>(
            value: DeviceType.lock, label: Icon(Icons.lock)),
        const ButtonSegment<DeviceType>(
            value: DeviceType.camera, label: Icon(Icons.camera)),
      ],
      selected: <DeviceType>{deviceType},
      onSelectionChanged: (Set<DeviceType> newSelection) {
        setState(() {
          deviceType = newSelection.first;
        });
        widget.onDeviceTypeChanged(deviceType);
      },
    );
  }
}

class SwitchBuilderWithCallback extends StatefulWidget {
  final ValueChanged<bool> valueChanged;
  final bool currentValue;

  const SwitchBuilderWithCallback(
      {super.key, required this.valueChanged, required this.currentValue});

  @override
  State<SwitchBuilderWithCallback> createState() =>
      _SwitchBuilderWithCallbackState();
}

class _SwitchBuilderWithCallbackState extends State<SwitchBuilderWithCallback> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue; // Inizializza la variabile di stato
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _currentValue,
      onChanged: (bool value) {
        setState(() {
          _currentValue = value;
        });
        widget.valueChanged(value);
      },
    );
  }
}

class ModalBottomSheetContent extends ConsumerStatefulWidget {
  final ValueChanged<String> valueChanged;

  const ModalBottomSheetContent({super.key, required this.valueChanged});

  @override
  ConsumerState<ModalBottomSheetContent> createState() =>
      _ModalBottomSheetContentState();
}

class _ModalBottomSheetContentState
    extends ConsumerState<ModalBottomSheetContent> {
  String? _room;
  final TextEditingController _newRoomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> rooms = ref.watch(roomsProvider).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determina l'altezza massima che la lista può occupare
        double maxListHeight = min(
          constraints.maxHeight *
              0.5, // Limitazione a metà dell'altezza disponibile
          rooms.length *
              60.0, // Altezza della lista basata sul numero di stanze (60px per ogni stanza)
        );

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Contenitore con altezza dinamica
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxListHeight),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(rooms[index]),
                        leading: Radio<String>(
                          value: rooms[index],
                          groupValue: _room,
                          onChanged: (String? value) {
                            setState(() {
                              _room = value;
                            });
                            widget.valueChanged(_room as String);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _newRoomController,
                    decoration: InputDecoration(
                      labelText: "Nome nuova stanza",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        String newRoom = _newRoomController.text.trim();
                        if (newRoom.isNotEmpty) {
                          ref
                              .read(deviceNotifierProvider.notifier)
                              .addRoom(newRoom);
                          widget.valueChanged(newRoom);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Il nome della stanza non può essere vuoto.")),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.add), Text("Aggiungi stanza")],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TemperaturePicker extends StatefulWidget {
  final ValueChanged<double> onValueChanged;
  const TemperaturePicker({super.key, required this.onValueChanged});

  @override
  State<TemperaturePicker> createState() => _TemperaturePickerState();
}

class _TemperaturePickerState extends State<TemperaturePicker> {
  final TextEditingController _temperaturePicked = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double temp = 18;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Temperatura desiderata:"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _temperaturePicked,
                decoration: InputDecoration(
                  hintText: "$temp °C",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Converte l'input in un double e controlla che sia valido. Se non è valido imposta temperatura di default a 18.0 gradi Celsius
                    temp = double.tryParse(_temperaturePicked.text) ?? 18.0;
                  });
                  widget.onValueChanged(temp);
                  Navigator.pop(context);
                },
                child: const Text('Salva'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeviceStatusSelector extends StatefulWidget {
  final ValueChanged<DeviceStatus> onValueChanged;
  final DeviceStatus currentStatus;
  final DeviceType deviceType;
  const DeviceStatusSelector(
      {super.key,
      required this.onValueChanged,
      required this.currentStatus,
      required this.deviceType});

  @override
  State<DeviceStatusSelector> createState() => _DeviceStatusSelectorState();
}

class _DeviceStatusSelectorState extends State<DeviceStatusSelector> {
  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = widget.deviceType;
    DeviceStatus status = widget.currentStatus;
    return SegmentedButton(
      segments: [
        ButtonSegment(
          value: DeviceStatus.on,
          icon: Icon(
            deviceType == DeviceType.light ? Icons.lightbulb : Icons.lock,
          ),
          label: const Text('On'),
        ),
        ButtonSegment(
          value: DeviceStatus.off,
          icon: Icon(
            deviceType == DeviceType.light
                ? Symbols.light_off_sharp
                : Symbols.lock_open_right,
          ),
          label: const Text('Off'),
        ),
      ],
      selected: <DeviceStatus>{status},
      onSelectionChanged: (Set<DeviceStatus> newSel) {
        setState(() {
          status = newSel.first;
        });
        widget.onValueChanged(status);
      },
    );
  }
}

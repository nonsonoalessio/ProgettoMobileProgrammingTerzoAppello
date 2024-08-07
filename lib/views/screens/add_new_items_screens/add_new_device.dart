// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:progetto_mobile_programming/models/alarm.dart';
import 'package:progetto_mobile_programming/models/device.dart';
import 'package:progetto_mobile_programming/models/light.dart';
import 'package:progetto_mobile_programming/models/lock.dart';
import 'package:progetto_mobile_programming/models/thermostat.dart';
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Hai delle modifiche non salvate. Uscire?"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: Text("ESCI"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('ANNULLA'),
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
              onPressed: () {
                // TODO: checkfields
                DeviceType deviceType = _selectedDeviceType;
                Device device;
                if (deviceType == DeviceType.light) {
                  device = Light(
                    deviceName: _deviceNameController.text,
                    room: _selectedRoom as String,
                    isActive: _deviceStatus == DeviceStatus.on ? true : false,
                    // lightTemperature:
                  );
                } else if (deviceType == DeviceType.alarm) {
                  device = Alarm(
                      deviceName: _deviceNameController.text,
                      room: _selectedRoom as String,
                      isActive:
                          _deviceStatus == DeviceStatus.on ? true : false);
                } else if (deviceType == DeviceType.lock) {
                  device = Lock(
                      deviceName: _deviceNameController.text,
                      room: _selectedRoom as String,
                      isActive:
                          _deviceStatus == DeviceStatus.on ? true : false);
                } else {
                  // deviceType == DeviceType.thermostat
                  device = Thermostat(
                    deviceName: _deviceNameController.text,
                    room: _selectedRoom as String,
                    detectedTemp: 0.0,
                    desiredTemp: 0.0,
                  );
                }
                ref
                    .read(deviceNotifierProvider.notifier)
                    .db
                    .insertDevice(device);
                Navigator.pop(context);
              },
              icon: Icon(Icons.save),
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
                onDeviceTypeChanged:
                    _handleDeviceTypeChanged, // Passa il callback
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
              decoration: InputDecoration(
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
                        child: Text('Scegli Stanza'),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(_selectedRoom as String),
                        deleteIcon: Icon(Icons.delete),
                        onDeleted: () {
                          setState(() {
                            _selectedRoom = null;
                          });
                        },
                      ),
                    ),
                  ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
              child: Text(
                'Personalizza il dispositivo',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            _detailBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _detailBuilder() {
    if (_selectedDeviceType == DeviceType.alarm) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("L'allarme è inserito?"),
          SwitchBuilderWithCallback(
            valueChanged: _handleDeviceOnOff,
            currentValue: _isDeviceOn,
          ),
        ],
      );
    } else if (_selectedDeviceType == DeviceType.thermostat) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilledButton(
            child: Text("Temperatura desiderata"),
            onPressed: () {},
          )
        ],
      );
    } else if (_selectedDeviceType == DeviceType.lock) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("La serratura è chiusa?"),
          SwitchBuilderWithCallback(
            valueChanged: _handleDeviceOnOff,
            currentValue: _isDeviceOn,
          ),
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
            child: ColorTemperatureSlider(),
          ),
        ],
      );
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

enum DeviceType { light, thermostat, lock, alarm }

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
        ButtonSegment<DeviceType>(
          value: DeviceType.light,
          label: deviceType == DeviceType.light
              ? Icon(Icons.lightbulb)
              : Column(
                  children: [
                    Icon(Icons.lightbulb),
                    Text('Luce'),
                  ],
                ),
        ),
        ButtonSegment<DeviceType>(
          value: DeviceType.thermostat,
          // icon: Icon(Icons.thermostat),
          label: deviceType == DeviceType.thermostat
              ? Icon(Icons.thermostat)
              : Column(
                  children: [
                    Icon(Icons.thermostat),
                    Text('Termostato'),
                  ],
                ),
        ),
        ButtonSegment<DeviceType>(
          value: DeviceType.alarm,
          label: deviceType == DeviceType.alarm
              ? Icon(Icons.doorbell)
              : Column(
                  children: [
                    Icon(Icons.doorbell),
                    Text('Allarme'),
                  ],
                ),
        ),
        ButtonSegment<DeviceType>(
          value: DeviceType.lock,
          label: deviceType == DeviceType.lock
              ? Icon(Icons.lock)
              : Column(
                  children: [
                    Icon(Icons.lock),
                    Text('Serratura'),
                  ],
                ),
        ),
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

class AlarmDetailsBuilder extends StatelessWidget {
  const AlarmDetailsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Ciao ciao ciao ciao mareeee');
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

  @override
  Widget build(BuildContext context) {
    List<String> rooms = ref.watch(roomsProvider).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          itemCount: rooms.length,
          shrinkWrap: true,
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
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add), Text("Aggiungi stanza")],
                ),
              ),
            ),
          ),
        ),
      ],
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
          label: Text('On'),
        ),
        ButtonSegment(
          value: DeviceStatus.off,
          icon: Icon(
            deviceType == DeviceType.light
                ? Symbols.light_off_sharp
                : Symbols.lock_open_right,
          ),
          label: Text('Off'),
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

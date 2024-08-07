// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/alarm.dart';
import 'package:progetto_mobile_programming/models/device.dart';

class AddNewDevicePage extends ConsumerStatefulWidget {
  const AddNewDevicePage({super.key});

  @override
  ConsumerState<AddNewDevicePage> createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends ConsumerState<AddNewDevicePage> {
  final TextEditingController _deviceNameController = TextEditingController();
  DeviceType _selectedDeviceType = DeviceType.light;

  void _handleDeviceTypeChanged(DeviceType newType) {
    setState(() {
      _selectedDeviceType = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            Text('Nome del dispositivo:'),
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                hintText: 'Inserisci nome del dispositivo',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Scegli Stanza'),
            ),
            _detailBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _detailBuilder() {
    if (_selectedDeviceType == DeviceType.alarm) {
      return Container(
        height: 10.0,
        width: 10.0,
        color: Colors.red,
      );
    } else if (_selectedDeviceType == DeviceType.thermostat) {
      return Container(
        height: 10.0,
        width: 10.0,
        color: Colors.yellow,
      );
    } else if (_selectedDeviceType == DeviceType.lock) {
      return Container(
        height: 10.0,
        width: 10.0,
        color: Colors.green,
      );
    } else if (_selectedDeviceType == DeviceType.light) {
      return Container(
        height: 10.0,
        width: 10.0,
        color: Colors.blue,
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
          icon: Icon(Icons.lightbulb),
          label: Text('Luce'),
        ),
        ButtonSegment<DeviceType>(
          value: DeviceType.thermostat,
          icon: Icon(Icons.thermostat),
          label: Text('Termostato'),
        ),
        ButtonSegment<DeviceType>(
          value: DeviceType.alarm,
          icon: Icon(Icons.alarm),
          label: Text('Allarme'),
        ),
        ButtonSegment<DeviceType>(
          value: DeviceType.lock,
          icon: Icon(Icons.lock),
          label: Text('Serratura'),
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

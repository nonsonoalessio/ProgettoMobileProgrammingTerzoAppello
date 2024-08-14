import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/objects/camera.dart';
import '../../models/objects/device.dart';
import '../../models/objects/alarm.dart';
import '../../models/objects/light.dart';
import '../../models/objects/lock.dart';
import '../../models/objects/thermostat.dart';

// Classe base per le pagine dei singoli devices
// Questa classe include elementi UI comuni a tutti
// i device come: AppBar, informazioni e statistiche sul device selezionato

// Le sottoclassi implementeranno buildDeviceSpecificWidget
// che mostrerà funzioni specifiche del device selezionato.

class DeviceDetailPage extends ConsumerStatefulWidget {
  final Device device;
  const DeviceDetailPage({super.key, required this.device});

  @override
  ConsumerState<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends ConsumerState<DeviceDetailPage> {
  late TextEditingController _deviceNameController;
  String? _selectedRoom; // memorizza la stanza nella quale si trova il device

  @override
  void initState() {
    super.initState(); //
    TextEditingController(text: widget.device.deviceName);
    _selectedRoom = widget.device.room;
  }

  void _handleRoomSelection(String room) {
    setState(() {
      _selectedRoom = room;
    });
  }

  bool _checkFields() {
    return _deviceNameController.text.isNotEmpty && _selectedRoom != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.deviceName),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: null, // _saveDevice,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.device.deviceName}',
                style: Theme.of(context).textTheme.displayMedium),
            Text('Stanza: ${widget.device.room}',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            _buildDeviceSpecificWidget(
                widget.device), // Chiamiao il metodo specifico per ogni widget
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSpecificWidget(Device device) {
    if (device is Light) {
      return _buildLightWidget(device);
    } else if (device is Alarm) {
      return _buildAlarmWidget(device);
    } else if (device is Lock) {
      return _buildLockWidget(device);
    } else if (device is Thermostat) {
      return _buildThermostatWidget(device);
    } else if (device is Camera) {
      return _buildCameraWidget(device);
    } else {
      return const Text('Device sconosciuto'); 
    }
  }

  Widget _buildLightWidget(Light light) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stato del dispositivo: ${light.isActive ? "On" : "Off"}'),
        Slider(
          value: light.lightTemperature.toDouble(),
          min: 0,
          max: 100,
          onChanged: (double value) {
            // Aggiorna la lightTemperature
          },
        ),
        ElevatedButton(
          onPressed: () {
            // Spegni/accendi luce
          },
          child: Text(light.isActive ? 'Spegni la luce' : 'Accendi la luce'),
        ),
      ],
    );
  }

  Widget _buildAlarmWidget(Alarm alarm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Stato dell\' allarme: ${alarm.isActive ? "Attivo" : "Disattivo"}'),
        ElevatedButton(
          onPressed: () {
            // Accendi spegni allarme
          },
          child: Text(alarm.isActive ? 'Disattiva' : 'Attiva'),
        ),
      ],
    );
  }

  Widget _buildLockWidget(Lock lock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Stato della serratura: ${lock.isActive ? "Bloccata" : "Sbloccata"}'),
        ElevatedButton(
          onPressed: () {
            // Spegni/accendi
          },
          child: Text(lock.isActive ? 'Sblocca' : 'Blocca'),
        ),
      ],
    );
  }

  Widget _buildThermostatWidget(Thermostat thermostat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Temperatura corrente: ${thermostat.detectedTemp}°C'),
        Slider(
          value: thermostat.desiredTemp.toDouble(),
          min: 16,
          max: 30,
          onChanged: (double value) {
            // Cambia la temperatura del termostato
          },
        ),
      ],
    );
  }


  Widget _buildCameraWidget(Camera camera) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(''),
        ElevatedButton(
          onPressed: () {
            // Spegni/accendi camera
          },
          child: null,
        ),
      ],
    );
  }
}

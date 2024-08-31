import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:progetto_mobile_programming/providers/notifications_provider.dart';
import 'package:progetto_mobile_programming/services/localnotification_service.dart';
import 'package:progetto_mobile_programming/views/minis.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import '../../models/objects/camera.dart';
import '../../models/objects/device.dart';
import '../../models/objects/alarm.dart';
import '../../models/objects/light.dart';
import '../../models/objects/lock.dart';
import '../../models/objects/thermostat.dart';

class DeviceDetailPage extends ConsumerStatefulWidget {
  final Device device;
  const DeviceDetailPage({super.key, required this.device});

  @override
  ConsumerState<DeviceDetailPage> createState() => _DeviceDetailPageState();
}
class EnergySavingSuggestions extends StatelessWidget {
  final Device device;
  const EnergySavingSuggestions({Key? key, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> suggestions;

    if (device is Light) {
      suggestions = [
        'Spegni le luci quando non sono necessarie.',
        'Utilizza lampadine a LED invece delle incandescenti.',
      ];
    } else if (device is Thermostat) {
      suggestions = [
        'Imposta il termostato a una temperatura ottimale.',
        'Utilizza una programmazione per ridurre il consumo durante la notte.',
      ];
    } else if (device is Camera) {
      suggestions = [
        'Disattiva la telecamera quando non è necessaria.',
        'Verifica le impostazioni di registrazione per ottimizzare il consumo energetico.',
      ];
    } else if (device is Lock) {
      suggestions = [
        'Controlla se la serratura è in modalità di risparmio energetico.',
        'Verifica le impostazioni della batteria se è una serratura elettronica.',
      ];
    } else if (device is Alarm) {
      suggestions = [
        'Imposta l’allarme per spegnersi automaticamente quando non è in uso.',
        'Controlla le impostazioni per evitare falsi allarmi e consumi inutili.',
      ];
    } else {
      suggestions = [
        'Controlla il manuale del dispositivo per suggerimenti specifici.',
      ];
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggerimenti per risparmiare energia:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),



          //  style: Theme.of(context)
          //     .textTheme.bodyLarge
          //    ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...suggestions
              .map((suggestion) => _buildSuggestion(suggestion))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              suggestion,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceDetailPageState extends ConsumerState<DeviceDetailPage> {
  late TextEditingController _deviceNameController;
  String? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _deviceNameController =
        TextEditingController(text: widget.device.deviceName);
    _selectedRoom = widget.device.room;
  }

  void _handleRoomSelection(String room) {
    setState(() {
      _selectedRoom = room;
    });
  }

// Remind: Le notifiche non vengono aggiunte al DB per problemi di casting
  void _wrap(Device device) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    LocalNoti().init();

    String body = "Stato del dispositivo modificato correttamente.";

    setState(() {
      int notificationId = DeviceNotification.generateUniqueId();
      if (device is Light) {
        // Accendiamo o spegnamo la lampadina
        device.isActive = !device.isActive;

        // Creiamo la notifica
        final newNotification = DeviceNotification(
          id: notificationId,
          title: 'Stato del dispositivo modificato correttamente.',
          device: Light(
              deviceName: device.deviceName, room: device.room, id: device.id),
          deliveryTime: TimeOfDay.now(),
          isRead: false,
          description: '',
          categories: null,
        );

        // Aggiungiamo la notifica al database
        ref
            .read(notificationsNotifierProvider.notifier)
            .addNotification(newNotification);

        // Mostriamo la notifica
        LocalNoti().showBigTextNotification(
          id: notificationId,
          title: 'Hai modificato lo stato della luce!',
          body: body,
          fln: flutterLocalNotificationsPlugin,
        );
      } else if (device is Alarm) {
        // Accendiamo o spegnamo l'allarme
        device.isActive = !device.isActive;

        // Creiamo la notifica
        final newNotification = DeviceNotification(
            id: notificationId,
            title: 'Stato del dispositivo modificato correttamente.',
            device: Alarm(
                deviceName: device.deviceName,
                room: device.room,
                id: device.id),
            deliveryTime: TimeOfDay.now());

        // Aggiungiamo la notifica al database
        ref
            .read(notificationsNotifierProvider.notifier)
            .addNotification(newNotification);

        // Mostriamo la notifica
        LocalNoti().showBigTextNotification(
          id: notificationId,
          title: 'Hai modificato lo stato dell\'allarme!',
          body: body,
          fln: flutterLocalNotificationsPlugin,
        );
      } else if (device is Lock) {
        // Accendiamo o spegnamo la serraturra
        device.isActive = !device.isActive;

        // Creiamo la notifica
        final newNotification = DeviceNotification(
            id: notificationId,
            title: 'Stato del dispositivo modificato correttamente.',
            device: Light(
                deviceName: device.deviceName,
                room: device.room,
                id: device.id),
            deliveryTime: TimeOfDay.now());

        // Aggiungiamo la notifica al database
        ref
            .read(notificationsNotifierProvider.notifier)
            .addNotification(newNotification);

        // Mostriamo la notifica
        LocalNoti().showBigTextNotification(
          id: notificationId,
          title: 'Hai modificato lo stato della serratura!',
          body: body,
          fln: flutterLocalNotificationsPlugin,
        );
      }
    });
  }

  bool _checkFields() {
    return _deviceNameController.text.isNotEmpty && _selectedRoom != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.device.deviceName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                  color: Colors.grey[100],
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Stanza: ${widget.device.room}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              const SizedBox(height: 20),
              _buildDeviceSpecificWidget(widget.device),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceSpecificWidget(Device device) {
    List<Widget> widgets = [];

    if (device is Light) {
      widgets.add(_buildLightWidget(device));
    } else if (device is Alarm) {
      widgets.add(_buildAlarmWidget(device));
    } else if (device is Lock) {
      widgets.add(_buildLockWidget(device));
    } else if (device is Thermostat) {
      widgets.add(_buildThermostatWidget(device));
    } else if (device is Camera) {
      widgets.add(_buildCameraWidget(device));
    } else {
      widgets.add(const Text('Device sconosciuto'));
    }

    widgets.add(const SizedBox(height: 8));

    widgets.add(const Divider());

    widgets.add(const SizedBox(height: 8));


    widgets.add(
      const Text(
        "Overview consumo giornaliero elettricità in kWh: ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );

    widgets.add(const SizedBox(height: 10));

    widgets.add(
      SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(right: 10), // Padding a destra
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 2,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return const FlLine(
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize:
                        40, // Abbassando questo valore: grafico shifta verso sinistra
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toStringAsFixed(1)} kWh',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: 4,
                    getTitlesWidget: (value, meta) {
                      final int hour = value.toInt();
                      final String hourStr =
                          hour < 10 ? '0$hour:00' : '$hour:00';
                      return Text(
                        hourStr,
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10, // Riserva spazio a destra
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              minX: 0,
              maxX: 24,
              minY: 0,
              maxY: 5,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1.2),
                    FlSpot(4, 1.8),
                    FlSpot(8, 2.6),
                    FlSpot(12, 2.0),
                    FlSpot(16, 3.6),
                    FlSpot(20, 3.3),
                    FlSpot(24, 2.5),
                  ],
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  widgets.add(EnergySavingSuggestions(device: device));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildLightWidget(Light light) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Stato della lampadina: ',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    light.isActive ? "On" : "Off",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _wrap(light);
                });
              },
              child:
                  Text(light.isActive ? 'Spegni la luce' : 'Accendi la luce'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text('Temperatura della lampadina:'),
        SizedBox(height: 8),
        ColorTemperatureSlider(
          onValueChanged: (value) {
            setState(() {
              light.lightTemperature = value.toInt();
              ref.read(deviceNotifierProvider.notifier).updateDevice(light);
            });
          },
        ),
      ],
    );
  }

  Widget _buildAlarmWidget(Alarm alarm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "Stato dell\'allarme: ",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                alarm.isActive ? "Attivo" : "Disattivo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _wrap(alarm);
            });
          },
          child: Text(alarm.isActive ? 'Disattiva' : 'Attiva'),
        ),
      ],
    );
  }

  Widget _buildLockWidget(Lock lock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  'Stato della serratura: ',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                lock.isActive ? "Bloccata" : "Sbloccata",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _wrap(lock);
            });
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
        SizedBox(height: 8),
        Slider(
          value: thermostat.desiredTemp.toDouble(),
          min: 16,
          max: 30,
          onChanged: (double value) {
            setState(() {
              thermostat.desiredTemp = value;
              ref
                  .read(deviceNotifierProvider.notifier)
                  .updateDevice(thermostat);
            });
          },
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: Text(
                'Temperatura desiderata: ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${thermostat.desiredTemp.toStringAsFixed(1)}°C',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraWidget(Camera camera) {
    return Builder(
      builder: (BuildContext context) {
        String? _capturedImage;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video corrente:',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Video stream: ${camera.video}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // possibile aggiornamento del video/funzionalità aggiuntive ?
                    },
                    child: const Text('Aggiorna video stream'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _capturedImage = 'assets/images/carmine.jpg';
                      });
                    },
                    child: const Text('Scatta foto'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_capturedImage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foto catturata:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      _capturedImage!,
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
            ],
          );
        });
      },
    );
  }
}

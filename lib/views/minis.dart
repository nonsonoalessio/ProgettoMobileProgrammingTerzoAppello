import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import 'package:progetto_mobile_programming/views/screens/page_device_detail.dart';

class ColorTemperatureSlider extends StatefulWidget {
  final ValueChanged<double> onValueChanged;
  const ColorTemperatureSlider({super.key, required this.onValueChanged});

  @override
  ColorTemperatureSliderState createState() => ColorTemperatureSliderState();
}

class ColorTemperatureSliderState extends State<ColorTemperatureSlider> {
  double _currentTemperature = 3000;

  // Funzione per ottenere il colore corrispondente alla temperatura
  Color _getColorForTemperature(double temperature) {
    if (temperature <= 2000) {
      return const Color(0xFFFF3800); // Rosso
    } else if (temperature <= 3000) {
      return const Color(0xFFFFD700); // Giallo
    } else if (temperature <= 4000) {
      return const Color(0xFFFFFFE0); // Bianco caldo
    } else if (temperature <= 5000) {
      return const Color(0xFFFFFFFF); // Bianco puro
    } else {
      return const Color(0xFFADD8E6); // Bianco freddo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Color(0xFFFF3800),
                  ),
                  Text("Più calda"),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Color(0xFFADD8E6),
                  ),
                  Text("Più fredda"),
                ],
              ),
            ],
          ),
        ),
        Slider(
          value: _currentTemperature,
          min: 2000,
          max: 6500,
          divisions: 45,
          onChanged: (double value) {
            setState(() {
              _currentTemperature = value;
            });
            widget.onValueChanged(value);
          },
          activeColor: _getColorForTemperature(_currentTemperature),
        ),
        /*Container(
          width: 300,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF3800),
                Color(0xFFFFD700),
                Color(0xFFFFFFE0),
                Color(0xFFFFFFFF),
                Color(0xFFADD8E6),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),*/
      ],
    );
  }
}

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  // Dati casuali riguardo il consumo durante 24 ore di un device (intervallo di 2 ore)
  final List<FlSpot> spots = [
    const FlSpot(0, 1.2),
    const FlSpot(2, 2.4),
    const FlSpot(4, 1.8),
    const FlSpot(6, 3.0),
    const FlSpot(8, 2.6),
    const FlSpot(10, 3.5),
    const FlSpot(12, 2.0),
    const FlSpot(14, 2.8),
    const FlSpot(16, 3.6),
    const FlSpot(18, 4.0),
    const FlSpot(20, 3.3),
    const FlSpot(22, 2.7),
    const FlSpot(24, 2.5),
  ];

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
        title: const Text("Overview consumo giornaliero elettricità in kWh"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 2,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    // Ritorna un oggetto FlLine che rappresenta una linea orizzontale
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return const FlLine(
                    // Ritorna un oggetto FlLine che rappresenta una linea verticale
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                // Etichetta degli assi del grafico
                leftTitles: AxisTitles(
                  // Ordinate
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      // Costruisce la stringa formattata da un value + kWh
                      return Text(
                        '${value.toStringAsFixed(1)} kWh',
                        style: const TextStyle(
                          fontSize:
                              10, // Serve per gestire la grandezza delle label
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  // Ascisse
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}:00',
                        style: const TextStyle(
                          fontSize:
                              10, // Serve per gestire la grandezza delle label
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                      showTitles:
                          false), // Non mostrare top labels                )
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false), // Non mostrare labels a destra
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
                  spots: spots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(
                    show: true,
                  ),
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
  }
}

class ListOfDevice extends ConsumerWidget {
  final Function predicate;
  const ListOfDevice({super.key, required this.predicate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(deviceNotifierProvider);
    return const Placeholder();
  }
}

class DeviceCard extends StatefulWidget {
  final Device device;
  const DeviceCard({super.key, required this.device});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ListGenerator extends ConsumerWidget {
  final bool Function(Device) predicate;

  const ListGenerator({super.key, required this.predicate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceList =
        ref.watch(deviceNotifierProvider).where(predicate).toList();
    late Icon deviceIcon;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Device List",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: deviceList.length,
              itemBuilder: (context, index) {
                if (deviceList[index] is Lock) {
                  deviceIcon =
                      Icon(Icons.lock, color: theme.colorScheme.primary);
                } else if (deviceList[index] is Alarm) {
                  deviceIcon =
                      Icon(Icons.doorbell, color: theme.colorScheme.primary);
                } else if (deviceList[index] is Thermostat) {
                  deviceIcon =
                      Icon(Icons.thermostat, color: theme.colorScheme.primary);
                } else if (deviceList[index] is Light) {
                  deviceIcon =
                      Icon(Icons.lightbulb, color: theme.colorScheme.primary);
                } else {
                  deviceIcon =
                      Icon(Icons.camera, color: theme.colorScheme.primary);
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DeviceDetailPage(device: deviceList[index]),
                      ),
                    );
                  },
                  child: Container(
                    width: 140, // Maggiore larghezza per la card
                    margin: const EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12.0), // Padding interno
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: deviceIcon,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          deviceList[index].deviceName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

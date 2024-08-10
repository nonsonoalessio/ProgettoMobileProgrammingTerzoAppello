import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:progetto_mobile_programming/models/device.dart';

class ListOfChips extends StatelessWidget {
  final Future<List<String>> future;
  const ListOfChips({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData) {
            final List<String> names = snapshot.data as List<String>;
            return ListView.builder(
              itemCount: names.length,
              prototypeItem: Chip(
                label: Text(names.first),
              ),
              itemBuilder: (context, index) {
                return Chip(
                  label: Text(names[index]),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        });
  }
}

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

class DeviceCard extends StatefulWidget {
  final Device device;
  const DeviceCard({super.key, required this.device});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    Device _device = widget.device;
    return Container();
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
    FlSpot(0, 1.2),
    FlSpot(2, 2.4),
    FlSpot(4, 1.8),
    FlSpot(6, 3.0),
    FlSpot(8, 2.6),
    FlSpot(10, 3.5),
    FlSpot(12, 2.0),
    FlSpot(14, 2.8),
    FlSpot(16, 3.6),
    FlSpot(18, 4.0),
    FlSpot(20, 3.3),
    FlSpot(22, 2.7),
    FlSpot(24, 2.5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Overview consumo giornaliero elettricità in kWh"),
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
                  return FlLine(
                    // Ritorna un oggetto FlLine che rappresenta una linea orizzontale
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
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
                        style: TextStyle(
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
                        style: TextStyle(
                          fontSize:
                              10, // Serve per gestire la grandezza delle label
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles:
                          false), // Non mostrare top labels                )
                ),
                rightTitles: AxisTitles(
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
                  dotData: FlDotData(
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

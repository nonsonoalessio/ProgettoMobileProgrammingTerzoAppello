import 'package:flutter/material.dart';

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
  const ColorTemperatureSlider({super.key});

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
        Slider(
          value: _currentTemperature,
          min: 2000,
          max: 6500,
          divisions: 45,
          onChanged: (double value) {
            setState(() {
              _currentTemperature = value;
            });
          },
          activeColor: _getColorForTemperature(_currentTemperature),
        ),
        Container(
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
        ),
      ],
    );
  }
}

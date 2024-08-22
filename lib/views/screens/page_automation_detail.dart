import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/functionalities/automation.dart';
 // Importa la classe Automation

class AutomationDetailPage extends StatelessWidget {
  final Automation automation;

  const AutomationDetailPage({Key? key, required this.automation}) : super(key: key);

  String formatWeatherCondition(WeatherCondition? condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'Sunny';
      case WeatherCondition.cloudy:
        return 'Cloudy';
      case WeatherCondition.rainy:
        return 'Rainy';
      case WeatherCondition.hot:
        return 'Hot';
      case WeatherCondition.cold:
        return 'Cold';
      case WeatherCondition.snowy:
        return 'Snowy';
      default:
        return 'None';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(automation.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome automazione: ${automation.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Orario di esecuzione: ${(MaterialLocalizations.of(context).formatTimeOfDay(automation.executionTime))}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Condizioni meteo: ${formatWeatherCondition(automation.weather)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Azioni:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: automation.actions.length,
                itemBuilder: (context, index) {
                  final action = automation.actions[index];
                  return ListTile(
                    title: Text(action.runtimeType.toString()), // Nome della classe dell'azione
                    subtitle: Text(action.toMap().toString()), // Dettagli dell'azione
                    leading: const Icon(Icons.device_unknown),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

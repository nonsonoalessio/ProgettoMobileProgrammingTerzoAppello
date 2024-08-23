import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/functionalities/automation.dart';

class AutomationDetailPage extends StatefulWidget {
  final Automation automation;

  const AutomationDetailPage({Key? key, required this.automation}) : super(key: key);

  @override
  _AutomationDetailPageState createState() => _AutomationDetailPageState();
}

class _AutomationDetailPageState extends State<AutomationDetailPage> {
  late String _name;
  late TimeOfDay _executionTime;
  WeatherCondition? _weatherCondition;
  late List<DeviceAction> _actions;

  @override
  void initState() {
    super.initState();
    _name = widget.automation.name;
    _executionTime = widget.automation.executionTime;
    _weatherCondition = widget.automation.weather;
    _actions = List.from(widget.automation.actions);
  }

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

  Future<void> _updateAutomation() async {
    // Implementa il metodo per aggiornare l'automazione nel database
    // Ad esempio: await DatabaseService.updateAutomation(Automation(...));
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _executionTime,
    );
    if (picked != null && picked != _executionTime) {
      setState(() {
        _executionTime = picked;
      });
    }
  }

  void _editAction(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final action = _actions[index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Modifica Azione', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Implementa qui l'interfaccia per modificare l'azione
              // Esempio: TextField per modificare i parametri dell'azione
              ElevatedButton(
                onPressed: () {
                  // Salva i cambiamenti
                  Navigator.pop(context);
                },
                child: Text('Salva'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Modifica Automazione'),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            await _updateAutomation();
            Navigator.pop(context);
          },
        ),
      ],
    ),
    body: SingleChildScrollView( // Aggiungi SingleChildScrollView qui
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Nome automazione',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _name = value,
            controller: TextEditingController(text: _name),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text('Orario di esecuzione'),
            subtitle: Text(MaterialLocalizations.of(context).formatTimeOfDay(_executionTime)),
            trailing: Icon(Icons.edit),
            onTap: () => _selectTime(context),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<WeatherCondition>(
            decoration: InputDecoration(
              labelText: 'Condizioni meteo',
              border: OutlineInputBorder(),
            ),
            value: _weatherCondition,
            items: WeatherCondition.values.map((WeatherCondition condition) {
              return DropdownMenuItem<WeatherCondition>(
                value: condition,
                child: Text(formatWeatherCondition(condition)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _weatherCondition = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Azioni:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              final action = _actions[index];
              return ListTile(
                title: Text(action.runtimeType.toString()),
                subtitle: Text(action.toMap().toString()),
                leading: const Icon(Icons.device_unknown),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editAction(index),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              // Aggiungi una nuova azione
            },
            icon: Icon(Icons.add),
            label: Text('Aggiungi Azione'),
          ),
        ],
      ),
    ),
  );
}

}

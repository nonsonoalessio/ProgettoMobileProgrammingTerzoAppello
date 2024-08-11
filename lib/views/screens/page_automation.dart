// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AutomationPage extends StatelessWidget {
  const AutomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Automazioni'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Nome Automazione',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Descrizione di cosa fa l\'automazione',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Quando: condizione scatenante',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Divider(),
              // Spazio vuoto per aggiungere altri elementi
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Aggiungi Automazione'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

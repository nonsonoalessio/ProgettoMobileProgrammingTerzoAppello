// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/providers/automations_provider.dart';
import 'package:progetto_mobile_programming/views/screens/add_new_items_screens/add_new_automation.dart';

class AutomationPage extends ConsumerWidget {
  const AutomationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final automations = ref.watch(automationsNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
            child: automations.isEmpty
              ? Center(child: Text('Non hai aggiunto nessuna automazione')) // Caso in cui la lista è vuota
               : ListView.builder(
                itemCount: automations.length,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(automations[index].name),
                          subtitle: Text("L'automazione andrà in azione alle ore ${automations[index].executionTime}"),
                          onTap: () {
                            // Porta a pagina di dettaglio
                          },
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewAutomationPage()));
        },
        label: Text('Aggiungi Automazione'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

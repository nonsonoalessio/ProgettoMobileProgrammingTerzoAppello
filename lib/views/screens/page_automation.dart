import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/providers/automations_provider.dart';
import 'package:progetto_mobile_programming/views/screens/add_new_items_screens/add_new_automation.dart';
import 'package:progetto_mobile_programming/views/screens/page_automation_detail.dart';

class AutomationPage extends ConsumerWidget {
  const AutomationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var automations = ref.watch(automationsNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Le tue automazioni',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: automations.isEmpty
                    ? const Center(
                        child: Text('Non hai aggiunto nessuna automazione'),
                      )
                    : FutureBuilder<int>(
                        future: ref
                            .read(automationsNotifierProvider.notifier)
                            .ciao(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListView.builder(
                              itemCount: automations.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(automations[index].name),
                                      onTap: () async {
                                        String ?act = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AutomationDetailPage(
                                                    automation:
                                                        automations[index]),
                                          ),
                                        );
                                        if(act != null){
                                          automations = [];
automations = ref.refresh(automationsNotifierProvider);
                                        }
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                );
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewAutomationPage()));
          if (result != null) {
            automations = [];
            automations = ref.refresh(automationsNotifierProvider);
          }
        },
        label: const Text('Aggiungi Automazione'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ottieni il valore dal FutureProvider
    final AsyncValue<String> data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('FutureProvider Example'),
      ),
      body: Center(
        child: data.when(
          // Stato di caricamento
          loading: () => CircularProgressIndicator(),
          // Stato di errore
          error: (e, stack) => Text('Error: $e'),
          // Stato di successo
          data: (value) => Text('Data: $value'),
        ),
      ),
    );
  }
}

void main() {
  runApp(ProviderScope(child: MaterialApp(home: MyWidget())));
}
 */
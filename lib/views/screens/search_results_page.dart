import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';

class MyWidget extends ConsumerWidget {
  final String query = "ciao";
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Device> devices = ref
        .watch(deviceNotifierProvider)
        .where((d) => d.deviceName.contains("c"))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Risultati per $query:"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: devices.length,
          // TODO: implementare card risultato ricerca
          itemBuilder: (context, index) => Container(),
        ),
      ),
    );
  }
}

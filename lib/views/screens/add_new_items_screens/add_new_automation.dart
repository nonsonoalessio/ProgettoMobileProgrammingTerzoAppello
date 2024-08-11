// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';

class AddNewAutomationPage extends ConsumerStatefulWidget {
  const AddNewAutomationPage({super.key});

  @override
  ConsumerState<AddNewAutomationPage> createState() =>
      _AddNewAutomationPageState();
}

class _AddNewAutomationPageState extends ConsumerState<AddNewAutomationPage> {
  @override
  Widget build(BuildContext context) {
    final List<Device> _devices = ref.watch(deviceNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                "Nuova Automazione",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

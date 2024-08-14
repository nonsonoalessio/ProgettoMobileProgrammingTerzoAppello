import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/views/minis.dart';

class AllDevicePage extends StatelessWidget {
  const AllDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Tutti i dispositivi',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ListGenerator(
              predicate: (d) => true,
            ),
          ],
        ),
      ),
    );
  }
}

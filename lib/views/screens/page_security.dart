import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/camera.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/views/minis.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Dispositivi di sicurezza',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ListGenerator(
              predicate: (d) => d is Camera || d is Lock || d is Alarm,
            ),
          ],
        ),
      ),
    );
  }
}

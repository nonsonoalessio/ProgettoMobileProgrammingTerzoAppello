import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progetto_mobile_programming/views/screens/page_all_device.dart';
import 'package:progetto_mobile_programming/views/screens/page_automation.dart';
import 'package:progetto_mobile_programming/views/screens/page_home.dart';
import 'package:progetto_mobile_programming/views/screens/page_security.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      home: const Scaffold(
        body: Navigation(),
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  final List<Widget> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.lock),
      label: 'Sicurezza',
    ),
    const NavigationDestination(
      icon: Icon(Icons.alarm),
      label: 'Automazioni',
    ),
    const NavigationDestination(
      icon: Icon(Icons.list),
      label: 'Dispositivi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const Homepage(),
        const SecurityPage(),
        const AutomationPage(),
        const AllDevicePage(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: _destinations,
        selectedIndex: currentPageIndex,
      ),
    );
  }
}

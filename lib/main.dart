import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/views/homepage.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
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
      icon: Icon(Icons.person),
      label: 'Profile',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const Homepage(),
        const Scaffold(
          body: Center(
            child: Text('Hello World!'),
          ),
        ),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}

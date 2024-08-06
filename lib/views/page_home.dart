// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // _fetchNames;
  }

/*
  Future<void> _fetchNames() async {
    final DatabaseHelper db = DatabaseHelper.instance;
    final List<Map<String, dynamic>> maps =
        await db.database.then((db) => db.query('names'));
    setState(() {
      _names = List.generate(maps.length, (i) {
        return maps[i]['name'] as String;
      });
    });
  }

  Future<void> _addName() async {
    final String nameToAdd = _controller.text;
    final s = StringModel(name: nameToAdd);

    await DatabaseHelper.instance.insertName(s);
    _fetchNames();

    _controller.clear();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                trailing: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                ],
                hintText: 'Cerca un sensore...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class ListGenerator extends StatelessWidget {
  final String roomName;
  final List<String> devices;

  const ListGenerator({super.key, required this.roomName, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(roomName), ListView.builder(scrollDirection: Axis.horizontal,)],
    );
  }
}
*/
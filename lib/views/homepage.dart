import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/string_model.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';

import 'package:progetto_mobile_programming/views/minis.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> _names = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNames;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Immetti nome"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(label: Text('Chip')),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _addName();
                    },
                    child: const Text('Aggiungi al Db'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Rimuovi dal db'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
            const Text(
              'Lista di chips',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _names.length,
                itemBuilder: (context, index) {
                  return Chip(label: Text(_names[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

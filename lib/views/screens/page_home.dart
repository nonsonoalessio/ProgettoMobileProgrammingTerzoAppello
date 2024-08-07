// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/device.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import 'package:progetto_mobile_programming/views/screens/add_new_items_screens/add_new_device.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Device> devices = ref.watch(deviceNotifierProvider);
    final Set<String> rooms = ref.watch(roomsProvider);

    final List<Widget> roomsLists = [];
    for (String room in rooms) {
      roomsLists.add(ListGenerator(
        roomName: room,
        devices: devices.where((d) => d.room == room).toList(),
      ));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewDevicePage(),
            ),
          );
        },
        label: Text(
          'Aggiungi dispositivo',
        ),
        icon: Icon(
          Icons.add,
        ),
        enableFeedback: true,
      ),
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
            Expanded(
              child: ListView(
                children: roomsLists,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListGenerator extends StatelessWidget {
  final String roomName;
  final List<Device> devices;

  const ListGenerator(
      {super.key, required this.roomName, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Text(
              roomName,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          SizedBox(
            height: 200,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              shrinkWrap: false,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(devices.length, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

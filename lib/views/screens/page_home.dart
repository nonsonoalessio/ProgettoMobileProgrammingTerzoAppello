// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';
import 'package:progetto_mobile_programming/views/minis.dart';
import 'package:progetto_mobile_programming/views/screens/add_new_items_screens/add_new_device.dart';
import 'package:progetto_mobile_programming/views/screens/page_all_notification.dart';
import 'package:progetto_mobile_programming/views/screens/page_device_detail.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Device> devices = ref.watch(deviceNotifierProvider);
    final Set<String> rooms = ref.watch(roomsProvider);

    print("Dispositivi: ${devices.length}");
    print("Stanze: ${rooms.length}");

    final List<Widget> roomsLists = [];
    for (String room in rooms) {
      roomsLists.add(ListGenerator(
        roomName: room,
        devices: devices.where((d) => d.room == room).toList(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
              icon: Icon(Icons.notifications))
        ],
        title: SizedBox(
          child: Image.asset(
            scale: 30.0,
            'assets/identity/typography.png',
          ),
        ),
      ),
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
                    child: AvatarForDebugMenu(),
                  ),
                ],
                hintText: 'Cerca un sensore... ',
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
    late Icon deviceIcon;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              roomName,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          SizedBox(
            height: 165,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(devices.length, (index) {
                  if (devices[index] is Lock) {
                    deviceIcon = Icon(Icons.lock, size: 40);
                  } else if (devices[index] is Alarm) {
                    deviceIcon = Icon(Icons.doorbell, size: 40);
                  } else if (devices[index] is Thermostat) {
                    deviceIcon = Icon(Icons.thermostat, size: 40);
                  } else if (devices[index] is Light) {
                    deviceIcon = Icon(Icons.lightbulb, size: 40);
                  } else {
                    deviceIcon = Icon(Icons.camera, size: 40);
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeviceDetailPage(device: devices[index]),
                        ),
                      );
                    },
                    child: Container(
                      width: 150, // Adjust width as needed
                      padding: EdgeInsets.all(8),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 100,
                              child: Center(child: deviceIcon),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(devices[index].deviceName),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class AvatarForDebugMenu extends StatefulWidget {
  const AvatarForDebugMenu({super.key});

  @override
  State<AvatarForDebugMenu> createState() => _AvatarForDebugMenuState();
}

class _AvatarForDebugMenuState extends State<AvatarForDebugMenu> {
  int _clicks = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/mario.jpg'),
      ),
      onLongPress: () {
        setState(() {
          ++_clicks;
        });
        if (_clicks == 2) {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Menù debug",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                          TextButton(
                            onPressed: () {
                              DatabaseHelper.instance.destroyDb();
                            },
                            child: Text("Elimina db"),
                          ),
                          Divider(),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GraphPage()));
                              },
                              child: Text("Componente dummy dei grafici"))
                        ],
                      ),
                    ),
                  ));
          _clicks = 0;
        }
      },
    );
  }
}

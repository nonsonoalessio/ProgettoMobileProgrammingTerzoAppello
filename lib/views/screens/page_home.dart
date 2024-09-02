// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/functionalities/device_notification.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/camera.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import 'package:progetto_mobile_programming/providers/notifications_provider.dart';
import 'package:progetto_mobile_programming/services/database_helper.dart';
import 'package:progetto_mobile_programming/services/localnotification_service.dart';
import 'package:progetto_mobile_programming/views/minis.dart';
import 'package:progetto_mobile_programming/views/screens/add_new_items_screens/add_new_device.dart';
import 'package:progetto_mobile_programming/views/screens/page_all_notification.dart';
import 'package:progetto_mobile_programming/views/screens/page_device_detail.dart';

// Inizializzazione del plugin per le notifiche locali
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All'; //default

  @override
  void initState() {
    super.initState();

    // Aggiorna la UI quando il testo cambia
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Device> devices = ref.watch(deviceNotifierProvider);
    final Set<String> rooms = ref.watch(roomsProvider);

    // Filtra i dispositivi in base alla ricerca e al tipo selezionato
    final filteredDevices = devices.where((device) {
      final matchesSearch = _searchController.text.isEmpty ||
          device.deviceName
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      final matchesType = _selectedType == 'All' ||
          (device is Lock && _selectedType == 'Lock') ||
          (device is Alarm && _selectedType == 'Alarm') ||
          (device is Thermostat && _selectedType == 'Thermostat') ||
          (device is Light && _selectedType == 'Light') ||
          (device is Camera && _selectedType == 'Camera');

      return matchesSearch && matchesType;
    }).toList();

    // Creiamo la lista delle stanze solo se contengono dispositivi filtrati
    final List<Widget> roomsLists = [];
    for (String room in rooms) {
      // Filtra i dispositivi della stanza corrente
      final roomDevices = filteredDevices.where((d) => d.room == room).toList();

      // Aggiungiamo la stanza alla lista solo se contiene dispositivi filtrati
      if (roomDevices.isNotEmpty) {
        roomsLists.add(ListGenerator(
          roomName: room,
          devices: roomDevices,
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            icon: Icon(Icons.notifications),
          ),
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
            MaterialPageRoute(builder: (context) => AddNewDevicePage()),
          );
        },
        label: Text('Aggiungi dispositivo'),
        icon: Icon(Icons.add),
        enableFeedback: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SearchBar(
                    controller: _searchController,
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
                    hintText: 'Cerca un sensore...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      FilterButton(
                        label: 'Lock',
                        isSelected: _selectedType == 'Lock',
                        onTap: () {
                          setState(() {
                            if (_selectedType == 'Lock') {
                              _selectedType = 'All';
                            } else {
                              _selectedType = 'Lock';
                            }
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Alarm',
                        isSelected: _selectedType == 'Alarm',
                        onTap: () {
                          setState(() {
                            if (_selectedType == 'Alarm') {
                              _selectedType = 'All';
                            } else {
                              _selectedType = 'Alarm';
                            }
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Thermostat',
                        isSelected: _selectedType == 'Thermostat',
                        onTap: () {
                          setState(() {
                            if (_selectedType == 'Thermostat') {
                              _selectedType = 'All';
                            } else {
                              _selectedType = 'Thermostat';
                            }
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Light',
                        isSelected: _selectedType == 'Light',
                        onTap: () {
                          setState(() {
                            if (_selectedType == 'Light') {
                              _selectedType = 'All';
                            } else {
                              _selectedType = 'Light';
                            }
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Camera',
                        isSelected: _selectedType == 'Camera',
                        onTap: () {
                          setState(() {
                            if (_selectedType == 'Camera') {
                              _selectedType = 'All';
                            } else {
                              _selectedType = 'Camera';
                            }
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: filteredDevices.isEmpty
                  ? Center(
                      child: Text(
                        'Nessun dispositivo corrispondente alla ricerca.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView(
                      children: [
                        ...roomsLists,
                        SizedBox(
                            height:
                                100), // Aggiungi spazio extra alla fine della lista
                      ],
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

class NotificationButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        String title = 'Titolo';
        String body = 'Testo';

        LocalNoti().showBigTextNotification(
          title: title,
          body: body,
          fln: flutterLocalNotificationsPlugin,
        );
        // Creazione della nuova notifica
        final newNotification = DeviceNotification(
          id: DeviceNotification.generateUniqueId(),
          title: title,
          device: Light(deviceName: 'Luce1', room: 'Salone', id: 0),
          deliveryTime: TimeOfDay.now(),
          isRead: false,
          description: body,
        );
      },
      child: Text("Test notifiche push"),
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
                              child: Text("Componente dummy dei grafici")),
                          Divider(),
                          NotificationButton(),
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

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Widget leading;
  final List<Widget> trailing;
  final String hintText;
  final OutlineInputBorder border;
  const SearchBar({
    super.key,
    required this.controller,
    required this.leading,
    required this.trailing,
    required this.hintText,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: leading,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: trailing,
        ),
        hintText: hintText,
        border: border,
        filled: true,
        fillColor: Colors.grey[200], // Background color of the search bar
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(label),
    );
  }
}

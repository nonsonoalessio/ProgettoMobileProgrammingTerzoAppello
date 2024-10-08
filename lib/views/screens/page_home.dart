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
  HomepageState createState() => HomepageState();
}

class HomepageState extends ConsumerState<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All'; // default

  @override
  void initState() {
    super.initState();
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

    final List<Widget> roomsLists = [];
    for (String room in rooms) {
      final roomDevices = filteredDevices.where((d) => d.room == room).toList();

      if (roomDevices.isNotEmpty) {
        roomsLists.add(ListGenerator(
          roomName: room,
          devices: roomDevices,
          onRemoveRoom: () {
            ref.read(deviceNotifierProvider.notifier).deleteRoom(room);
          },
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
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
            icon: const Icon(Icons.notifications),
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
            MaterialPageRoute(builder: (context) => const AddNewDevicePage()),
          );
        },
        label: const Text('Aggiungi dispositivo'),
        icon: const Icon(Icons.add),
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
                    leading: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search),
                    ),
                    trailing: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
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
                        label: 'Serratura',
                        isSelected: _selectedType == 'Lock',
                        onTap: () {
                          setState(() {
                            _selectedType =
                                _selectedType == 'Lock' ? 'All' : 'Lock';
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Allarme',
                        isSelected: _selectedType == 'Alarm',
                        onTap: () {
                          setState(() {
                            _selectedType =
                                _selectedType == 'Alarm' ? 'All' : 'Alarm';
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Termostato',
                        isSelected: _selectedType == 'Thermostat',
                        onTap: () {
                          setState(() {
                            _selectedType = _selectedType == 'Thermostat'
                                ? 'All'
                                : 'Thermostat';
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Luce',
                        isSelected: _selectedType == 'Light',
                        onTap: () {
                          setState(() {
                            _selectedType =
                                _selectedType == 'Light' ? 'All' : 'Light';
                          });
                        },
                      ),
                      FilterButton(
                        label: 'Camera',
                        isSelected: _selectedType == 'Camera',
                        onTap: () {
                          setState(() {
                            _selectedType =
                                _selectedType == 'Camera' ? 'All' : 'Camera';
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
                  ? const Center(
                      child: Text(
                        'Nessun dispositivo corrispondente alla ricerca.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView(
                      children: [
                        ...roomsLists,
                        const SizedBox(
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
  final VoidCallback onRemoveRoom;

  const ListGenerator({
    super.key,
    required this.roomName,
    required this.devices,
    required this.onRemoveRoom,
  });

  @override
  Widget build(BuildContext context) {
    late Icon deviceIcon;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roomName,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(context),
              ),
            ],
          ),
          SizedBox(
            height: 165,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(devices.length, (index) {
                  if (devices[index] is Lock) {
                    deviceIcon = const Icon(Icons.lock, size: 40);
                  } else if (devices[index] is Alarm) {
                    deviceIcon = const Icon(Icons.doorbell, size: 40);
                  } else if (devices[index] is Thermostat) {
                    deviceIcon = const Icon(Icons.thermostat, size: 40);
                  } else if (devices[index] is Light) {
                    deviceIcon = const Icon(Icons.lightbulb, size: 40);
                  } else {
                    deviceIcon = const Icon(Icons.camera, size: 40);
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
                      padding: const EdgeInsets.all(8),
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
          const Divider(),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma eliminazione'),
          content: const Text(
              'Tutti i dispositivi registrati alla stanza verranno eliminati. Sei sicuro di voler eliminare questa stanza?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialogo
              },
            ),
            TextButton(
              child: const Text('Elimina'),
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialogo
                onRemoveRoom(); // Chiama la funzione di eliminazione della stanza
              },
            ),
          ],
        );
      },
    );
  }
}

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

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
        final newNotification = DeviceNotification(
          id: DeviceNotification.generateUniqueId(),
          title: title,
          device: Light(deviceName: 'Luce1', room: 'Salone', id: 0),
          deliveryTime: TimeOfDay.now(),
          isRead: false,
          description: body,
        );
      },
      child: const Text("Test notifiche push"),
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
      child: const CircleAvatar(
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
                          const Text(
                            "Menù debug",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                          TextButton(
                            onPressed: () {
                              DatabaseHelper.instance.destroyDb();
                            },
                            child: const Text("Elimina db"),
                          ),
                          const Divider(),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GraphPage()));
                              },
                              child:
                                  const Text("Componente dummy dei grafici")),
                          const Divider(),
                          const NotificationButton(),
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
  final InputBorder border;

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
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey.shade300,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }
}

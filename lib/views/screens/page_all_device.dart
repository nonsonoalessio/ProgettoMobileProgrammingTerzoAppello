import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/camera.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:progetto_mobile_programming/providers/devices_provider.dart';
import 'package:progetto_mobile_programming/views/screens/page_device_detail.dart'; 

class AllDevicePage extends ConsumerWidget {
  const AllDevicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final primaryColor = Theme.of(context).primaryColor;

    final List<Device> devices = ref.watch(deviceNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                'Tutti i dispositivi',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),

              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.0, 
                  ),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return GestureDetector(
                      onTap: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DeviceDetailPage(device: device),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getDeviceIcon(device), 
                                size: 40,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                device.deviceName, 
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDeviceIcon(Device device) {
    if (device is Camera) {
      return Icons.videocam;
    } else if (device is Lock) {
      return Icons.lock;
    } else if (device is Alarm) {
      return Icons.alarm;
    } else if (device is Light) {
      return Icons.lightbulb; 
    } else if (device is Thermostat) {
      return Icons.thermostat; 
    }
    return Icons.device_unknown; 
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/functionalities/action.dart';
import 'package:progetto_mobile_programming/models/functionalities/alarm_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/automation.dart';
import 'package:progetto_mobile_programming/models/functionalities/light_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/lock_action.dart';
import 'package:progetto_mobile_programming/models/functionalities/thermostat_action.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/camera.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/functionalities/device_notification.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  List<Device> devices = [];
  List<Automation> automations = [];
  List<DeviceNotification> notifications = [];
  Set<String> notificationCategories = {};

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'mio_database.db'),
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE IF NOT EXISTS rooms (
              room TEXT PRIMARY KEY
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS device (
              id INTEGER PRIMARY KEY ,
              room TEXT NOT NULL,
              deviceName TEXT NOT NULL,
              FOREIGN KEY (room) REFERENCES rooms(room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS camera (
              id INTEGER PRIMARY KEY,
              video TEXT NOT NULL,
              FOREIGN KEY (id) REFERENCES device(id)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS alarms (
              id INTEGER PRIMARY KEY,
              isActive BOOLEAN,
              FOREIGN KEY (id) REFERENCES device(id)
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS locks (
              id INTEGER PRIMARY KEY,
              isActive BOOLEAN,
              FOREIGN KEY (id) REFERENCES device(id)
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS lights (
              id INTEGER PRIMARY KEY,
              lightTemperature INTEGER NOT NULL,
              isActive BOOLEAN,
              FOREIGN KEY (id) REFERENCES device(id)
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS thermostats (
              id INTEGER PRIMARY KEY,
              currentTemp REAL NOT NULL,
              desiredTemp REAL NOT NULL,
              FOREIGN KEY (id) REFERENCES device(id)
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS automation (
              name TEXT PRIMARY KEY,
              executionTime TIME,
              weather TEXT
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS deviceNotification(
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL,
              device INTEGER NOT NULL,
              deliveryTime TIME NOT NULL,
              isRead BOOLEAN NOT NULL,
              description TEXT NOT NULL,
              FOREIGN KEY (device) REFERENCES Device(id)
              )
              """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS categoryNotification(
              category TEXT NOT NULL,
              deviceNotifications INTEGER NOT NULL,
              FOREIGN KEY (category) references categoryNotification(name),
              FOREIGN KEY (deviceNotifications) references deviceNotification(id),
              PRIMARY KEY(category, deviceNotifications)
              )
              """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS category(
              name TEXT PRIMARY KEY
              )
              """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS actions (
              idDevice INTEGER NOT NULL,
              automationName TEXT NOT NULL,
              type TEXT NOT NULL,
              azione TEXT NOT NULL,
              temperatura REAL,
              FOREIGN KEY (idDevice) REFERENCES device(id),
              FOREIGN KEY (automationName) REFERENCES automation(name),
              PRIMARY KEY(idDevice, automationName, azione)
          )
          """);

        // Insert initial data
        await db.execute("""
          INSERT INTO rooms (room) 
          VALUES
          ('Cucina'),
          ('Salotto'),
          ('Cameretta')
          """);

        await db.execute("""
          INSERT INTO device (id, room, deviceName) 
          VALUES
          (1, 'Salotto', 'Allarme ingresso'),
          (3, 'Cameretta', 'Allarme barriera'),
          (2, 'Salotto', 'Serratura1'),
          (4, 'Cucina', 'Serratura2'),
          (5, 'Cameretta', 'Luce di Simone'),
          (7, 'Cameretta', 'Luce di Mario'),
          (6, 'Salotto', 'Termostato1'),
          (8, 'Cucina', 'Termostato2'),
          (9, 'Salotto', 'Camera1'),
          (10, 'Cameretta', 'Camera2')
          """);
        await db.execute("""
          INSERT INTO camera (id,video)
          VALUES
          (9, 'linkvideo1'),
          (10, 'linkvideo2')
          """);
        await db.execute("""
          INSERT INTO alarms (id, isActive) 
          VALUES
          (1, True),
          (3, False)
          """);

        await db.execute("""
          INSERT INTO locks (id, isActive) 
          VALUES 
          (2, True),
          (4, False)
          """);

        await db.execute("""
          INSERT INTO lights (id, lightTemperature, isActive)
          VALUES
          (5, 3000, 1),
          (7, 4000, 0)
          """);

        await db.execute("""
          INSERT INTO thermostats (id, currentTemp, desiredTemp)
          VALUES
          (6, 20.0, 22.0),
          (8, 18.0, 20.0)
          """);

        await db.execute("""
          INSERT INTO automation (name, executionTime)
           VALUES
            ('Automazione serale', '18:00:00')
          """);

        await db.execute("""
          INSERT INTO actions (idDevice, automationName, type, azione)
           VALUES
            (5, 'Automazione serale', 'light', 'turnOn')
          """);
        await db.execute("""
          INSERT INTO category(name)
          VALUES
          ('Sicurezza'),
          ('Esecuzione automazione'),
          ('Alti consumi')
          """);
        await db.execute("""
          INSERT INTO deviceNotification (id, title, device, deliveryTime, isRead, description)
           VALUES
            (1, 'Mario guarda gatto', 9, '19:00:00', 0, 'mario'),
            (2, 'Mario guarda gatti', 10, '09:00:00', 1, 'mario'),
            (3, 'Mario guarda gatti', 10, '02:00:00', 1, 'mario')
        """);
        await db.execute("""
          INSERT INTO categoryNotification(category, deviceNotifications)
          VALUES
          ('Sicurezza', 1),
          ('Esecuzione automazione', 2),
          ('Alti consumi', 3)
        """);
      },
      version: 1,
    );
  }

  Future<void> _fetchActions(String automationName, actions) async {
    final db = await database;

    final List<Map<String, dynamic>> mapsOfActions = await db.query('actions');

/*
- idDevice (id dispositivo)
- automationName (nome automazione)
- azione
- temperatura
- onOff
 */
    actions = List.generate(mapsOfActions.length, (i) {
      Device d = devices
          .where((d) => d.id == mapsOfActions[i]['idDevice'])
          .toList()
          .first;
      if (mapsOfActions[i]['type'] == 'light') {
        int colorTemp = 0;
        LightsActions action;

        if (mapsOfActions[i]['azione'] == 'setColorTemp') {
          action = LightsActions.setColorTemp;
          colorTemp = mapsOfActions[i]['temperatura'] as int;
        } else if (mapsOfActions[i]['azione'] == 'turnOn') {
          action = LightsActions.turnOn;
        } else {
          action = LightsActions.turnOff;
        }
        colorTemp == 0
            ? LightAction(device: d, action: action)
            : LightAction(
                device: d, action: action, colorTemperature: colorTemp);
      } else if (mapsOfActions[i]['type'] == 'alarm') {
        AlarmsActions action;
        if (mapsOfActions[i]['azione'] == 'turnOn') {
          action = AlarmsActions.turnOn;
        } else {
          action = AlarmsActions.turnOff;
        }
        return AlarmAction(device: d, action: action);
      } else if (mapsOfActions[i]['type'] == 'lock') {
        LocksActions action;
        if (mapsOfActions[i]['azione'] == 'activate') {
          action = LocksActions.activate;
        } else {
          action = LocksActions.deactivate;
        }
        return LockAction(device: d, action: action);
      } else {
        return ThermostatAction(
            device: d,
            action: ThermostatsActions.setDesiredTemperature,
            desiredTemp: mapsOfActions[i]['temperatura'] as double);
      }
    });
  }

  List<DeviceAction> _getActions(String automationName) {
    List<DeviceAction> actions = [];
    _fetchActions(automationName, actions);
    return actions;
  }

  Future<void> fetchAutomations() async {
    final db = await database;

    final List<Map<String, dynamic>> mapsOfAutomations =
        await db.query('automation');

    automations = List.generate(mapsOfAutomations.length, (i) {
      return Automation(
        name: mapsOfAutomations[i]['name'],
        // ignore: prefer_interpolation_to_compose_strings
        executionTime: TimeOfDay.fromDateTime(DateTime.parse(
            // ignore: prefer_interpolation_to_compose_strings
            '1970-01-01 ' + mapsOfAutomations[i]['executionTime'])),
        weather: mapsOfAutomations[i]['weather'],
        actions: _getActions(mapsOfAutomations[i]['name']),
      );
    });
    automations = [...automations];
  }

  Future<void> fetchNotifications() async {
    final db = await database;

    // Fetch all notifications
    final List<Map<String, dynamic>> mapsOfNotifications = await db.rawQuery("""
    SELECT * FROM deviceNotification
  """);

    notifications =
        await Future.wait(mapsOfNotifications.map((notificationMap) async {
      // Get device associated with the notification
      final deviceId = notificationMap['device'] as int;
      final device = devices.firstWhere((d) => d.id == deviceId);

      // Fetch categories for the notification
      final List<Map<String, dynamic>> mapsOfCategories = await db.rawQuery("""
      SELECT category FROM categoryNotification
      WHERE deviceNotifications = ?
    """, [notificationMap['id']]);

      // Extract categories into a set
      final Set<String> categories = mapsOfCategories
          .map((categoryMap) => categoryMap['category'] as String)
          .toSet();

      // Create the DeviceNotification object
      return DeviceNotification(
        id: notificationMap['id'] as int,
        title: notificationMap['title'] as String,
        device: device,
        deliveryTime: TimeOfDay.fromDateTime(
            DateTime.parse('1970-01-01 ${notificationMap['deliveryTime']}')),
        isRead: notificationMap['isRead'] == 1,
        description: notificationMap['description'] as String,
        categories: categories,
      );
    }));

    // Notify listeners or update UI
    notifications = [...notifications];
  }

  Future<void> fetchNotificationCategories() async {
    final db = await database;

    final List<Map<String, dynamic>> mapsOfCategories =
        await db.query('category');
    notificationCategories = List.generate(mapsOfCategories.length, (i) {
      return mapsOfCategories[i]['name'] as String;
    }).toSet();
  }

/* GUARDA METODO DEFINITO IN BASSO
  Future<void> insertNotificationCategories(Notification notification, Set<String> categories) async {
    final db = await database;

    // insert in Category - solo nome
    
    for(String s in categories){
      if(!notificationCategories.contains(s)){
        await db.insert(...);
      }
    }

    // insert in TabellaAssociazione
    for(String s in categories){
    // id notifica: notification.id - se serve cast a String: ${notification.id.toString()}
    await db.insert(...); 
    }
  }
 */

  Future<void> fetchDevices() async {
    final db = await database;

    print("Connessione al database avvenuta con successo.");

    final List<Map<String, dynamic>> mapsOfAlarms = await db.rawQuery("""
      SELECT a.id, d.deviceName, d.room, a.isActive
      FROM device d 
      JOIN alarms a ON d.id = a.id
    """);

    final List<Map<String, dynamic>> mapsOfLocks = await db.rawQuery("""
      SELECT l.id, d.deviceName, d.room, l.isActive 
      FROM device d 
      JOIN locks l ON d.id = l.id
    """);

    final List<Map<String, dynamic>> mapsOfLights = await db.rawQuery("""
      SELECT l.id, d.deviceName, d.room, l.lightTemperature, l.isActive
      FROM device d 
      JOIN lights l ON d.id = l.id
    """);

    final List<Map<String, dynamic>> mapsOfthermostats = await db.rawQuery("""
      SELECT t.id, d.deviceName, d.room, t.currentTemp, t.desiredTemp 
      FROM device d 
      JOIN thermostats t ON d.id = t.id
    """);

    final List<Map<String, dynamic>> mapsOfCameras = await db.rawQuery("""
      SELECT c.id, d.deviceName, d.room, c.video
      FROM device d 
      JOIN camera c ON d.id = c.id
    """);

    final alarms = List.generate(mapsOfAlarms.length, (i) {
      return Alarm(
        id: mapsOfAlarms[i]['id'] as int,
        deviceName: mapsOfAlarms[i]['deviceName'] as String,
        room: mapsOfAlarms[i]['room'] as String,
        isActive: mapsOfAlarms[i]['isActive'] == 1 ? true : false,
      );
    });

    final locks = List.generate(mapsOfLocks.length, (i) {
      return Lock(
        id: mapsOfLocks[i]['id'] as int,
        deviceName: mapsOfLocks[i]['deviceName'] as String,
        room: mapsOfLocks[i]['room'] as String,
        isActive: mapsOfLocks[i]['isActive'] == 1 ? true : false,
      );
    });

    final lights = List.generate(mapsOfLights.length, (i) {
      return Light(
          id: mapsOfLights[i]['id'] as int,
          deviceName: mapsOfLights[i]['deviceName'] as String,
          room: mapsOfLights[i]['room'] as String,
          lightTemperature: mapsOfLights[i]['lightTemperature'] as int,
          isActive: mapsOfLights[i]['isActive'] == 1 ? true : false);
    });

    final thermostats = List.generate(mapsOfthermostats.length, (i) {
      return Thermostat(
        id: mapsOfthermostats[i]['id'] as int,
        deviceName: mapsOfthermostats[i]['deviceName'] as String,
        room: mapsOfthermostats[i]['room'] as String,
        desiredTemp: mapsOfthermostats[i]['desiredTemp'] as double,
        detectedTemp: mapsOfthermostats[i]['currentTemp'] as double,
      );
    });

    final cameras = List.generate(mapsOfCameras.length, (i) {
      return Camera(
        id: mapsOfCameras[i]['id'] as int,
        deviceName: mapsOfCameras[i]['deviceName'] as String,
        room: mapsOfCameras[i]['room'] as String,
        video: mapsOfCameras[i]['video'],
      );
    });

    devices = [...alarms, ...locks, ...lights, ...thermostats, ...cameras];
  }

  Future<void> insertRoom(String roomName) async {
    final db = await database;
    await db.insert(
      'rooms',
      {'room': roomName},
    );
  }

  String _getTableName(Device device) {
    if (device is Alarm) return 'alarms';
    if (device is Lock) return 'locks';
    if (device is Light) return 'lights';
    if (device is Thermostat) return 'thermostats';
    if (device is Camera) return 'camera';
    throw Exception('Device non supportato.');
  }

  Future<void> insertDevice(Device device) async {
    final tableName = _getTableName(device);

    final db = await database;

    await db.transaction((txn) async {
      // Inserimento nella tabella 'device'
      await txn.insert(
        'device',
        {
          'deviceName': device.deviceName,
          'room': device.room,
          'id': device.id,
        },
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Gestisce i conflitti se il dispositivo esiste già
      );

      // Inserimento nella tabella specifica per il tipo di dispositivo
      await txn.insert(
        tableName,
        device.toMap(),
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Gestisce i conflitti se il dispositivo esiste già
      );
    });
  }

  Future<void> insertAutomation(Automation automation) async {
    final db = await database;

    await db.transaction((txn) async {
      // Inserisci i dati nella tabella automation
      await txn.insert(
        'automation',
        {
          'name': automation.name,
          'executionTime': automation.executionTime,
          'weather': automation.weather,
        },
      );

      // Inserisci le azioni nella tabella actions
      for (final action in automation.actions) {
        Map<String, dynamic> map = action.toMap();
        map['automationName'] = automation.name;
        await txn.insert(
          'actions',
          map,
        );
      }
    });
  }

  Future<void> insertNotification(DeviceNotification notification) async {
    final isReadInt;
    if (notification.isRead) {
      isReadInt = 1;
    } else
      isReadInt = 0;

    final db = await database;
    final String deliveryTimeString =
        '${notification.deliveryTime.hour.toString().padLeft(2, '0')}:${notification.deliveryTime.minute.toString().padLeft(2, '0')}';
    await db.insert(
      'deviceNotification',
      {
        'id': DeviceNotification.generateUniqueId(),
        'title': notification.title,
        'device': notification.device.id,
        'deliveryTime': deliveryTimeString,
        'isRead': isReadInt,
        'description': notification.description,
      },
    );

    if (notification.categories.isNotEmpty) {
      await db.transaction((txn) async {
        for (String category in notification.categories) {
          await txn.insert(
            'categoryNotification',
            {'category': category, 'deviceNotifications': notification.id},
          );
        }
      });
    }
  }

  Future<void> insertCategory(String category) async {
    final db = await database;
    await db.insert(
      'category',
      {
        'name': category,
      },
    );
  }

  // DA CAPIRE COME LA VUOLE ALESSIO TODO
  Future<void> insertNotificationCategories(
      DeviceNotification devNot, List<String> categories) async {
    final db = await database;

    // Utilizziamo una transazione per garantire che tutte le operazioni di inserimento siano atomiche.
    await db.transaction((txn) async {
      for (String category in categories) {
        await txn.insert(
          'categoryNotification',
          {'category': category, 'deviceNotifications': devNot.id},
        );
      }
    });
  }

  Future<void> updateRoom(String oldRoomName, String newRoomName) async {
    final db = await database;

    await db.update(
      'rooms',
      {'room': newRoomName},
      where: 'room = ?',
      whereArgs: [oldRoomName],
    );
  }

  Future<void> updateDevice(Device device) async {
    final db = await database;

    // Aggiorna la tabella
    await db.update(
      'device',
      {
        'deviceName': device.deviceName,
        'room': device.room,
      },
      where: 'id = ?',
      whereArgs: [device.id],
    );

    // Aggiorna la tabella specifica basandosi sul tipo
    if (device is Alarm) {
      final int isActiveInt;
      if (device.isActive) {
        isActiveInt = 1;
      } else
        isActiveInt = 0;
      await db.update(
        'alarms',
        {
          'isActive': isActiveInt,
        },
        where: 'id = ?',
        whereArgs: [device.id],
      );
    } else if (device is Lock) {
      final int isActiveInt;
      if (device.isActive) {
        isActiveInt = 1;
      } else
        isActiveInt = 0;
      await db.update(
        'locks',
        {
          'isActive': isActiveInt,
        },
        where: 'id = ?',
        whereArgs: [device.id],
      );
    } else if (device is Light) {
      final int isActiveInt;
      if (device.isActive) {
        isActiveInt = 1;
      } else
        isActiveInt = 0;
      await db.update(
        'lights',
        {
          'lightTemperature': device.lightTemperature,
          'isActive': isActiveInt,
        },
        where: 'id = ?',
        whereArgs: [device.id],
      );
    } else if (device is Thermostat) {
      await db.update(
        'thermostats',
        {
          'desiredTemp': device.desiredTemp,
        },
        where: 'id = ?',
        whereArgs: [device.id],
      );
    } else if (device is Camera) {
      await db.update(
        'camera',
        {
          'video': device.video,
        },
        where: 'id = ?',
        whereArgs: [device.id],
      );
    } else {
      throw Exception("Unsupported device type");
    }
  }

  Future<void> updateAutomation(Automation automation) async {
    final db = await database;

    await db.transaction((txn) async {
      // 1. Aggiorniamo i dati nella tabella automation
      await txn.update(
        'automation',
        {
          'name': automation.name,
          'executionTime': automation.executionTime,
          'weather': automation.weather,
        },
        where: 'name = ?',
        whereArgs: [automation.name],
      );

      // 2. Rimuoviamo le azioni esistenti per questa automazione
      await txn.delete(
        'actions',
        where: 'automationName = ?',
        whereArgs: [automation.name],
      );

      // 3. Inseriamo o aggiorna le azioni nella tabella actions
      for (final action in automation.actions) {
        Map<String, dynamic> map = action.toMap();
        map['automationName'] = automation.name;

        await txn.insert(
          'actions',
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> updateNotification(int id) async {
    final db = await database;

    // Modifichiamo solo il campo isRead
    await db.update(
      'deviceNotification',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCategory(
      String oldCategoryName, String newCategoryName) async {
    final db = await database;

    // Aggiorniamo il nome della categoria nella tabella 'category'
    await db.update(
      'category',
      {'name': newCategoryName},
      where: 'name = ?',
      whereArgs: [oldCategoryName],
    );

    // Aggiorniamo anche le associazioni di categoria nella tabella 'categoryNotification'
    await db.update(
      'categoryNotification',
      {'category': newCategoryName},
      where: 'category = ?',
      whereArgs: [oldCategoryName],
    );
  }

  Future<void> updateCategoryNotification(
      int deviceNotificationId, List<String> newCategories) async {
    final db = await database;

    // Avvio di una transazione per garantire che tutte le operazioni siano atomiche
    await db.transaction((txn) async {
      // Step 1: Rimuoviamo tutte le categorie associate alla notifica
      await txn.delete(
        'categoryNotification',
        where: 'deviceNotifications = ?',
        whereArgs: [deviceNotificationId],
      );

      // Step 2: Inseriamo le nuove categorie per la notifica
      for (String category in newCategories) {
        await txn.insert(
          'categoryNotification',
          {'deviceNotifications': deviceNotificationId, 'category': category},
        );
      }
    });
  }

  Future<void> removeDevice(Device device) async {
    final db = await database;

    // Determina il nome della tabella specifica del dispositivo
    String tableName;
    if (device is Alarm) {
      tableName = 'alarms';
    } else if (device is Lock) {
      tableName = 'locks';
    } else if (device is Light) {
      tableName = 'lights';
    } else if (device is Thermostat) {
      tableName = 'thermostats';
    } else if (device is Camera) {
      tableName = 'camera';
    } else {
      throw Exception("Tipo di dispositivo non supportato");
    }

    // Rimuovi il dispositivo dalla tabella specifica
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [device.id],
    );

    // Rimuovi il dispositivo dalla tabella generale 'device'
    await db.delete(
      'device',
      where: 'id = ?',
      whereArgs: [device.id],
    );
  }

  Future<void> removeAutomation(String automationName) async {
    final db = await database;

    // Rimuoviamo tutte le azioni associate all'automazione
    await db.delete(
      'actions',
      where: 'automationName = ?',
      whereArgs: [automationName],
    );

    // Rimuoviamo l'automazione dalla tabella 'automation'
    await db.delete(
      'automation',
      where: 'name = ?',
      whereArgs: [automationName],
    );
  }

  Future<void> removeNotification(int id) async {
    final db = await database;

    // Rimuovi la notifica dalla tabella 'deviceNotification'
    await db.delete(
      'deviceNotification',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> removeRoom(String roomName) async {
    final db = await database;

    // Rimuovi i dispositivi associati alla stanza dalla tabella 'device'
    await db.delete(
      'device',
      where: 'room = ?',
      whereArgs: [roomName],
    );

    // Rimuovi la stanza dalla tabella 'rooms'
    await db.delete(
      'rooms',
      where: 'room = ?',
      whereArgs: [roomName],
    );
  }

  Future<void> removeCategory(String categoryName) async {
    final db = await database;

    // Rimuoviamo tutte le associazioni con la categoria dalla tabella 'categoryNotification'
    await db.delete(
      'categoryNotification',
      where: 'category = ?',
      whereArgs: [categoryName],
    );

    // Rimuoviamo la categoria dalla tabella 'category'
    await db.delete(
      'category',
      where: 'name = ?',
      whereArgs: [categoryName],
    );
  }

  Future<void> removeCategoryNotification(
      int deviceNotificationId, String category) async {
    final db = await database;

    // Rimuoviamo una specifica associazione dalla tabella 'categoryNotification'
    await db.delete(
      'categoryNotification',
      where: 'category = ? AND deviceNotifications = ?',
      whereArgs: [category, deviceNotificationId],
    );
  }

  Future<void> destroyDb() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'mio_database.db');
    await deleteDatabase(dbPath);
    exit(0);
  }
}

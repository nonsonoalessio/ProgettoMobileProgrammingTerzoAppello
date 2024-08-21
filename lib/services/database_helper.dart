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
              type TEXT NOT NULL,
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
              type TEXT NOT NULL,
              deliveryTime INTEGER NOT NULL,
              isRead BOOLEAN NOT NULL,
              description TEXT NOT NULL,
              FOREIGN KEY (device) REFERENCES Device(id)
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
          INSERT INTO device (id, room, deviceName, type) 
          VALUES
          (1, 'Salotto', 'Allarme ingresso', 'allarme'),
          (3, 'Cameretta', 'Allarme barriera', 'allarme'),
          (2, 'Salotto', 'Lock1', 'locks'),
          (4, 'Cucina', 'Lock2', 'locks'),
          (5, 'Cameretta', 'Luce di Simone', 'lights'),
          (7, 'Cameretta', 'Luce di Mario', 'lights'),
          (6, 'Salotto', 'Thermo1', 'thermostats'),
          (8, 'Cucina', 'Thermo2', 'thermostats'),
          (9, 'Salotto', 'Camera1', 'camera'),
          (10, 'Cameretta', 'Camera2', 'camera')
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
          (5, 27, True),
          (7, 30, False)
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
            '1970-01-01 ' + mapsOfAutomations[i]['executionTime'])),
        weather: mapsOfAutomations[i]['weather'],
        actions: _getActions(mapsOfAutomations[i]['name']),
      );
    });
    automations = [...automations];
  }

  Future<void> fetchNotifications() async {
    final db = await database;

    final List<Map<String, dynamic>> mapsOfNotifications =
        await db.query('deviceNotification');

    notifications = List.generate(mapsOfNotifications.length, (i) {
      return DeviceNotification(
          id: DeviceNotification.generateUniqueId(),
          title: mapsOfNotifications[i]['title'],
          device: mapsOfNotifications[i]['device'],
          type: mapsOfNotifications[i]['type'],
          deliveryTime: mapsOfNotifications[i]['deliveryTime'],
          isRead: mapsOfNotifications[i]['isRead'],
          description: mapsOfNotifications[i]['description']);
    });
    notifications = [
      ...notifications,
    ];
  }

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

    final cameras = List.generate(mapsOfthermostats.length, (i) {
      return Camera(
        id: mapsOfCameras[i]['id'] as int,
        deviceName: mapsOfCameras[i]['deviceName'] as String,
        room: mapsOfCameras[i]['room'] as String,
        video: mapsOfCameras[i]['video'],
      );
    });

    devices = [...alarms, ...locks, ...lights, ...thermostats, ...cameras];
  }

  Future<void> insertDevice(Device device) async {
    final String tableName;
    if (device is Alarm) {
      tableName = 'alarms';
    } else if (device is Lock) {
      tableName = 'locks';
    } else if (device is Light) {
      tableName = 'lights';
    } else if (device is Thermostat) {
      tableName = 'thermostats';
    } else {
      tableName = 'camera';
    }

    final db = await database;
    await db.insert(
      'device',
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      tableName,
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<void> destroyDb() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'mio_database.db');
    await deleteDatabase(dbPath);
    exit(0);
  }
}

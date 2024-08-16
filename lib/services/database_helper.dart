import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progetto_mobile_programming/models/objects/alarm.dart';
import 'package:progetto_mobile_programming/models/objects/device.dart';
import 'package:progetto_mobile_programming/models/objects/light.dart';
import 'package:progetto_mobile_programming/models/objects/lock.dart';
import 'package:progetto_mobile_programming/models/objects/thermostat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  List<Device> devices = [];
  //  List<Automation> automations = [];
  //  List<Notification> notifications = [];
  int lastIndexForId = 0;

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
              nameRoom TEXT NOT NULL,
              deviceName TEXT NOT NULL,
              type TEXT NOT NULL,
              FOREIGN KEY (nameRoom) REFERENCES rooms(room)
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
              startTime TIME NOT NULL
          )
          """);

        await db.execute("""
          CREATE TABLE IF NOT EXISTS gestioneAutomazione (
              id INTEGER NOT NULL,
              name TEXT NOT NULL,
              FOREIGN KEY (id) REFERENCES device(id),
              FOREIGN KEY (name) REFERENCES automation(name),
              PRIMARY KEY(id, name)
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
          INSERT INTO device (id, nameRoom, deviceName, type) 
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
          INSERT INTO automation (name, startTime)
           VALUES
            ('Automazione mattutina', '06:00:00'),
            ('Automazione serale', '18:00:00')
          """);

        await db.execute("""
          INSERT INTO gestioneAutomazione (id, name)
           VALUES
            (6, 'Automazione mattutina'),
            (8, 'Automazione serale')
          """);
      },
      version: 1,
    );
  }

/*
TODO: Future<void> fetchAutomations() async {
  automations = List.generate(mapsOfAutomations.length, (i){
    return Automation(...);
  })
}
*/

/*
TODO: Future<void> fetchNotifications() async {
  notifications = List.generate(mapsOfNotifications.length, (i){
    return Notification(...);
  })
}
*/

/*
TODO: Future<void> fetchIndex() async {
  // lastIndexForId = ??
}
*/

  Future<void> fetchDevices() async {
    final db = await database;

    final List<Map<String, dynamic>> mapsOfAlarms = await db.rawQuery("""
      SELECT a.id, d.deviceName, d.nameRoom, a.isActive
      FROM device d 
      JOIN alarms a ON d.id = a.id
    """);

    final List<Map<String, dynamic>> mapsOfLocks = await db.rawQuery("""
      SELECT l.id, d.deviceName, d.nameRoom, l.isActive 
      FROM device d 
      JOIN locks l ON d.id = l.id
    """);

    final List<Map<String, dynamic>> mapsOfLights = await db.rawQuery("""
      SELECT l.id, d.deviceName, d.nameRoom, l.lightTemperature, l.isActive
      FROM device d 
      JOIN lights l ON d.id = l.id
    """);

    final List<Map<String, dynamic>> mapsOfthermostats = await db.rawQuery("""
      SELECT t.id, d.deviceName, d.nameRoom, t.currentTemp, t.desiredTemp 
      FROM device d 
      JOIN thermostats t ON d.id = t.id
    """);

    final alarms = List.generate(mapsOfAlarms.length, (i) {
      return Alarm(
        id: mapsOfAlarms[i]['id'] as int,
        deviceName: mapsOfAlarms[i]['deviceName'] as String,
        room: mapsOfAlarms[i]['nameRoom'] as String,
        isActive: mapsOfAlarms[i]['isActive'] == 1 ? true : false,
      );
    });

    final locks = List.generate(mapsOfLocks.length, (i) {
      return Lock(
        id: mapsOfLocks[i]['id'] as int,
        deviceName: mapsOfLocks[i]['deviceName'] as String,
        room: mapsOfLocks[i]['nameRoom'] as String,
        isActive: mapsOfLocks[i]['isActive'] == 1 ? true : false,
      );
    });

    final lights = List.generate(mapsOfLights.length, (i) {
      return Light(
          id: mapsOfLights[i]['id'] as int,
          deviceName: mapsOfLights[i]['deviceName'] as String,
          room: mapsOfLights[i]['nameRoom'] as String,
          lightTemperature: mapsOfLights[i]['lightTemperature'] as int,
          isActive: mapsOfLights[i]['isActive'] == 1 ? true : false);
    });

    final thermostats = List.generate(mapsOfthermostats.length, (i) {
      return Thermostat(
        id: mapsOfthermostats[i]['id'] as int,
        deviceName: mapsOfthermostats[i]['deviceName'] as String,
        room: mapsOfthermostats[i]['nameRoom'] as String,
        desiredTemp: mapsOfthermostats[i]['desiredTemp'] as double,
        detectedTemp: mapsOfthermostats[i]['currentTemp'] as double,
      );
    });

    devices = [...alarms, ...locks, ...lights, ...thermostats];
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
      // ramo else fittizio per evitare errori di compilazione; nessun dispositivo verrà mai aggiunto e non serve creare la tabella
      tableName = 'devices';
    }

    final db = await database;
    await db.insert(
      tableName,
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeDevice(Device device) async {
    String tableName;
    if (device is Alarm) {
      tableName = 'alarms';
    } else if (device is Lock) {
      tableName = 'locks';
    } else if (device is Light) {
      tableName = 'lights';
    } else if (device is Thermostat) {
      tableName = 'thermostats';
    } else {
      // ramo else fittizio per evitare errori di compilazione; nessun dispositivo verrà mai aggiunto e non serve creare la tabella
      tableName = 'devices';
    }
  }

  Future<void> destroyDb() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'mio_database.db');
    await deleteDatabase(dbPath);
    exit(0);
  }
}

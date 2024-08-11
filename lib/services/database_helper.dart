import 'dart:io';

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

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'mio_database.db'),
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE IF NOT EXISTS rooms (
              nameRoom text PRIMARY KEY
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS device (
              idDevice INTEGER NOT NULL,
              nameRoom TEXT NOT NULL,
              deviceName TEXT NOT NULL,
              type TEXT NOT NULL,
              isActive Boolean NOT NULL,
              FOREIGN KEY (nameRoom) REFERENCES rooms(nameRoom),
              PRIMARY KEY(idDevice, nameRoom)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS alarms (
              idAlarm INTEGER PRIMARY KEY,
              FOREIGN KEY (idAlarm) REFERENCES device(idDevice)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS locks (
              idLocks INTEGER PRIMARY KEY,
              FOREIGN KEY (idLocks) REFERENCES device(idDevice)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS lights (
              idLights INTEGER PRIMARY KEY,
              lightTemperature INTEGER NOT NULL,
              FOREIGN KEY (idLights) REFERENCES device(idDevice)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS thermostats (
              idThermostats INTEGER PRIMARY KEY,
              currentTemp REAL NOT NULL,
              desiredTemp REAL NOT NULL,
              FOREIGN KEY (idThermostats) REFERENCES device(idDevice)
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
            idDevice INTEGER NOT NULL,
            name TEXT NOT NULL,
            FOREIGN KEY (idDevice) REFERENCES device(idDevice),
            FOREIGN KEY (name) REFERENCES automation(name),
            PRIMARY KEY(idDevice, name)
          )
          """);
        await db.execute("""
          INSERT INTO rooms (nameRoom) 
          VALUES
          ('Cucina'),
          ('Salotto'),
          ('Cameretta')
          """);
        await db.execute("""
          INSERT INTO device (idDevice, nameRoom, deviceName, type, isActive) 
          VALUES
          (1, 'Salotto', 'Allarme ingresso', 'allarme', True),
          (3, 'Cameretta', 'Allarme barriera', 'allarme', False),
          (2, 'Salotto', 'Lock1', 'locks', True),
          (4, 'Cucina', 'Lock2','locks', False),
          (5, 'Cameretta', 'luce di Simnone', 'lights', True),
          (7, 'Cameretta', 'luce di Mario', 'lights', False),
          (6, 'Salotto', 'Thermo1', 'thermostats', True),
          (8, 'Cucina', 'Thermo2', 'thermostats', False)
          """);
        await db.execute("""
          INSERT INTO alarms (idAlarm) 
          VALUES
          (1),
          (3)
          """);
        await db.execute("""
          INSERT INTO locks (idLocks) 
          VALUES 
          (2),
          (4)
          """);
        await db.execute("""
          INSERT INTO lights (idLights, lightTemperature)
          VALUES
          (5, 27.0),
          (7, 30.5)
          """);
        await db.execute("""
          INSERT INTO thermostats (idThermostats, currentTempo, desiredTemp)
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
          INSERT INTO gestioneAutomazione (idDevice, name)
           VALUES
            (6, 'Automazione mattutina'),
            (8, 'Automazione serale')
          """);
      },
      version: 1,
    );
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

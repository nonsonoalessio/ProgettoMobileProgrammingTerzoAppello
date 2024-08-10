import 'dart:io';

import 'package:progetto_mobile_programming/models/alarm.dart';
import 'package:progetto_mobile_programming/models/device.dart';
import 'package:progetto_mobile_programming/models/light.dart';
import 'package:progetto_mobile_programming/models/lock.dart';
import 'package:progetto_mobile_programming/models/thermostat.dart';
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
          CREATE TABLE IF NOT EXISTS alarms (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              isActive BOOLEAN NOT NULL,
              FOREIGN KEY(room) REFERENCES rooms(nameRoom),
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS locks (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              isActive BOOLEAN NOT NULL,
              FOREIGN KEY(room) REFERENCES rooms(nameRoom),
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS lights (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              isActive BOOLEAN NOT NULL,
              lightTemperature INTEGER NOT NULL,
              FOREIGN KEY(room) REFERENCES rooms(nameRoom),
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS thermostats (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              currentTemp REAL NOT NULL,
              desiredTemp REAL NOT NULL,
              FOREIGN KEY(room) REFERENCES rooms(nameRoom),
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS automation (
            idAutomation INTEGER NOT NULL,
            name TEXT NOT NULL,
            startTime TIME NOT NULL, 
            endTime TIME NOT NULL,
            isActive BOOLEAN DEFAULT FALSE
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
          INSERT INTO alarms (deviceName, room, isActive) 
          VALUES
          ('Allarme Ingresso', 'Salotto', 1),
          ('Allarme Barriera', 'Cameretta', 0)
          """);
        await db.execute("""
          INSERT INTO locks (deviceName, room, isActive) 
          VALUES 
          ('Lock1', 'Salotto', 1),
          ('Lock2', 'Cucina', 0)
          """);
        await db.execute("""
          INSERT INTO lights (deviceName, room, isActive, lightTemperature)
          VALUES
          ('luce di simone', 'Cameretta', 1, 26),
          ('luce di mario', 'Caemretta', 0, 4000)
          """);
        await db.execute("""
          INSERT INTO thermostats (deviceName, room, currentTemp, desiredTemp)
          VALUES
          ('Thermo1', 'Salotto', 20.0, 22.0),
          ('Thermo2', 'Cucina', 18.0, 20.0)
          """);
        //TODO MANCA RIFERIMENTO AL DISPOSITIVO IN QUESTIONE, MODIFICARE TABELLA
        await db.execute("""
          INSERT INTO automation (idAutomation, name, startTime, endTime, isActive)
           VALUES
            (1, 'Morning Routine', '06:00:00', '08:00:00', 1),
            (2, 'Evening Routine', '18:00:00', '22:00:00', 0)
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

  Future<void> destroyDb() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'mio_database.db');
    await deleteDatabase(dbPath);
    exit(0);
  }
}

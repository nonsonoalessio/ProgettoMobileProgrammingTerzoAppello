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
          CREATE TABLE IF NOT EXISTS alarms (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              isActive BOOLEAN NOT NULL,
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS locks (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              isActive BOOLEAN NOT NULL,
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS lights (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              isActive BOOLEAN NOT NULL,
              lightTemperature INTEGER NOT NULL,
              PRIMARY KEY (deviceName, room)
          )
          """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS thermostats (
              deviceName TEXT NOT NULL,
              room TEXT NOT NULL,
              currentTemp REAL NOT NULL,
              desiredTemp REAL NOT NULL,
              PRIMARY KEY (deviceName, room)
          )
          """);

        await db.execute("""
          INSERT INTO alarms (deviceName, room, isActive) 
          VALUES ('Device1', 'LivingRoom', 1)
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
}

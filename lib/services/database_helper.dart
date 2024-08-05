import 'package:progetto_mobile_programming/models/string_model.dart';
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
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE names(name TEXT PRIMARY KEY)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertName(StringModel string) async {
    final db = await database;
    await db.insert(
      'names',
      string.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

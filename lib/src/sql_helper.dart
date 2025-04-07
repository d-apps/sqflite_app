import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/src/models/data_item.dart';

class SQLHelper {
  static Database? _instance;

  static Future<Database> get database async {
    if (_instance != null) return _instance!;
    _instance = await _initDatabase();
    return _instance!;
  }

  static Future<Database> _initDatabase() async {
    return openDatabase(
      'database_1.db',
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute("""
        CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        desc TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
        """
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE data ADD COLUMN isCompleted INTEGER DEFAULT 0');
        }
      },
    );
  }

  static Future<int> createData(DataItem item) async {
    final db = await database;
    final id = await db.insert('data', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<DataItem>> getAllData() async {
    final db = await database;
    final maps = await db.query('data', orderBy: 'id');
    return maps.map((e) => DataItem.fromMap(e)).toList();
  }

  static Future<List<DataItem>> getSingleData(int id) async {
    final db = await database;
    final maps = await db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return maps.map((e) => DataItem.fromMap(e)).toList();
    }
    return [];
  }

  static Future<int> updateData(DataItem item) async {
    final db = await database;
    item = item.copyWith(
      createdAt: DateTime.now().toIso8601String(),
    );
    final result = await db.update('data', item.toMap(), where: "id = ?", whereArgs: [item.id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await database;
    try{
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch(e){
      print(e.toString());
    }
  }

}
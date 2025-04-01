

import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTables(Database database) async {
    await database.execute("""
        CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        desc TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
        """
    );
  }

  static Future<Database> db() async {
    return openDatabase(
      'database_name.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await createTables(db);
      },
    );
  }

  static Future<int> createData(String title, String? desc) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'desc': desc};
    final id = await db.insert('data', data, conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String title, String? desc) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'desc': desc,
      'createdAt': DateTime.now().toIso8601String()
    };
    final result = await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();
    try{
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    } catch(e){
      print(e.toString());
    }
  }

}
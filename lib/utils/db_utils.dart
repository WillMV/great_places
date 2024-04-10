import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DbUtil {
  static Future<Database> dataBase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) async {
        return db.execute(
            'CREATE TABLE Places (id INTEGER PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await dataBase();
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final Database db = await dataBase();
    return db.query(table);
  }
}

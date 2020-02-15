import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  sql.Database _database;

  Future<sql.Database> get _databaseGet async {
    if (_database != null && _database.isOpen) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<sql.Database> initDB() async {
    final dbPath = await sql.getDatabasesPath();
    String path = join(dbPath, "database.db");
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE UnlockedQuotes(id TEXT PRIMARY KEY, isFavorite INTEGER, unlockingTime TEXT)',
        );
      },
    );
  }

  Future insert(String table, Map<String, dynamic> data) async {
    final db = await _databaseGet;
    var res = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<Map<String, dynamic>> getElement(String table, String id) async {
    final db = await _databaseGet;
    var res = await db.query(table, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? res.first : Null;
  }

  Future<List<Map<String, dynamic>>> getAllElements(String table) async {
    final db = await _databaseGet;
    var res = await db.query('UnlockedQuotes');
    return res.isNotEmpty ? res : [];
  }

  Future resetGame(context) async {
    final dbPath = await sql.getDatabasesPath();
    String path = join(dbPath, "database.db");
    final db = await _databaseGet;
    await db.close();
    await sql.deleteDatabase(path);
    Phoenix.rebirth(context);
  }

  Future updateElementById(
    String table,
    String id,
    Map<String, dynamic> values,
  ) async {
    final db = await _databaseGet;
    db.update(table, values, where: 'id=?', whereArgs: [id]);
  }
}

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    String path = join(dbPath, "database.db");
    return await sql.openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE UnlockedQuotes(id TEXT PRIMARY KEY, isFavorite INTEGER, unlockingTime TEXT)');
      },
    );
  }

  Future insert(String table, Map<String, dynamic> data) async {
    final db = await database();
    var res = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    print(await getElement('UnlockedQuotes', data['id']));
    return res;
  }

  getElement(String table, String id) async {
    final db = await database();
    var res = await db.query(table, where: "id = ?", whereArgs: [id]);
    print(res.isNotEmpty ? res.first : '');
    return res.isNotEmpty ? res.first : Null;
  }
}

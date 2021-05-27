import 'dart:async';
import 'dart:convert';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_phoenix/generated/i18n.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  sql.Database? _database;

  Future<sql.Database?> get _databaseGet async {
    if (_database != null && _database!.isOpen) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<sql.Database> initDB() async {
    final dbPath = await sql.getDatabasesPath();
    var path = join(dbPath, 'database.db');
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE UnlockedQuotes(id TEXT PRIMARY KEY, isFavorite INTEGER, unlockingTime TEXT)',
        );
        await db.execute(
          'CREATE TABLE Items(id TEXT PRIMARY KEY, level INTEGER)',
        );
        await db.execute(
          'CREATE TABLE LevelRewards(id INTEGER PRIMARY KEY, levelAchieved INTEGER, billsReward INTEGER, diamondsReward INTEGER, rarityUp TEXT)',
        );
      },
    );
  }

  Future insert(String table, Map<String, dynamic> data) async {
    final db = await _databaseGet;
    var res = await db!.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<Map<String, dynamic>> getElement(String table, String? id) async {
    final db = await _databaseGet;
    var res = await db!.query(table, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? res.first : {};
  }

  Future<List<Map<String, dynamic>>> getAllElements(String table) async {
    final db = await _databaseGet;
    var res = await db!.query(table);
    return res.isNotEmpty ? res : [];
  }

  Future<Map<String, dynamic>> databaseToJSON() async {
    final db = await _databaseGet;

    var tableNamesMap = await db!.rawQuery('''
SELECT
    name
FROM
    sqlite_master
WHERE
    type ='table' AND
    name NOT LIKE 'sqlite_%' AND
    name NOT LIKE 'android_metadata';
''');

    var tableNames = tableNamesMap.map((e) => e['name']).toList();

    var endMap = {'sqlite': {}};

    for (var e in tableNames) {
      endMap['sqlite']![e] = await getAllElements(e.toString());
    }

    return endMap;
  }

  Future fillDatabaseFromJSON(Map<String, dynamic> json) async {
    final db = await _databaseGet;

    var tableNamesMap = await db!.rawQuery('''
SELECT
    name
FROM
    sqlite_master
WHERE
    type ='table' AND
    name NOT LIKE 'sqlite_%' AND
    name NOT LIKE 'android_metadata';
''');

    var tableNames = tableNamesMap.map((e) => e['name']).toList();

    tableNames.forEach((e) async {
      await db.delete(e.toString());
    });

    json['sqlite']!.forEach((key, value) async {
      if (value.isNotEmpty) {
        value.forEach(
          (element) async {
            await insert(key, element);
          },
        );
      }
    });
  }

  Future resetGame(context) async {
    final dbPath = await sql.getDatabasesPath();
    var path = join(dbPath, 'database.db');
    final db = await _databaseGet;

    await db!.close();
    await sql.deleteDatabase(path);

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Phoenix.rebirth(context);
  }

  Future updateElementById(
    String table,
    String? id,
    Map<String, dynamic> values,
  ) async {
    final db = await _databaseGet;
    await db!.update(table, values, where: 'id=?', whereArgs: [id]);
  }

  Future removeElementById(String table, dynamic id) async {
    final db = await _databaseGet;
    await db!.delete(table, where: 'id=?', whereArgs: [id]);
  }
}

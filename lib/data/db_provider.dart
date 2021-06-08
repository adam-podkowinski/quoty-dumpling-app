import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBProvider extends ChangeNotifier {
  sql.Database? _database;

  bool isSignedIn = false;

  Future<sql.Database?> get _databaseGet async {
    if (_database != null && _database!.isOpen) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<void> signIn() async {
    if (!isSignedIn) {
      const platform = MethodChannel('quotyDumplingChannel');
      isSignedIn = await platform.invokeMethod('signIn');
      print('Is signed in? : $isSignedIn');
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (isSignedIn) {
      const platform = MethodChannel('quotyDumplingChannel');
      isSignedIn = await platform.invokeMethod('signOut');
      print('Is signed in? : $isSignedIn');
      notifyListeners();
    }
  }

  Future<void> isUserSignedIn() async {
    var isSignedInCopy = isSignedIn;
    const platform = MethodChannel('quotyDumplingChannel');
    isSignedIn = await platform.invokeMethod('isUserSignedIn');
    print('Is signed in? : $isSignedIn');
    if (isSignedIn != isSignedInCopy) notifyListeners();
  }

  Future<void> loadDataFromGooglePlay() async {
    if (isSignedIn) {
      const platform = MethodChannel('quotyDumplingChannel');
      String data = await platform.invokeMethod('loadJSONBytesFromGooglePlay');
      print('\n\nDATA LOADED FROM GOOGLE PLAY: $data\n\n');
    }
  }

  Future<void> saveJSONToGooglePlay() async {
    if (isSignedIn) {
      const platform = MethodChannel('quotyDumplingChannel');
      await platform.invokeMethod('saveJSONToGooglePlay');
    }
  }

  void changeIsSignedInToTrue() {
    isSignedIn = true;
    notifyListeners();
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

    var endMap = {'sqlite': {}, 'shared_preferences': {}};

    for (var e in tableNames) {
      endMap['sqlite']![e] = await getAllElements(e.toString());
    }

    var prefs = await SharedPreferences.getInstance();
    var prefsKeys = prefs.getKeys();

    for (var e in prefsKeys) {
      endMap['shared_preferences']![e] = prefs.get(e);
    }

    print(endMap);
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

    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    json['shared_preferences']!.forEach((key, value) async {
      switch (value.runtimeType) {
        case int:
          await prefs.setInt(key, value);
          break;
        case String:
          await prefs.setString(key, value);
          break;
        case bool:
          await prefs.setBool(key, value);
          break;
        case double:
          await prefs.setDouble(key, value);
          break;
        default:
          break;
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

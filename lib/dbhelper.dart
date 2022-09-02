import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dbhelper {
  Future<Database> createDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT,textindex INTEGER)');
    });

    return database;
  }

  static List<Color> basecolor = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.redAccent,
    Colors.grey,
    Colors.green,
    Colors.greenAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.blueGrey,
    Colors.blueAccent,
    Colors.blue,
    Colors.brown,
    Colors.blueAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.indigo,
    Colors.lime,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.yellow,
    Colors.deepPurpleAccent,
    Colors.deepOrange,
    Colors.limeAccent
  ];

}

class Utils {
  static SharedPreferences? prefs;
}

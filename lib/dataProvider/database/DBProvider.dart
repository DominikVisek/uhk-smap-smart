import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:uhk_smap_smart_weather_reminder/model/database/Reminder.dart';

class DBProvider {
  static Database _database;
  static DBProvider _databaseProvider;

  DBProvider._();

  static final DBProvider db = DBProvider._();

  factory DBProvider() {

    if (_databaseProvider == null) {
      _databaseProvider =  DBProvider._(); // This is executed only once, singleton object
    }

    return _databaseProvider;
  }

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WeatherReminderDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE reminders ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "time TEXT,"
          "latitude DOUBLE,"
          "longitude DOUBLE,"
          "name TEXT,"
          "description TEXT,"
          "daysBeforeNotify INTEGER,"
          "temperature DOUBLE"
          ")");
    });
  }

  createReminder(Reminder reminder) async {
    final db = await database;
    var response = await db.insert('reminders', reminder.toMap());

    return response;
  }
  
  deleteReminder(int id) async {
    final db = await database;
    await db.delete('reminders', where: "id = ?", whereArgs: [id]);
  }
  

  Future<List<Map<String, dynamic>>> getRemindersList() async {
    Database db = await this.database;
    var result = await db.query('reminders');

    return result;
  }

  Future<List<Reminder>> getReminders() async {
    var reminderMapList = await getRemindersList();
    int count = reminderMapList.length;

    List<Reminder> remindersList = List<Reminder>();
    for (int i = 0; i < count; i++) {
      remindersList.add(Reminder.fromMap(reminderMapList[i]));
    }

    return remindersList;
  }
}

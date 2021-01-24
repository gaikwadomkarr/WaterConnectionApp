import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class WaterConnectionDBHelper {
  static final WaterConnectionDBHelper instance =
      WaterConnectionDBHelper._internal();
  static Database waterconnectionDB;
  WaterConnectionDBHelper._internal();

  factory WaterConnectionDBHelper() {
    return instance;
  }

  Future<Database> get db async {
    if (waterconnectionDB != null) {
      return waterconnectionDB;
    }
    waterconnectionDB = await init();
    return waterconnectionDB;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'WaterConnection.db');
    var database = openDatabase(
      dbPath,
      version: 2,
      onCreate: _onCreate,
    );

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE connections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        consumerName TEXT,
        consumerPhoto TEXT,
        contractor INTEGER,
        saddle TEXT,
        zone TEXT,
        consumerMobile TEXT,
        consumerAddress TEXT,
        latitude TEXT,
        longitude TEXT,
        created_at TEXT,  
        ferrule TEXT,
        roadCrossing TEXT,
        mdpePipeLength TEXT,
        zoneId INTEGER,
        saddleId INTEGER,
        contractorId INTEGER,
        branchId INTEGER,
        created_by INTEGER
        )
    ''');
    print("Database was created!");
  }
}

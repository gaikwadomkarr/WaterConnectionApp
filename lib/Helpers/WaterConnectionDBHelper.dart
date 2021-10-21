import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waterconnection/Models/ConnectionDB.dart';
import 'package:waterconnection/Models/MeterReadingDB.dart';

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
    Directory directory = await getExternalStorageDirectory();
    String dbPath = join(directory.path, 'WaterConnection.db');
    print("this is db path => " + dbPath.toString());
    var database = openDatabase(
      dbPath,
      version: 2,
      onCreate: _onCreate,
    );

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE meterreadings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        consumerName TEXT,
        consumerPhoto TEXT,
        meterNumber INTEGER,
        meterReading INTEGER,
        consumerAddress TEXT,
        latitude TEXT,
        longitude TEXT,
        created_at TEXT,
        branchId INTEGER,
        uploadStatus TEXT
        )
    ''');
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
        created_by INTEGER,
        uploadStatus TEXT
        )
    ''');
    print("Database was created!");
  }

  void saveConnection(ConnectionDb connectionDb) async {
    var client = await db;
    client.insert('connections', connectionDb.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("entry made to database");
  }

  void deleteConnection(int id) async {
    var client = await db;
    client.delete("connections", where: "id = ?", whereArgs: [id]);
    print("entry made to database");
  }

  void updateConnection() async {
    var client = await db;
    client.rawUpdate(
        '''UPDATE connections SET uploadStatus = "Yes" WHERE uploadStatus = "No"''');
    print("entry made to database");
  }

  Future<List<ConnectionDb>> getConnections() async {
    final client = await db;
    final List<Map<String, dynamic>> connectionList =
        await client.query('connections');
    return List.generate(connectionList.length, (i) {
      return ConnectionDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          contractor: connectionList[i]['contractor'],
          saddle: connectionList[i]['saddle'],
          zone: connectionList[i]['zone'],
          consumerMobile: connectionList[i]['consumerMobile'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          ferrule: connectionList[i]['ferrule'],
          roadCrossing: connectionList[i]['roadCrossing'],
          mdpePipeLength: connectionList[i]['mdpePipeLength'],
          zoneId: connectionList[i]['zoneId'],
          saddleId: connectionList[i]['saddleId'],
          contractorId: connectionList[i]['contractorId'],
          branchId: connectionList[i]['branchId'],
          createdBy: connectionList[i]['created_by'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  Future<List<ConnectionDb>> getConnectionsByName(name) async {
    final client = await db;
    final List<Map<String, dynamic>> connectionList = await client.rawQuery(
        "SELECT * from connections WHERE consumerName like '%$name%'");
    return List.generate(connectionList.length, (i) {
      return ConnectionDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          contractor: connectionList[i]['contractor'],
          saddle: connectionList[i]['saddle'],
          zone: connectionList[i]['zone'],
          consumerMobile: connectionList[i]['consumerMobile'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          ferrule: connectionList[i]['ferrule'],
          roadCrossing: connectionList[i]['roadCrossing'],
          mdpePipeLength: connectionList[i]['mdpePipeLength'],
          zoneId: connectionList[i]['zoneId'],
          saddleId: connectionList[i]['saddleId'],
          contractorId: connectionList[i]['contractorId'],
          branchId: connectionList[i]['branchId'],
          createdBy: connectionList[i]['created_by'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  Future<List<ConnectionDb>> getConnectionsByStatus(status) async {
    final client = await db;
    final List<Map<String, dynamic>> connectionList = await client
        .rawQuery("SELECT * from connections WHERE uploadStatus='$status'");
    return List.generate(connectionList.length, (i) {
      return ConnectionDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          contractor: connectionList[i]['contractor'],
          saddle: connectionList[i]['saddle'],
          zone: connectionList[i]['zone'],
          consumerMobile: connectionList[i]['consumerMobile'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          ferrule: connectionList[i]['ferrule'],
          roadCrossing: connectionList[i]['roadCrossing'],
          mdpePipeLength: connectionList[i]['mdpePipeLength'],
          zoneId: connectionList[i]['zoneId'],
          saddleId: connectionList[i]['saddleId'],
          contractorId: connectionList[i]['contractorId'],
          branchId: connectionList[i]['branchId'],
          createdBy: connectionList[i]['created_by'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  Future<List<ConnectionDb>> getConnectionsByDate(startDate, endDate) async {
    final client = await db;
    List<Map<String, dynamic>> connectionList = List<Map<String, dynamic>>();
    // if (startDate == endDate) {
    //   connectionList = await client
    //       .rawQuery("SELECT * from connections WHERE created_at='$startDate'");
    // } else {
    connectionList = await client.rawQuery(
        "SELECT * from connections WHERE created_at BETWEEN '$startDate' AND '$endDate'");
    // "SELECT * from connections WHERE DATE_FORMAT(created_at, '%dd-%MM-%yyyy') BETWEEN '$startDate' AND '$endDate'");
    // "SELECT * from connections WHERE created_at in ('$startDate','$endDate')");

    // }
    return List.generate(connectionList.length, (i) {
      return ConnectionDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          contractor: connectionList[i]['contractor'],
          saddle: connectionList[i]['saddle'],
          zone: connectionList[i]['zone'],
          consumerMobile: connectionList[i]['consumerMobile'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          ferrule: connectionList[i]['ferrule'],
          roadCrossing: connectionList[i]['roadCrossing'],
          mdpePipeLength: connectionList[i]['mdpePipeLength'],
          zoneId: connectionList[i]['zoneId'],
          saddleId: connectionList[i]['saddleId'],
          contractorId: connectionList[i]['contractorId'],
          branchId: connectionList[i]['branchId'],
          createdBy: connectionList[i]['created_by'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  void saveMeterReading(MeterReadingDb meterReadingDb) async {
    var client = await db;
    client.insert('meterreadings', meterReadingDb.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print("reading entry made to database");
  }

  void deleteMeterReading(int id) async {
    var client = await db;
    client.delete("meterreadings", where: "id = ?", whereArgs: [id]);
    print("entry made to database");
  }

  void updateMeterReading() async {
    var client = await db;
    client.rawUpdate(
        '''UPDATE meterreadings SET uploadStatus = "Yes" WHERE uploadStatus = "No"''');
    print("entry made to database");
  }

  Future<List<MeterReadingDb>> getMeterReadingsList() async {
    final client = await db;
    final List<Map<String, dynamic>> connectionList =
        await client.query('meterreadings');
    return List.generate(connectionList.length, (i) {
      return MeterReadingDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          meterNumber: connectionList[i]['meterNumber'],
          meterReading: connectionList[i]['meterReading'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          branchId: connectionList[i]['branchId'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  Future<List<MeterReadingDb>> geMeterReadingsByName(name) async {
    final client = await db;
    final List<Map<String, dynamic>> connectionList = await client.rawQuery(
        "SELECT * from meterreadings WHERE consumerName like '%$name%'");
    return List.generate(connectionList.length, (i) {
      return MeterReadingDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          meterNumber: connectionList[i]['meterNumber'],
          meterReading: connectionList[i]['meterReading'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          branchId: connectionList[i]['branchId'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  Future<List<MeterReadingDb>> getMeterReadingsByStatus(status) async {
    final client = await db;
    final List<Map<String, dynamic>> connectionList = await client
        .rawQuery("SELECT * from meterreadings WHERE uploadStatus='$status'");
    return List.generate(connectionList.length, (i) {
      return MeterReadingDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          meterNumber: connectionList[i]['meterNumber'],
          meterReading: connectionList[i]['meterReading'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          branchId: connectionList[i]['branchId'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }

  Future<List<MeterReadingDb>> getMeterReadingsByDate(
      startDate, endDate) async {
    final client = await db;
    List<Map<String, dynamic>> connectionList = List<Map<String, dynamic>>();
    connectionList = await client.rawQuery(
        "SELECT * from meterreadings WHERE created_at BETWEEN '$startDate' AND '$endDate'");
    return List.generate(connectionList.length, (i) {
      return MeterReadingDb(
          id: connectionList[i]['id'],
          consumerName: connectionList[i]['consumerName'],
          consumerPhoto: connectionList[i]['consumerPhoto'],
          meterNumber: connectionList[i]['meterNumber'],
          meterReading: connectionList[i]['meterReading'],
          consumerAddress: connectionList[i]['consumerAddress'],
          latitude: connectionList[i]['latitude'],
          longitude: connectionList[i]['longitude'],
          createdAt: connectionList[i]['created_at'],
          branchId: connectionList[i]['branchId'],
          uploadStatus: connectionList[i]["uploadStatus"]);
    });
  }
}

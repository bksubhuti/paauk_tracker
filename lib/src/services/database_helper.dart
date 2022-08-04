import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  // Future? _dbInit;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    bool newdb = false;

    _database = await openDatabase('assets/paauk_tracker.db');
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'paauk_tracker.db');

    //Check if DB exists
    var exists = await databaseExists(path);

    if (!exists || newdb) {
      // or newdb is to always if db changes  (set to true for initial debug mode)
      //print('Create a new copy from assets');

      //Check if parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      //Copy from assets
      ByteData data = await rootBundle.load(join("assets", "paauk_tracker.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      //Write and flush the bytes
      await File(path).writeAsBytes(bytes, flush: true);
    }

    //Open the database
    return await openDatabase(path, readOnly: false);
  }

  Future close() async {
    await _database?.close();
    _database = null;
  }
}

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database _db;
  Future? _dbInit;

  Future initDatabase() async {
    bool newdb = false;
    _dbInit ??= await () async {
      _db = await openDatabase('assets/paauk_tracker.db');
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
        ByteData data =
            await rootBundle.load(join("assets", "paauk_tracker.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        //Write and flush the bytes
        await File(path).writeAsBytes(bytes, flush: true);
      }

      //Open the database
      _db = await openDatabase(path, readOnly: true);
    }();
  }

  Future<List<ResidentDetails>> getResidentDetails(searchKey) async {
    await initDatabase();
    String dbQuery =
        "SELECT kuti, id_code, passport_name,country, dhamma_name FROM residentDetails WHERE kuti Like 'A%';";

    if (searchKey != "") {
      dbQuery =
          "SELECT kuti, id_code, passport_name,country, dhamma_name FROM residentDetails WHERE kuti Like '$searchKey%';";
    }

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((residentdetails) => ResidentDetails.fromJson(residentdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  dispose() {
    _db.close();
  }
}

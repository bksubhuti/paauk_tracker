import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:paauk_tracker/src/services/database_helper.dart';

class GetResidentDetails {
  final _dbHelper = DatabaseHelper();

  /*late Database _db;
  Future? _dbInit;

  Future initDatabase() async {
    bool newdb = true;
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
*/
  Future<List<ResidentDetails>> getResidentDetails(searchKey) async {
    //await initDatabase();
    final _db = await _dbHelper.database;

    String dbQuery =
        "SELECT kuti, id_code, passport_name,country, dhamma_name FROM residentDetails WHERE kuti Like 'A%';";

    if (searchKey != "") {
      switch (searchKey) {
        case 'A':
        case 'G':
        case 'I':
          dbQuery =
              "SELECT kuti, id_code, passport_name,country, dhamma_name FROM residentDetails WHERE kuti Like '$searchKey%' AND substr (Kuti,2,1)  IN ( '0','1','2','3','4','5','6','7','8','9') ORDER BY kuti;";
          break;
        default:
          dbQuery =
              "SELECT kuti, id_code, passport_name,country, dhamma_name FROM residentDetails WHERE kuti Like '$searchKey%' ORDER BY kuti;";
      }
    }

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((residentdetails) => ResidentDetails.fromJson(residentdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future addResidentRecords(String dbQuery) async {
    final _db = await _dbHelper.database;

    await _db.rawQuery(dbQuery);
  }

  Future deleteAllRecords() async {
    final _db = await _dbHelper.database;

    await _db.rawQuery("Delete  from residentDetails");
  }
}

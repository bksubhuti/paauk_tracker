import 'package:paauk_tracker/src/models/kuti_group.dart';
import 'package:paauk_tracker/src/services/database_helper.dart';

class GetKutiGroups {
  final _dbHelper = DatabaseHelper();
  Future<List<KutiGroup>> getInterviewDetails() async {
    //await initDatabase();
    final _db = await _dbHelper.database;

    String dbQuery = '''Select kuti_group
        FROM kutiGroups
''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list.map((kutigroups) => KutiGroup.fromJson(kutigroups)).toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }
}

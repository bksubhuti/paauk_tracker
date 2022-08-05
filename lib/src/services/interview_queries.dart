import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/services/database_helper.dart';

class InterviewQueries {
  final _dbHelper = DatabaseHelper();
  Future<List<InterviewDetails>> getInterviewDetails(
      int dummy, bool sayadawgyi) async {
    //await initDatabase();
    final _db = await _dbHelper.database;
    final now = DateTime.now();
    final teacher = sayadawgyi ? "1" : "2";

    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.kuti, residentDetails.country, interviews.stime 
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code AND teacher = '$teacher' AND stime = '${now.day}/${now.month}/${now.year}'
          ORDER BY interviews.real_time DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future<List<InterviewDetails>> getAllInterviewDetails() async {
    //await initDatabase();
    final _db = await _dbHelper.database;
    final now = DateTime.now();

    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.kuti, residentDetails.country, interviews.stime, interviews.real_time, interviews.teacher
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code
          ORDER BY interviews.real_time DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future<List<InterviewDetails>> getInterviewDetailsByDate(
      DateTime dt, bool sayadawgyi) async {
    final _db = await _dbHelper.database;
    final teacher = sayadawgyi ? "1" : "2";

    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.kuti, residentDetails.country, interviews.stime 
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code AND teacher = '$teacher' AND stime = '${dt.day}/${dt.month}/${dt.year}'
          ORDER BY interviews.real_time DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();
  }

  Future<List<InterviewDetails>> getInterviewDatesByID(
      String idCode, bool sayadawgyi) async {
    //await initDatabase();
    final _db = await _dbHelper.database;
    final teacher = sayadawgyi ? "1" : "2";

    String dbQuery = '''Select stime 
          FROM interviews
          WHERE id_code= '$idCode' AND teacher = '$teacher' 
          ORDER BY real_time DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list // reuse this map because null safety all fields will be na but the ones we are looking for
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future addInterviewRecord(String iDCode, bool sayayadawgyi) async {
    final _db = await _dbHelper.database;
    final now = DateTime.now();
    final teacher = sayayadawgyi ? "1" : "2";

    String dbQuery =
        '''Insert INTO interviews (id_code, stime, real_time, teacher) 
        SELECT '$iDCode','${now.day}/${now.month}/${now.year}',${now.microsecondsSinceEpoch},$teacher 
        WHERE NOT EXISTS(
                         SELECT id_code, stime FROM interviews 
                        WHERE id_code = '$iDCode' AND teacher ='$teacher' AND stime = '${now.day}/${now.month}/${now.year}'
                        );''';

/* ////////////////////////////////////////////////////////////////
    This prevents duplicate entries.. as we count entries.
    but someone can do both interviews.
//////////////////////////////////////////////////////////////////////
    Insert INTO interviews (id_code, stime, real_time, teacher) 
    SELECT '021','3/8/2022',1659524225711900,'1' 
		WHERE NOT EXISTS(
		SELECT id_code, stime FROM interviews 
        WHERE id_code = '021' AND AND teacher = '1' AND stime = '3/8/2022');
*/

    await _db.rawQuery(dbQuery);
  }
}

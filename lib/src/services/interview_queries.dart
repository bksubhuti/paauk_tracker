import 'package:intl/intl.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/services/database_helper.dart';

class InterviewQueries {
  final _dbHelper = DatabaseHelper();
  Future<List<InterviewDetails>> getInterviewDetails(
      int dummy, bool sayadawgyi) async {
    //await initDatabase();
    final _db = await _dbHelper.database;
    final teacher = sayadawgyi ? "1" : "2";
    final now = DateTime.now();
    String formattedLikeDate = DateFormat('yyyyMMdd').format(now);

    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.passport_name, residentDetails.kuti, residentDetails.country, interviews.stime, interviews.pk
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code AND teacher = '$teacher' AND stime LIKE '$formattedLikeDate%'
          ORDER BY interviews.stime DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future<List<InterviewDetails>> getAllInterviewDetails() async {
    //await initDatabase();
    final _db = await _dbHelper.database;

    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.passport_name,residentDetails.kuti, residentDetails.country, interviews.stime, interviews.teacher, interviews.pk
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code
          ORDER BY interviews.stime DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future<List<InterviewDetails>> getSyncInterviewDetails() async {
    //await initDatabase();
    final _db = await _dbHelper.database;

    String dbQuery =
        '''Select residentDetails.id_code,residentDetails.dhamma_name,residentDetails.passport_name,residentDetails.kuti,residentDetails.country,interviews.stime,interviews.teacher,interviews.pk
          FROM residentDetails, interviews, interviewsSync
          WHERE residentDetails.id_code = interviews.id_code AND interviewsSync.fk = interviews.pk
          ORDER BY interviews.stime''';

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
    String formattedLikeDate = DateFormat('yyyyMMdd').format(dt);

    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.passport_name, residentDetails.kuti, residentDetails.country, interviews.stime 
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code AND teacher = '$teacher' AND stime LIKE '$formattedLikeDate%'
          ORDER BY interviews.stime DESC''';

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
          ORDER BY stime DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list // reuse this map because null safety all fields will be na but the ones we are looking for
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    //return list.map((trail) => Trail.fromJson(trail)).toList();
  }

  Future deleteInterviewRecord(String iDCode, bool sayadawgyi) async {
    final _db = await _dbHelper.database;
    final teacher = sayadawgyi ? "1" : "2";
    final now = DateTime.now();
    String formattedLikeDate = DateFormat('yyyyMMdd').format(now);

    String dbQuery =
        "Delete from interviews WHERE id_code = '$iDCode' AND  teacher='$teacher' AND stime LIKE '$formattedLikeDate%'";

    await _db.rawQuery(dbQuery);

    dbQuery =
        "Delete from interviewsSync WHERE interviewsSync.fk =  interviews.pk";

    await _db.rawQuery(dbQuery);
  }

  Future deleteInterviewSyncRecordByFk(int fk) async {
    final _db = await _dbHelper.database;

    String dbQuery = "Delete from interviewsSync WHERE fk = '$fk'";

    await _db.rawQuery(dbQuery);
  }

  Future addInterviewRecord(String iDCode, bool sayayadawgyi) async {
    final _db = await _dbHelper.database;
    final teacher = sayayadawgyi ? "1" : "2";
    final now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddkkmmss').format(now);
    String formattedLikeDate = DateFormat('yyyyMMdd').format(now);

//    final stime = "${now.year}${now.month.}${now.day}${now.hour}${now.second}";

    String dbQuery = '''Insert INTO interviews (id_code, stime, teacher) 
        SELECT '$iDCode','$formattedDate',$teacher 
        WHERE NOT EXISTS(
                         SELECT id_code, stime FROM interviews 
                        WHERE id_code = '$iDCode' AND teacher ='$teacher' AND stime LIKE '$formattedLikeDate%'
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

// now add a record to the interviewsSync table the same way.. we don't know if it is there already like previous query
    dbQuery = '''Insert INTO interviewsSync (fk) 
        SELECT pk From interviews
        WHERE id_code = '$iDCode' AND teacher ='$teacher' AND stime = '$formattedDate'
        AND NOT EXISTS(
                         SELECT pk FROM interviews, interviewsSync 
                        WHERE id_code = '$iDCode' AND teacher ='$teacher' AND stime LIKE  '$formattedLikeDate%' 
                        AND interviews.pk = interviewsSync.fk
                        );''';

/*
Insert INTO interviewsSync (fk) 
        SELECT pk From interviews
        WHERE id_code = 'de8' AND teacher ='1' AND stime = '3/8/2022' 
		AND NOT EXISTS(
                         SELECT pk FROM interviews, interviewsSync
                        WHERE id_code = 'de8' AND teacher ='1' AND stime = '3/8/2022'
                        AND interviews.pk = interviewsSync.fk);


 */
    await _db.rawQuery(dbQuery);
  }
}

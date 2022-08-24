import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'dart:convert';
import 'dart:core';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/provider/admin_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:archive/archive_io.dart';

import 'package:path/path.dart';

class AdminService {
  AdminService({required this.adminNotifier});
  final AdminNotifier adminNotifier;

  String _dir = "";

  final String _zipPath =
      'https://apply.paauksociety.org/app_interview.php?images.zip';
  final String _localZipFileName = 'images.zip';
  final String _localResidentSqlFileName = "residentDetails.sql";
  final String _residentSqlDataURL =
      'https://apply.paauksociety.org/app_interview.php?residentDetails.sql';
  final dbService = InterviewQueries();
  final residentService = GetResidentDetails();

  String _password = "not-set";
  String get password => _password;

  set password(String val) {
    _password = val;
  }

  //////////////////////////////////////////
  ///admin button routines
  ///
  /////////////////////////////////////////////
  Future writeCSVFile() async {
    String csv = "id_code\tteacher\tstime\n";
    List<InterviewDetails> rows = await dbService.getAllInterviewDetails();

    for (int i = 0; i < rows.length; i++) {
      csv += "${rows[i].id_code}\t${rows[i].teacher}\t${rows[i].stime}\n";
    }

    String path = join(Prefs.databaseDir, 'paauk_tracker.csv');

    File f = File(path);
    //String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }

  Future fetchResidentSQL() async {
    final Response response = await http.get(Uri.parse(_residentSqlDataURL));

//    await _downloadFile(_residentSqlDataURL, _localResidentSqlFileName);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Album.fromJson(jsonDecode(response.body));
      //    var file = File('$_dir/$_localResidentSqlFileName');
      //  debugPrint("file.path ${file.path}");
//      file.writeAsBytes(response.bodyBytes);

      String uniSql = utf8.decode(response.body.runes.toList());

      debugPrint(uniSql);
      adminNotifier.message = "downloaded sql file\n";

      LineSplitter ls = const LineSplitter();
      List<String> dbQueries = ls.convert(uniSql);

      adminNotifier.message += "\nDeleting All from residentDetails Table\n";
      await residentService.deleteAllRecords();

      for (int index = 0; index < dbQueries.length; index++) {
        await residentService.addResidentRecords(dbQueries[index]);

        adminNotifier.message =
            "\nAdded ${index + 1} Line of ${dbQueries.length} }\n";
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load sql File');
    }
  }

  Future<void> downloadZip() async {
    var zippedFile = await downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);
  }

  Future getZipFile() async {
    initDir();

    // check to see if there is a connection
    bool hasInternet = await InternetConnectionChecker().hasConnection;
/*
    setState(() {
      _message = "Internet connection = $hasInternet";
    });
    */
    adminNotifier.message = "Internet connection = $hasInternet";
    if (hasInternet) {
      //setState(() {
      adminNotifier.downloading = true;
      adminNotifier.message = "\nNow downlading file.. about 2MB\nPlease Wait.";
      //});
      await downloadZip();
      adminNotifier.downloading = false;
    }
  }

  Future<File> downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    if (req.statusCode == 200) {
      var file = File('$_dir/$fileName');
      debugPrint("file.path ${file.path}");
      adminNotifier.message += "\nfile.path =  ${file.path}\n";
      return file.writeAsBytes(req.bodyBytes);
    } else {
      throw Exception('Failed to load zip file');
    }
  }

  initDir() async {
    _dir = Prefs.databaseDir;
  }

  unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      debugPrint("fileName $fileName");
      adminNotifier.message += "\nExtracting filename = $fileName\n";
      if (file.isFile && !fileName.contains("__MACOSX")) {
        var outFile = File(fileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
    adminNotifier.message = "\nDownloaded ${archive.length} files";
  }

  Future syncInterviews(BuildContext context) async {
//List<Interview> iSyncList = await getInterviewSyncItems();
// write the list out
//

    List<InterviewDetails> syncList = await dbService.getSyncInterviewDetails();
    String sResponse = "";
    adminNotifier.message += "Sync number = ${syncList.length}\n";

    if (syncList.isNotEmpty) {
      for (int x = 0; x < syncList.length; x++) {
        sResponse = await syncOneInterview(syncList[x]);
        // response will contain "Error" somewhere in the string.
        // if not found, then it is successful
        // delete the record by pk if success
        if (!sResponse.contains("Error")) {
          adminNotifier.message +=
              "success in writing record ${x + 1} for Kuti: ${syncList[x].kuti}\n ";

          dbService.deleteInterviewSyncRecordByFk(syncList[x].pk);
        }
      }
    }

    // clear the sync list
    // requery to make sure sync is empty
    // get all records from interviews from server
    // delete interviews
    // import records to interviews
    adminNotifier.message += '\n Sync from server to device not supported yet ';
/*
    syncList.clear();
    syncList = await dbService.getSyncInterviewDetails();
    if (syncList.isEmpty) {
      // get all data from server (simulated by assets file)
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/interviews_testing.json");

      List<InterviewDetails> serverList =
          interviewDetailsFromJson(data).toList();

      if (serverList.isNotEmpty) {
        List<InterviewDetails> localList =
            await dbService.getAllInterviewDetails();
        // we will assume the server is bigger or equal
        // compare the local to server and remove from server what is found
        // those remaining will be what needs to be added to the local db
        // the list will get shorter and scans get faster as each scan happens.
        for (int x = 0; x < localList.length; x++) {
          //serverList.removeAt(localList[x].isEqual(itme));
          serverList.removeWhere((myob) => localList[x].isEqual(myob));
        }
      }
      setState(() {
        _message += '\nThere were ${serverList.length} new items';
      });

      for (int x = 0; x < serverList.length; x++) {
        await dbService.addInterviewSyncRecord(
            serverList[x].id_code, serverList[x].stime, serverList[x].teacher);
        setState(() {
          _message += "\nadding records ${serverList[x].id_code}";
        });
      }
    }

    */
  }

  Future<String> syncOneInterview(InterviewDetails syncItem) async {
    String sreturn = "Error";
    final Response response = await http.get(Uri.parse(
        'https://apply.paauksociety.org/app_interview.php?id_code=${syncItem.id_code}&stime=${syncItem.stime}&teacher=${syncItem.teacher}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Album.fromJson(jsonDecode(response.body));
      debugPrint(
          'https://apply.paauksociety.org/app_interview.php?id_code=${syncItem.id_code}&stime=${syncItem.stime}&teacher=${syncItem.teacher}');
      debugPrint(response.body);

      // parse response code.
      // count increment sucess count
      // update message each time
      // if success count ==
      sreturn = "1";
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      sreturn = 'Failed to get response';
      adminNotifier.message += sreturn + "\n";
      throw Exception(sreturn);
    }

    return sreturn;
  }
}

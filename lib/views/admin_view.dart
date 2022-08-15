import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'dart:convert';
import 'dart:core';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:archive/archive_io.dart';

import 'package:share_plus/share_plus.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
//  final dbService = GetResidentDetails();
  String _dir = "";
  final String _zipPath =
      'https://apply.paauksociety.org/app_interview.php?images.zip';
  final String _localZipFileName = 'images.zip';
  final String _localResidentSqlFileName = "residentDetails.sql";
  String _message = "status:";
  final String _residentSqlDataURL =
      'https://apply.paauksociety.org/app_interview.php?residentDetails.sql';
  bool _downloading = false;
  final dbService = InterviewQueries();
  final residentService = GetResidentDetails();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //dbService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Card(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 10), elevation: 2),
                ElevatedButton(
                  child: const Text('Share DB'),
                  onPressed: () async {
                    var databasePath = await getDatabasesPath();
                    String path = join(databasePath, 'paauk_tracker.db');
                    final List<String> sl = [path];
                    final box = context.findRenderObject() as RenderBox?;

                    await Share.shareFiles(sl,
                        text: "Share DB",
                        subject: "Pa-Auk Tracker",
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Share CSV'),
                  onPressed: () async {
                    _writeCSVFile();
                    var databasePath = await getDatabasesPath();
                    String path = join(databasePath, 'paauk_tracker.csv');
                    final List<String> sl = [path];
                    final box = context.findRenderObject() as RenderBox?;

                    await Share.shareFiles(sl,
                        text: "Share DB",
                        subject: "Pa-Auk Tracker",
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size);
                  },
                ),
                const SizedBox(height: 20),
                FloatingActionButton.extended(
                  heroTag: "getResidentData",
                  label: const Text('Get Resident Data'),
                  icon: const Icon(Icons.people),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () async {
                    setState(() {
                      _downloading = true;
                    });
                    await fetchResidentSQL();
                    // await dbService.makeKutiSort();
                    setState(() {
                      _downloading = false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                FloatingActionButton.extended(
                  heroTag: "syncInterviews",
                  label: const Text('Sync Interviews'),
                  icon: const Icon(Icons.sync),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () async {
                    _syncInterviews(context);
                  },
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: "getPhotoZip",
                  label: const Text('Get Saṅgha Photo Zip File'),
                  icon: const Icon(Icons.photo_album),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () async {
                    //final myAlbum = await fetchAlbum();
                    await getZipFile();
                  },
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: "testingMakecolumn",
                  label: const Text('Testing Make column'),
                  icon: const Icon(Icons.science),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: () async {
                    final dbService = GetResidentDetails();
                    await dbService.addKSort();
                    await dbService.makeKutiSort();
                  },
                ),
                const SizedBox(height: 60),
                Column(
                  children: [
                    (_downloading == true)
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink(),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 300.0,
                        ),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: ColoredText(_message,
                                maxLines: null,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////
  ///admin button routines
  ///
  /////////////////////////////////////////////
  Future _writeCSVFile() async {
    final dbService = InterviewQueries();
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
      setState(() {
        _message = "downloaded sql file\n";
      });

      LineSplitter ls = const LineSplitter();
      List<String> dbQueries = ls.convert(uniSql);

      setState(() {
        _message += "\nDeleting All from residentDetails Table\n";
      });
      await residentService.deleteAllRecords();

      for (int index = 0; index < dbQueries.length; index++) {
        await residentService.addResidentRecords(dbQueries[index]);

        setState(() {
          _message += "\nAdded ${index + 1} Line of ${dbQueries.length} }\n";
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load sql File');
    }
  }

  Future<void> _downloadZip() async {
    var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);
  }

  Future getZipFile() async {
    _initDir();

    // check to see if there is a connection
    bool hasInternet = await InternetConnectionChecker().hasConnection;

    setState(() {
      _message = "Internet connection = $hasInternet";
    });
    if (hasInternet) {
      setState(() {
        _downloading = true;
        _message = "\nNow downlading file.. about 2MB\nPlease Wait.";
      });
      await _downloadZip();
      setState(() {
        _downloading = false;
      });
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    if (req.statusCode == 200) {
      var file = File('$_dir/$fileName');
      debugPrint("file.path ${file.path}");
      setState(() {
        _message += "\nfile.path =  ${file.path}\n";
      });
      return file.writeAsBytes(req.bodyBytes);
    } else {
      throw Exception('Failed to load zip file');
    }
  }

  _initDir() async {
    _dir = Prefs.databaseDir;
  }

  unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      debugPrint("fileName $fileName");
      setState(() {
        _message += "\nExtracting filename = $fileName\n";
      });
      if (file.isFile && !fileName.contains("__MACOSX")) {
        var outFile = File(fileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
    setState(() {
      _message = "\nDownloaded ${archive.length} files";
    });
  }

  Future _syncInterviews(BuildContext context) async {
//List<Interview> iSyncList = await getInterviewSyncItems();
// write the list out
//

    List<InterviewDetails> syncList = await dbService.getSyncInterviewDetails();
    String sResponse = "";
    setState(() {
      _message += "Sync number = ${syncList.length}\n";
    });

    if (syncList.isNotEmpty) {
      for (int x = 0; x < syncList.length; x++) {
        sResponse = await _syncOneInterview(syncList[x]);
        // response will contain "Error" somewhere in the string.
        // if not found, then it is successful
        // delete the record by pk if success
        if (!sResponse.contains("Error")) {
          setState(() {
            _message +=
                "success in writing record ${x + 1} for Kuti: ${syncList[x].kuti}\n ";
          });

          dbService.deleteInterviewSyncRecordByFk(syncList[x].pk);
        }
      }
    }

    // clear the sync list
    // requery to make sure sync is empty
    // get all records from interviews from server
    // delete interviews
    // import records to interviews
    setState(() {
      _message += '\n Sync from server to device not supported yet ';
    });
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

  Future<String> _syncOneInterview(InterviewDetails syncItem) async {
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
      setState(() {
        _message += sreturn + "\n";
      });
      throw Exception(sreturn);
    }

    return sreturn;
  }
}

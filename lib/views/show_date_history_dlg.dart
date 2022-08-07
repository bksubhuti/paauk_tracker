import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';

class SecondRoute extends StatelessWidget {
  SecondRoute({String? iDCode, Key? key}) : super(key: key);
  final dbService = InterviewQueries();
  final iDCode = 'de8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of History'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: FutureBuilder<List<KutiGroup>>(
            future: dbService.getInterviewDatesByID(iDCode, Prefs.sayadawgyi),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title:
                            ColoredText("${snapshot.data![index].stime} test ",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: (Prefs.lightThemeOn)
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                )),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

Future<void> showDateHistoryDialog(
    BuildContext context, String iDCode, String dhammaName) async {
  final dbService = InterviewQueries();

  return showDialog<void>(
    context: context,
    //barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Date History for $dhammaName'),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: FutureBuilder<List<KutiGroup>>(
                future:
                    dbService.getInterviewDatesByID(iDCode, Prefs.sayadawgyi),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: ColoredText(snapshot.data![index].stime,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: (Prefs.lightThemeOn)
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                )),
                          ),
                        );
                      });
                }),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

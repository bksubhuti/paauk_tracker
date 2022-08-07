import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

// import 'package:paauk_tracker/src/models/resident_details.dart';
///import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/views/show_date_history_dlg.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map data = {};
  int dummy = 0;
  final dbService = InterviewQueries();
  DateTime _dt = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //dbService.dispose();
    _controller.dispose();
    super.dispose();
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // make sure there are no lingering keyboards when this page is shown
    //FocusScope.of(context).unfocus();
    final teacherImage = Prefs.sayadawgyi
        ? "assets/pa_auk_sayadawgyi.png"
        : "assets/sayadaw_kumarabhivamsa.png";

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
        child: Column(children: <Widget>[
          Center(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              backgroundImage: AssetImage(teacherImage),
              radius: 50.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ColoredText("${_dt.day}/${_dt.month}/${_dt.year}",
                      style: const TextStyle(
                        fontSize: 25,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text("<<"),
                        onPressed: () async {
                          setState(() {
                            _dt = DateTime(_dt.year, _dt.month, _dt.day - 1);
                            dummy++;
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        child: const Text(">>"),
                        onPressed: () async {
                          setState(() {
                            _dt = DateTime(_dt.year, _dt.month, _dt.day + 1);
                            dummy++;
                          });
                        },
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: FutureBuilder<List<KutiGroup>>(
                        future: dbService.getInterviewDetailsByDate(
                            _dt, Prefs.sayadawgyi),
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
                                    onTap: () {
                                      showDateHistoryDialog(
                                        context,
                                        snapshot.data![index].id_code,
                                        snapshot.data![index].dhamma_name,
                                      );
                                      /*
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SecondRoute()),
                                      );
                                      */
                                    },
                                    title: ColoredText(
                                        "${snapshot.data![index].dhamma_name}, ${snapshot.data![index].kuti} ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: (Prefs.lightThemeOn)
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                        )),
                                    subtitle: ColoredText(
                                        snapshot.data![index].country +
                                            "," +
                                            snapshot.data![index].country),
                                  ),
                                );
                              });
                        }),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}

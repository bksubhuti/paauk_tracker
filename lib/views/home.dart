import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

// import 'package:paauk_tracker/src/models/resident_details.dart';
///import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/views/sign_in_view.dart';
import 'package:paauk_tracker/views/show_date_history_dlg.dart';
import 'package:paauk_tracker/src/widgets/yogi_avatar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  int dummy = 0;
  int _counter = 1;
  final dbService = InterviewQueries();

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
          Prefs.sayadawgyi
              ? const ColoredText("Sayadawgyi",
                  style: TextStyle(fontSize: 50, letterSpacing: 2))
              : const ColoredText("Sayadaw Kumarabhivamsa",
                  style: TextStyle(fontSize: 20, letterSpacing: 2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ColoredText("Interview",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              (1 > 0) // later this will be the male female sign to show.
                  ? //Text('\ud83d\udee1')
                  Icon(Icons.health_and_safety_outlined,
                      color: Theme.of(context).colorScheme.primary)
                  : const Text(""),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FloatingActionButton.extended(
                    label: const Text('Sign In'),
                    icon: const Icon(Icons.app_registration),
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInView()),
                      );
                      setState(() {
                        dummy++;
                      });
                    },
                  ),
                  SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: FutureBuilder<List<InterviewDetails>>(
                        future: dbService.getInterviewDetails(
                            dummy, Prefs.sayadawgyi),
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
                                final adjustedName =
                                    snapshot.data![index].dhamma_name != "n/a"
                                        ? snapshot.data![index].dhamma_name
                                        : snapshot.data![index].passport_name;

                                return Card(
                                  child: ListTile(
                                      leading: YogiCircleAvatar(
                                          yogiID:
                                              snapshot.data![index].id_code),
                                      title: ColoredText(
                                          "(${snapshot.data!.length - index}) $adjustedName",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: (Prefs.lightThemeOn)
                                                ? Theme.of(context).primaryColor
                                                : Colors.white,
                                          )),
                                      subtitle: ColoredText(
                                          "${snapshot.data![index].kuti},  ${snapshot.data![index].country}"),
                                      onLongPress: () {
                                        final adjustedName = snapshot
                                                    .data![index].dhamma_name !=
                                                "n/a"
                                            ? snapshot.data![index].dhamma_name
                                            : snapshot
                                                .data![index].passport_name;

                                        _showDeleteItemDialog(
                                            snapshot.data![index].id_code,
                                            adjustedName,
                                            snapshot.data![index].kuti,
                                            snapshot.data![index].country);
                                      },
                                      onTap: () {
                                        final adjustedName = snapshot
                                                    .data![index].dhamma_name !=
                                                "n/a"
                                            ? snapshot.data![index].dhamma_name
                                            : snapshot
                                                .data![index].passport_name;

                                        showDateHistoryDialog(
                                          context,
                                          snapshot.data![index].id_code,
                                          adjustedName,
                                        );
                                      }),
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

  Future<void> _showDeleteItemDialog(
      String iDCode, String name, String kuti, String country) async {
    final iq = InterviewQueries();
    bool _isLocked = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.delete,
                size: 50,
                color: Color.fromARGB(255, 69, 8, 3),
              ),
              ColoredText("Are You Sure Delete?",
                  style: TextStyle(
                    fontSize: 24,
                    color: (Prefs.lightThemeOn)
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  )),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 20),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  obscureText: true,
                  style: TextStyle(
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      fontSize: 15),
                  decoration: const InputDecoration(
                      labelText: "Delete Code", border: OutlineInputBorder()),
                  onChanged: (String data) async {
                    _isLocked = data != "5656";
                  },
                ),
                const SizedBox(height: 20),
                ColoredText(name,
                    style: TextStyle(
                      fontSize: 24,
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )),
                ColoredText("Kuti = $kuti",
                    style: TextStyle(
                      fontSize: 17,
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )),
                ColoredText("$country ",
                    style: TextStyle(
                      fontSize: 17,
                      color: (Prefs.lightThemeOn)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              onPressed: () async {
                _isLocked = true;
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              onPressed: () async {
                if (!_isLocked) {
                  await iq.deleteInterviewRecord(iDCode, Prefs.sayadawgyi);
                }
                setState(() {
                  dummy++;
                });
                _isLocked = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

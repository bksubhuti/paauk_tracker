import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/interview_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

// import 'package:paauk_tracker/src/models/resident_details.dart';
///import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/views/sign_in_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  int dummy = 0;
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
        child: Column(children: <Widget>[
          Center(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              backgroundImage: const AssetImage("assets/pa_auk_sayadawgyi.png"),
              radius: 50.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const ColoredText("Sayadawgyi",
              style: TextStyle(fontSize: 50, letterSpacing: 2)),
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
                  ElevatedButton(
                    child: const Text('Sign In'),
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
                        future: dbService.getInterviewDetails(dummy),
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

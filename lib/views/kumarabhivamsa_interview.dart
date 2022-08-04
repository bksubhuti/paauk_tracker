import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

import 'package:paauk_tracker/views/sign_in_view.dart';

class KumarabhivamsaInterview extends StatefulWidget {
  const KumarabhivamsaInterview({Key? key}) : super(key: key);

  @override
  _KumarabhivamsaInterviewState createState() =>
      _KumarabhivamsaInterviewState();
}

class _KumarabhivamsaInterviewState extends State<KumarabhivamsaInterview> {
  Map data = {};

  final List<String> _kutiGroupItems = <String>[];

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

  _addKutiGroupItemsToMemberList() {
    if (_kutiGroupItems.isEmpty) {
      _kutiGroupItems.add("A");
      _kutiGroupItems.add("B");
      _kutiGroupItems.add("C");
      _kutiGroupItems.add("D");
      _kutiGroupItems.add("E");
      _kutiGroupItems.add("F");
      _kutiGroupItems.add("G");
      _kutiGroupItems.add("H");
      _kutiGroupItems.add("I");
      _kutiGroupItems.add("J");
      _kutiGroupItems.add("K");
      _kutiGroupItems.add("L");
      _kutiGroupItems.add("M");
      _kutiGroupItems.add("4");
      _kutiGroupItems.add("2");
      _kutiGroupItems.add("AKK");
      _kutiGroupItems.add("GL");
      _kutiGroupItems.add("ILBC");
      _kutiGroupItems.add("TL");
      _kutiGroupItems.add("TTW");
    }
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // make sure there are no lingering keyboards when this page is shown
    _addKutiGroupItemsToMemberList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
        child: Column(children: <Widget>[
          Center(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              backgroundImage:
                  const AssetImage("assets/sayadaw_kumarabhivamsa.png"),
              radius: 50.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const ColoredText("Sayadaw Kumarabhivamsa",
              style: TextStyle(fontSize: 38, letterSpacing: 2)),
          const Divider(
            height: 20.0,
          ),
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
          const SizedBox(height: 10.0),
          Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  Card(
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        children: [
                          const SizedBox(height: 6.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    child: const Text('Sign In'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInView()),
                      );
                    },
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}

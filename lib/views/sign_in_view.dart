import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/widgets/yogi_avatar.dart';

import '../src/widgets/kuti_group_selector/kuti_group_selector.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final dbService = GetResidentDetails();

  String searchKey = "A";

  final List<String> _kutiGroupItems = <String>[];

  @override
  void initState() {
    // debug mode to reset
    //Prefs.instance.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //dbService.dispose();
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

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _addKutiGroupItemsToMemberList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: const [
                      SizedBox(height: 6.0),
                      ColoredText(
                          "Select Kuṭi Group: ကျောင်းအုပ်စု ရွေးချယ်ပါ-",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 10.0,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              KutiGroupSelector(
                kutiGroupItems: _kutiGroupItems,
                onTap: (kutiGroup) {
                  setState(() {
                    searchKey = kutiGroup;
                  });
                  debugPrint("Tapped $kutiGroup");
                },
              ),
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: FutureBuilder<List<ResidentDetails>>(
                    future: dbService.getResidentDetails(searchKey),
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
                                    yogiID: snapshot.data![index].id_code),
                                onTap: () async {
                                  await _showSignInDialog(
                                      snapshot.data![index].id_code,
                                      snapshot.data![index].dhamma_name,
                                      snapshot.data![index].kuti,
                                      snapshot.data![index].country);
                                  Navigator.of(context).pop();
                                }, // on tap
                                title: ColoredText(snapshot.data![index].kuti,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: (Prefs.lightThemeOn)
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                    )),
                                subtitle: ColoredText(
                                    "$adjustedName,  ${snapshot.data![index].country}",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: (Prefs.lightThemeOn)
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                    )),
                              ),
                            );
                          });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSignInDialog(
      String iDCode, String name, String kuti, String country) async {
    final iq = InterviewQueries();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.how_to_reg,
                size: 50,
                color: Colors.red,
              ),
              ColoredText("Sign In",
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
                YogiCircleAvatar(yogiID: iDCode),
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
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_box),
              label: const Text('Approve'),
              onPressed: () async {
                await iq.addInterviewRecord(iDCode, Prefs.sayadawgyi);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

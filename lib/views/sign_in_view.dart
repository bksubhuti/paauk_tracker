import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/services/interview_queries.dart';
import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final dbService = GetResidentDetails();

  String searchKey = "A";

  String _kutiGroup = 'AKK';

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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back!'),
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      const SizedBox(height: 6.0),
                      const ColoredText("Kuti Group:",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      const SizedBox(
                        width: 10.0,
                        height: 20,
                      ),
                      DropdownButton<String>(
                          value: _kutiGroup,
                          style: TextStyle(
                            color: (Prefs.lightThemeOn)
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              _kutiGroup = newValue!;
                              searchKey = newValue;

                              //                                _dawnMethodItems.indexOf(newValue!);
                            });
                          },
                          items: _kutiGroupItems.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: ColoredText(
                                  value,
                                  style: TextStyle(
                                      color: (Prefs.lightThemeOn)
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ).toList()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                style: TextStyle(
                    color: (Prefs.lightThemeOn)
                        ? Theme.of(context).primaryColor
                        : null,
                    fontSize: 20),
                decoration: const InputDecoration(
                    labelText: "Search For Kuti",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                controller: controller,
                onChanged: (String data) {
                  setState(() {
                    searchKey = data;
                  });
                  //  print(data);
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
                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  await _showSignInDialog(
                                      snapshot.data![index].id_code,
                                      snapshot.data![index].dhamma_name,
                                      snapshot.data![index].kuti,
                                      snapshot.data![index].country);
                                  Navigator.of(context).pop();
                                }, // on tap
                                title: ColoredText(
                                    "${snapshot.data![index].kuti}, ${snapshot.data![index].country} ",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: (Prefs.lightThemeOn)
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                    )),
                                subtitle: ColoredText(
                                    snapshot.data![index].dhamma_name +
                                        "," +
                                        snapshot.data![index].country),
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
          title: const Text('Sign In'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () async {
                await iq.addInterviewRecord(iDCode);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

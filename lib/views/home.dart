import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

import 'package:paauk_tracker/src/models/resident_details.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  final dbService = DatabaseService();
  String searchKey = "A";
  String _kutiGroup = 'AKK';

  final List<String> _kutiGroupItems = <String>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dbService.dispose();
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

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // make sure there are no lingering keyboards when this page is shown
    FocusScope.of(context).unfocus();
    _addKutiGroupItemsToMemberList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
        child: Column(children: <Widget>[
          Center(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              backgroundImage: const AssetImage("assets/paauk_logo.png"),
              radius: 50.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ColoredText("Sayadawgyi",
              style: const TextStyle(fontSize: 60, letterSpacing: 2)),
          const Divider(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ColoredText("Interview",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
              (1 > 0) // later this will be the male female sign to show.
                  ? //Text('\ud83d\udee1')
                  Icon(Icons.health_and_safety_outlined,
                      color: Theme.of(context).colorScheme.primary)
                  : const Text(""),
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
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
                              items:
                                  _kutiGroupItems.map<DropdownMenuItem<String>>(
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
                    decoration: InputDecoration(
                        labelText: "Search For Kuti",
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    controller: _controller,
                    onChanged: (String data) {
                      setState(() {
                        searchKey = data;
                      });
                      //  print(data);
                    },
                  ),
                  FutureBuilder<List<ResidentDetails>>(
                      future: dbService.getResidentDetails(searchKey),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    //Prefs.cityName = snapshot.data![index].cityAscii;
                                    //Prefs.lat = snapshot.data![index].lat;
                                    //Prefs.lng = snapshot.data![index].lng;
                                    //widget.goToHome();
                                  },
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
                      })
                ],
              )),
        ]),
      ),
    );
  }
}

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

  String _kutiGroup = 'A';

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
    int idx = 0;

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
                      ), /*
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
                          ).toList()),*/
                    ],
                  ),
                ),
              ),
              /*
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
              ),*/
              SizedBox(
                height: 200,
                child: GridView.builder(
                  //physics: NeverScrollableScrollPhysics(),
                  //shrinkWrap: true,
                  // padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 2,
                  ),
                  itemCount: _kutiGroupItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      width: 70,
                      child: Card(
                        child: ListTile(
                          title: ColoredText("${_kutiGroupItems[index]}",
                              style: TextStyle(
                                fontSize: 12,
                                color: (Prefs.lightThemeOn)
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                              )),
                          // onTap: () => _onTapCallback(book)
                        ),
                      ),
                    );
                  },
                ),
              )
              /*
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[0]}'!;
                            searchKey = '${_kutiGroupItems[0]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[1]}'!;
                            searchKey = '${_kutiGroupItems[1]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[2]}'!;
                            searchKey = '${_kutiGroupItems[2]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[3]}'!;
                            searchKey = '${_kutiGroupItems[3]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[4]}'!;
                            searchKey = '${_kutiGroupItems[4]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[5]}'!;
                            searchKey = '${_kutiGroupItems[5]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[6]}'!;
                            searchKey = '${_kutiGroupItems[6]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[7]}'!;
                            searchKey = '${_kutiGroupItems[7]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[8]}'!;
                            searchKey = '${_kutiGroupItems[8]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[9]}'!;
                            searchKey = '${_kutiGroupItems[9]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[10]}'!;
                            searchKey = '${_kutiGroupItems[10]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[11]}'!;
                            searchKey = '${_kutiGroupItems[11]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[12]}'!;
                            searchKey = '${_kutiGroupItems[12]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[13]}'!;
                            searchKey = '${_kutiGroupItems[13]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[14]}'!;
                            searchKey = '${_kutiGroupItems[14]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[15]}'!;
                            searchKey = '${_kutiGroupItems[15]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[16]}'!;
                            searchKey = '${_kutiGroupItems[16]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[17]}'!;
                            searchKey = '${_kutiGroupItems[17]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[18]}'!;
                            searchKey = '${_kutiGroupItems[18]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 80,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _kutiGroup = '${_kutiGroupItems[19]}'!;
                            searchKey = '${_kutiGroupItems[19]}';
                          });
                        },
                        title: Text('${_kutiGroupItems[idx++]}'),
                      ),
                    ),
                  ),
                ],
              ),*/
              ,
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

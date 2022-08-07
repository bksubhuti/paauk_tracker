import 'package:flutter/material.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/services/get_resident_details.dart';
import 'package:paauk_tracker/src/models/prefs.dart';

class SignInView2 extends StatefulWidget {
  const SignInView2({Key? key}) : super(key: key);

  @override
  State<SignInView2> createState() => _SignInView2State();
}

class _SignInView2State extends State<SignInView2> {
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ),
            const SizedBox(
              width: 10.0,
              height: 20,
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
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue.shade900,
                      child: const Text('AH')),
                  label: const Text('Hamilton'),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue.shade900,
                      child: const Text('ML')),
                  label: const Text('Lafayette'),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue.shade900,
                      child: const Text('HM')),
                  label: const Text('Mulligan'),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.blue.shade900,
                      child: const Text('JL')),
                  label: const Text('Laurens'),
                ),
              ],
            ),
            SizedBox(
              height: 240,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _kutiGroupItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 77,
                      height: 30,
                      child: Card(
                        child: ListTile(
                          onTap: () async {}, // on tap
                          title: ColoredText("${_kutiGroupItems[index]} ",
                              style: TextStyle(
                                fontSize: 15,
                                color: (Prefs.lightThemeOn)
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                              )),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Headline',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
            ),
          ),
          Text(
            'Demo Headline 2',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx,int){
                return Card(
                  child: ListTile(
                      title: Text('Motivation $int'),
                      subtitle: Text('this is a description of the motivation')),
                );
              },
            ),
          ),
        ],
      ),
      */

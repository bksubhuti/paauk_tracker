import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'package:paauk_tracker/src/models/colored_text.dart';
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/provider/admin_provider.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:paauk_tracker/src/services/admin_service.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String _password = "not set";
//  final dbService = GetResidentDetails();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //dbService.dispose();
  }

/*

return Material(
      child: ChangeNotifierProvider<InitialSetupViewModel>(
        create: (context) =>
            InitialSetupViewModel(context)..setUp(isUpdateMode),
        builder: (context, child) {
          final vm = Provider.of<InitialSetupViewModel>(context);
          return Center(child: _buildHomeView(context, vm));

*/

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AdminNotifier>(
        create: (context) => AdminNotifier(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Screen'),
          ),
          body: Consumer<AdminNotifier>(builder: (context, adminModel, child) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Card(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          elevation: 2),
                      SizedBox(
                        height: 90,
                        width: 300,
                        child: TextField(
                            obscureText: true,
                            style: TextStyle(
                                color: (Prefs.lightThemeOn)
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                fontSize: 15),
                            decoration: const InputDecoration(
                                labelText: "Server Passcode",
                                border: OutlineInputBorder()),
                            onChanged: (String data) async {
                              _password = data;
                            }),
                      ),
                      ElevatedButton(
                        child: const Text('Share DB'),
                        onPressed: () async {
                          var databasePath = await getDatabasesPath();
                          String path = join(databasePath, 'paauk_tracker.db');
                          final List<String> sl = [path];
                          final box = context.findRenderObject() as RenderBox?;

                          await Share.shareFiles(sl,
                              text: "Share DB",
                              subject: "Pa-Auk Tracker",
                              sharePositionOrigin:
                                  box!.localToGlobal(Offset.zero) & box.size);
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text('Share CSV'),
                        onPressed: () async {
                          AdminService adminService = AdminService(
                              adminNotifier: adminModel, password: _password);
                          adminService.writeCSVFile();
                          var databasePath = await getDatabasesPath();
                          String path = join(databasePath, 'paauk_tracker.csv');
                          final List<String> sl = [path];
                          final box = context.findRenderObject() as RenderBox?;

                          await Share.shareFiles(sl,
                              text: "Share DB",
                              subject: "Pa-Auk Tracker",
                              sharePositionOrigin:
                                  box!.localToGlobal(Offset.zero) & box.size);
                        },
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        heroTag: "getResidentData",
                        label: const Text('Get Resident Data'),
                        icon: const Icon(Icons.people),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        onPressed: () async {
                          AdminService adminService = AdminService(
                              adminNotifier: adminModel, password: _password);

                          adminModel.downloading = true;
                          await adminService.fetchResidentSQL();
                          // await dbService.makeKutiSort();
                          setState(() {
                            adminModel.downloading = false;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        heroTag: "syncInterviews",
                        label: const Text('Sync Interviews'),
                        icon: const Icon(Icons.sync),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        onPressed: () async {
                          AdminService adminService = AdminService(
                              adminNotifier: adminModel, password: _password);

                          adminService.syncInterviews(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton.extended(
                        heroTag: "getPhotoZip",
                        label: const Text('Get Saṅgha Photo Zip File'),
                        icon: const Icon(Icons.photo_album),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        onPressed: () async {
                          AdminService adminService = AdminService(
                              adminNotifier: adminModel, password: _password);

                          //final myAlbum = await fetchAlbum();
                          await adminService.getZipFile();
                        },
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton.extended(
                        heroTag: "Add Photo",
                        label: const Text('Add Photo'),
                        icon: const Icon(Icons.photo),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        onPressed: () async {
                          _launchURL();
                        },
                      ),
                      const SizedBox(height: 60),
                      Column(
                        children: [
                          (adminModel.downloading == true)
                              ? const CircularProgressIndicator()
                              : const SizedBox.shrink(),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 300.0,
                              ),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  reverse: true,
                                  child: ColoredText(adminModel.message,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }

  _launchURL() async {
    final photourl = Uri.parse(
        'http://apply.paauksociety.org/app_interview.php?Password=$_password&upload');
    if (await canLaunchUrl(photourl)) {
      await launchUrl(photourl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

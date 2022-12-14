import 'package:paauk_tracker/views/settings_page.dart';
import 'package:paauk_tracker/views/home.dart';
import 'package:paauk_tracker/views/history.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'dart:io' show Platform;
import 'package:paauk_tracker/src/models/prefs.dart';
import 'package:paauk_tracker/src/models/colored_text.dart';

// #docregion LocalizationDelegatesImport
//import 'package:flutter_localizations/flutter_localizations.dart';

// #enddocregion LocalizationDelegatesImport
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// #enddocregion AppLocalizationsImport

class HomePageContainer extends StatefulWidget {
  const HomePageContainer({
    Key? key,
  }) : super(key: key);

  @override
  HomePageContainerState createState() => HomePageContainerState();
}

class HomePageContainerState extends State<HomePageContainer> {
  //late List<Widget> _pages;
  final bool isDesktop =
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  late PageController _pageController;
  final String title = "Pa-Auk Tracker";

  void goToHome() {
    _currentIndex = 0;
    _pageController.jumpToPage(_currentIndex);
    setState(() {});
  }

  late Home _page1;
  late History _page2;
  late SettingsPage _page5;
  //late DummyPage _dummyPage;

  int _currentIndex = 0;
  //Widget _currentPage = Home();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // these toggles always get set to false
    _page1 = const Home();
    _page2 = const History();
    _page5 = SettingsPage(goToHome: goToHome);
  }

  @override
  void dispose() {
    // cleanup the switches to always false
    // this does not get called.. but it is here anyway.
    // no dispose on exit is called. :)
    // print("set the toggles in prefs to false");
    _pageController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      //_currentPage = _pages[index];

      // need to update the state._page1.;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pa-Auk Tracker"),
        actions: [
          IconButton(
            onPressed: () {
              showHelpDialog(context);
            },
            icon: const Icon(Icons.help),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  const ColoredText("Pa-Auk Tracker",
                      style: TextStyle(
                        fontSize: 17,
                      )),
                  const SizedBox(height: 15.0),
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    backgroundImage: const AssetImage("assets/icon.png"),
                    radius: 40.0,
                  ),
                ],
              ),
            ),
            ListTile(
              title: ColoredText(AppLocalizations.of(context)!.help,
                  style: const TextStyle()),
              onTap: () {
                showHelpDialog(context);
              },
            ),
            ListTile(
              title: ColoredText(AppLocalizations.of(context)!.about,
                  style: const TextStyle()),
              onTap: () {
                showAboutDialog(context);
              },
            ),
            ListTile(
              title: ColoredText(AppLocalizations.of(context)!.licenses,
                  style: const TextStyle()),
              onTap: () {
                showLicenseDialog(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            int diffIndex = _currentIndex - index;
            diffIndex = (diffIndex < 0) ? diffIndex * -1 : diffIndex;
            setState(() => _currentIndex = index);
            if (diffIndex == 1) {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            } else {
              _pageController.jumpToPage(index);
            }
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                activeColor: Theme.of(context).bottomAppBarColor,
                title: Text(
                  "Interviews",
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontSize: 12),
                ),
                icon: Icon(Icons.self_improvement,
                    color: Theme.of(context).appBarTheme.foregroundColor)),
            BottomNavyBarItem(
                activeColor: Theme.of(context).bottomAppBarColor,
                title: Text(
                  "History",
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontSize: 12),
                ),
                icon: Icon(Icons.history,
                    color: Theme.of(context).appBarTheme.foregroundColor)),
            BottomNavyBarItem(
                activeColor: Theme.of(context).bottomAppBarColor,
                title: Text(
                  AppLocalizations.of(context)!.settings,
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontSize: 12),
                ),
                icon: Icon(Icons.settings,
                    color: Theme.of(context).appBarTheme.foregroundColor)),
//            BottomNavyBarItem(title: Text(page5), icon: Icon(Icons.more_time)),
          ]),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });

            //setState(() => _currentIndex = index);
          },
          children: <Widget>[_page1, _page2, _page5],
        ),
      ),
    );
  }

  showAboutDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context)!.ok,
        style: TextStyle(
          color: (Prefs.lightThemeOn)
              ? Theme.of(context).primaryColor
              : Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const ColoredText("About",
          style: TextStyle(
            fontSize: 15,
          )),
      content: const SingleChildScrollView(
        child: ColoredText(
            "Pa-Auk Tracker was created to help keep track of the meditation yogi's and their interviews without the need to type the data into the database from exersise books. ",
            style: TextStyle(
              fontSize: 16,
            )),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLicenseDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(AppLocalizations.of(context)!.ok,
          style: TextStyle(
            color: (Prefs.lightThemeOn)
                ? Theme.of(context).primaryColor
                : Colors.white,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog license = AlertDialog(
      title: const ColoredText("License"),
      content: const SingleChildScrollView(
        child: ColoredText(
            "This is an Open Source Project.  Licenses for the Flutter and Flutter development Packages used here are found on the repository website\n\n"
            ''' https://github.com/bksubhuti/paauk_tracker/  

            and
            
             https://github.com/flutter/flutter/blob/master/LICENSE '''
            "\n\n"
            '''
External Packages used:  (see pub.dev)

  path_provider: ^2.0.2
  https://pub.flutter-io.cn/packages/path_provider

  sqflite_common_ffi: ^2.0.0+1
  https://pub.flutter-io.cn/packages/sqflite_common_ffi

  sqflite: ^2.0.0+3
  https://pub.flutter-io.cn/packages/sqflite

  shared_preferences: ^2.0.6
  https://pub.flutter-io.cn/packages/shared_preferences

  bottom_navy_bar: ^6.0.0
  https://pub.flutter-io.cn/packages/bottom_navy_bar



''',
            style: TextStyle(
              fontSize: 16,
            )),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return license;
      },
    );
  }

  showHelpDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(AppLocalizations.of(context)!.ok,
          style: TextStyle(
            color: (Prefs.lightThemeOn)
                ? Theme.of(context).primaryColor
                : Colors.white,
          )),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog help = AlertDialog(
      title: ColoredText(AppLocalizations.of(context)!.help),
      content: const SingleChildScrollView(
        child: ColoredText("Ask someone for help",
            style: TextStyle(
              fontSize: 16,
            )),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return help;
      },
    );
  }
}

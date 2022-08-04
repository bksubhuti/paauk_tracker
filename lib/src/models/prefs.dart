// import to copy////////////////////
//import 'package:paauk_tracker/src/models/prefs.dart';

// Shared prefs package import
import 'package:shared_preferences/shared_preferences.dart';

// preference names
const String litLocaleVal = "localeVal";
const String litThemeIndex = "themeIndex";
const String litLightThemeOn = "lightThemeOn";
const String litLocked = "locked";
const String litSayadawgyi = "saydawgyi";

// default pref values
const int defaultLocaleVal = 0;
const int defaultThemeIndex = 24;
const bool defaultLightThemeOn = true;
const bool defaultLocked = true;
const bool defaultSaydawgyi = true;

class Prefs {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  // get and set the default member values if null
  static int get localeVal => instance.getInt(litLocaleVal) ?? defaultLocaleVal;
  static set localeVal(int value) => instance.setInt(litLocaleVal, value);

  static int get themeIndex =>
      instance.getInt(litThemeIndex) ?? defaultThemeIndex;
  static set themeIndex(int value) => instance.setInt(litThemeIndex, value);

  static bool get lightThemeOn =>
      instance.getBool(litLightThemeOn) ?? defaultLightThemeOn;
  static set lightThemeOn(bool value) =>
      instance.setBool(litLightThemeOn, value);

  static bool get locked => instance.getBool(litLocked) ?? defaultLocked;
  static set locked(bool value) => instance.setBool(litLocked, value);

  static bool get sayadawgyi =>
      instance.getBool(litSayadawgyi) ?? defaultLocked;
  static set sayadawgyi(bool value) => instance.setBool(litSayadawgyi, value);
}

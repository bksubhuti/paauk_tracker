// import to copy////////////////////
//import 'package:paauk_tracker/src/models/prefs.dart';

// Shared prefs package import
import 'package:shared_preferences/shared_preferences.dart';

// preference names
const String litCityName = "cityName";
const String litLat = "lat";
const String litLng = "lng";
const String litOffset = "offset";
const String litSpeakIsOn = "speakIsOn";
const String litScreenAlwaysOn = "screenAlwaysOn";
const String litBackgroundOn = "backgroundOn";
const String litVolume = "volume";
const String litSafety = "safety";
const String litDawnVal = "dawnVal";
const String litRetrieveCityName = "retrieveCityName";
const String litLocaleVal = "localeVal";
const String litThemeIndex = "themeIndex";
const String litLightThemeOn = "lightThemeOn";

// default pref values
const String defaultCityName = "Not Set";
const double defaultLat = 1.1;
const double defaultLng = 1.1;
const double defaultOffset = 6.5;
const bool defaultSpeakIsOn = false;
const bool defaultScreenAlwaysOn = false;
const bool defaultBackgroundOn = false;
const double defaultBackground = 0.5;
const int defualtSafety = 1;
const int defaultDawnVal = 1;
const bool defaultRetreiveCityName = true;
const int defaultLocaleVal = 0;
const int defaultThemeIndex = 24;
const bool defaultLightThemeOn = true;

class Prefs {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  // get and set the default member values if null
  static String get cityName =>
      instance.getString(litCityName) ?? defaultCityName;
  static set cityName(String value) => instance.setString(litCityName, value);

  static double get lat => instance.getDouble(litLat) ?? defaultLat;
  static set lat(double value) => instance.setDouble(litLat, value);

  static double get lng => instance.getDouble(litLng) ?? defaultLng;
  static set lng(double value) => instance.setDouble(litLng, value);

  static bool get retrieveCityName =>
      instance.getBool(litRetrieveCityName) ?? defaultRetreiveCityName;
  static set retrieveCityName(bool value) =>
      instance.setBool(litRetrieveCityName, value);

  static int get localeVal => instance.getInt(litLocaleVal) ?? defaultLocaleVal;
  static set localeVal(int value) => instance.setInt(litLocaleVal, value);

  static int get themeIndex =>
      instance.getInt(litThemeIndex) ?? defaultThemeIndex;
  static set themeIndex(int value) => instance.setInt(litThemeIndex, value);

  static bool get lightThemeOn =>
      instance.getBool(litLightThemeOn) ?? defaultLightThemeOn;
  static set lightThemeOn(bool value) =>
      instance.setBool(litLightThemeOn, value);
}

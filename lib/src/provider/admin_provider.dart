import 'package:flutter/material.dart';

class AdminNotifier extends ChangeNotifier {
  String _message = "not set";

  set message(String val) {
    _message = val;
    notifyListeners();
  }

  String get message => _message;

  bool _downloading = false;
  bool get downloading => _downloading;

  set downloading(bool val) {
    _downloading = val;
    notifyListeners();
  }
}

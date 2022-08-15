import 'package:flutter/material.dart';

class LockedDeleteNotifier extends ChangeNotifier {
  bool _isLocked = true;
  // ignore: unused_field

  set isLocked(bool val) {
    _isLocked = val;
    notifyListeners();
  }

  bool get isLocked => _isLocked;
}

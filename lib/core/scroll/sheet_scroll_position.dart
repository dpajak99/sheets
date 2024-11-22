import 'package:flutter/material.dart';

class SheetScrollPosition extends ChangeNotifier {
  SheetScrollPosition();

  SheetScrollPosition.zero();

  double _offset = 0;

  double get offset => _offset;

  set offset(double offset) {
    if (_offset == offset) {
      return;
    }
    _offset = offset;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class SheetPainterNotifier extends ChangeNotifier {
  void repaint() {
    notifyListeners();
  }
}

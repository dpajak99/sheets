import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SheetKeyboardController {
  final SheetController sheetController;

  List<LogicalKeyboardKey> activeKeys = [];

  SheetKeyboardController(this.sheetController);

  void addKey(LogicalKeyboardKey logicalKeyboardKey) {
    if (activeKeys.contains(LogicalKeyboardKey.controlLeft) && logicalKeyboardKey == LogicalKeyboardKey.keyA) {
      sheetController.selectAll();
    }
    activeKeys.add(logicalKeyboardKey);
  }

  void removeKey(LogicalKeyboardKey logicalKeyboardKey) {
    print('Released key: $logicalKeyboardKey');
    activeKeys.remove(logicalKeyboardKey);
  }

  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) {
    return activeKeys.contains(logicalKeyboardKey);
  }
}

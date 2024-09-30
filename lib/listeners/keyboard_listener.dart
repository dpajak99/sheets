import 'package:flutter/services.dart';

class SheetKeyboardListener {
  List<LogicalKeyboardKey> activeKeys = [];

  void addKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.add(logicalKeyboardKey);
  }

  void removeKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.remove(logicalKeyboardKey);
  }

  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) {
    return activeKeys.contains(logicalKeyboardKey);
  }

  bool areKeysPressed(List<LogicalKeyboardKey> keys) {
    return keys.every((key) => activeKeys.contains(key));
  }


  bool get anyKeyActive => activeKeys.isNotEmpty;
}

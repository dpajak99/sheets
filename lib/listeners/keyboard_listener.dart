import 'package:flutter/services.dart';

class SheetKeyboardListener {
  List<LogicalKeyboardKey> activeKeys = [];

  final Map<List<LogicalKeyboardKey>, Function> _keyPressedListeners = {};
  final Map<List<LogicalKeyboardKey>, Function> _keyReleasedListeners = {};

  void dispose() {
    activeKeys.clear();
  }

  void addKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.add(logicalKeyboardKey);
    _keyPressedListeners.forEach((keys, callback) {
      if (areKeysPressed(keys)) {
        callback();
      }
    });
  }

  void removeKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.remove(logicalKeyboardKey);
    _keyReleasedListeners.forEach((keys, callback) {
      if (areKeysPressed(keys)) {
        callback();
      }
    });
  }

  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) {
    return activeKeys.contains(logicalKeyboardKey);
  }

  bool areKeysPressed(List<LogicalKeyboardKey> keys) {
    return keys.every((key) => activeKeys.contains(key));
  }

  void onKeyPressed(LogicalKeyboardKey key, Function callback) {
    _keyPressedListeners[[key]] = callback;
  }

  void onKeysPressed(List<LogicalKeyboardKey> keys, Function callback) {
    _keyPressedListeners[keys] = callback;
  }

  void onKeyReleased(LogicalKeyboardKey key, Function callback) {
    _keyReleasedListeners[[key]] = callback;
  }

  void onKeysReleased(List<LogicalKeyboardKey> keys, Function callback) {
    _keyReleasedListeners[keys] = callback;
  }

  bool get anyKeyActive => activeKeys.isNotEmpty;
}

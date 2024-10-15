import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SheetKeyboardListener {
  List<int> activeKeys = <int>[];

  final Map<List<int>, Function> _keyPressedListeners = <List<int>, Function>{};
  final Map<int, Function> _keyReleasedListeners = <int, Function>{};

  void dispose() {
    activeKeys.clear();
  }

  void addKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.add(logicalKeyboardKey.keyId);
    _keyPressedListeners.forEach((List<int> keys, Function callback) {
      if (areKeyIdsPressed(keys)) {
        callback();
      }
    });
  }

  void removeKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.remove(logicalKeyboardKey.keyId);
    if(activeKeys.isNotEmpty) return;
    _keyReleasedListeners.forEach((int keys, Function callback) {
      if (keys == logicalKeyboardKey.keyId) {
        callback();
      }
    });
  }

  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) {
    return activeKeys.contains(logicalKeyboardKey.keyId);
  }

  bool areKeysPressed(List<LogicalKeyboardKey> keys) {
    List<int> checkedKeys = keys.map((LogicalKeyboardKey key) => key.keyId).toList();
    return listEquals(activeKeys, checkedKeys);
  }

  bool areKeyIdsPressed(List<int> keys) {
    return listEquals(activeKeys, keys);
  }

  void onKeyPressed(LogicalKeyboardKey key, Function callback) {
    _keyPressedListeners[<int>[key.keyId]] = callback;
  }

  void onKeysPressed(List<LogicalKeyboardKey> keys, Function callback) {
    List<int> keyIds = keys.map((LogicalKeyboardKey key) => key.keyId).toList();
    _keyPressedListeners[keyIds] = callback;
  }

  void onKeyReleased(LogicalKeyboardKey key, Function callback) {
    _keyReleasedListeners[key.keyId] = callback;
  }

  bool get anyKeyActive => activeKeys.isNotEmpty;
}

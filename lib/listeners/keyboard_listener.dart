import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class KeyHoldAction {
  final Function callback;
  final Duration interval;

  String? actionId;
  Timer? timer;

  KeyHoldAction(this.callback, this.interval);

  void invoke() {
    String newActionId = UniqueKey().toString();
    actionId = newActionId;
    callback();
    Future<void>.delayed(const Duration(milliseconds: 500)).then((_) => _repeat(newActionId));
  }

  void cancel() {
    actionId = null;
    timer?.cancel();
    timer = null;
  }

  void _repeat(String actionId) {
    if (this.actionId != actionId) {
      return cancel();
    }

    callback();
    timer = Timer(interval, () => _repeat(actionId));
  }
}

class SheetKeyboardListener {
  List<int> activeKeys = <int>[];

  final Map<List<int>, Function> _keyPressedListeners = <List<int>, Function>{};
  final Map<int, KeyHoldAction> _keyHoldListeners = <int, KeyHoldAction>{};
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

    _keyHoldListeners.forEach((int key, KeyHoldAction action) {
      if (key == logicalKeyboardKey.keyId) {
        action.invoke();
      }
    });
  }

  void removeKey(LogicalKeyboardKey logicalKeyboardKey) {
    activeKeys.remove(logicalKeyboardKey.keyId);
    _keyHoldListeners.forEach((int key, KeyHoldAction action) {
      if (key ==logicalKeyboardKey.keyId) {
        action.cancel();
      }
    });

    if (activeKeys.isEmpty) {
      _keyReleasedListeners.forEach((int keys, Function callback) {
        if (keys == logicalKeyboardKey.keyId) {
          callback();
        }
      });
    }
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

  void onKeyHold(LogicalKeyboardKey key, Function callback, {Duration interval = const Duration(milliseconds: 25)}) {
    _keyHoldListeners[key.keyId] = KeyHoldAction(callback, interval);
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

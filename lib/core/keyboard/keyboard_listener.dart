import 'dart:async';

import 'package:async/async.dart' show StreamGroup;
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:sheets/utils/repeat_action_timer.dart';

part 'keyboard_states.dart';

class KeyboardListener {
  final RepeatActionTimer _keyHoldTimer = RepeatActionTimer(
    startDuration: const Duration(milliseconds: 500),
    nextHoldDuration: const Duration(milliseconds: 30),
  );

  final StreamController<KeyboardState> _pressStreamController = StreamController<KeyboardState>.broadcast();
  final StreamController<KeyboardState> _releaseStreamController = StreamController<KeyboardState>.broadcast();
  final StreamController<KeyboardState> _holdStreamController = StreamController<KeyboardState>.broadcast();

  KeyboardState state = const NoKeysPressedState();
  
  bool enabled = true;
  
  void enableListener() {
    enabled = true;
  }
  
  void disableListener() {
    enabled = false;
  }

  void addKey(LogicalKeyboardKey logicalKeyboardKey) {
    KeyboardState previousState = state;
    state = previousState._addKey(logicalKeyboardKey);

    if(enabled) {
      _pressStreamController.add(state);
    }
    
    _keyHoldTimer.start(() => _holdStreamController.add(state));
  }

  void removeKey(LogicalKeyboardKey logicalKeyboardKey) {
    KeyboardState previousState = state;
    state = previousState._removeKey(logicalKeyboardKey);
    
    if(enabled) {
      _releaseStreamController.add(state);
    }
    
    _keyHoldTimer.reset();
  }

  bool equals(KeyboardState other) {
    return state == other;
  }

  Stream<KeyboardState> get pressStream => _pressStreamController.stream;

  Stream<KeyboardState> get releaseStream => _releaseStreamController.stream;

  Stream<KeyboardState> get holdStream => _holdStreamController.stream;

  Stream<KeyboardState> get pressOrHoldStream {
    return StreamGroup.merge<KeyboardState>(
      <Stream<KeyboardState>>[
        _pressStreamController.stream,
        _holdStreamController.stream,
      ],
    );
  }

  Future<void> dispose() async {
    await _pressStreamController.close();
    await _releaseStreamController.close();
    await _holdStreamController.close();
  }
}

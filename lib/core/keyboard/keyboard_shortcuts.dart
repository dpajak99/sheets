import 'package:flutter/services.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';

//ignore_for_file: always_specify_types
class KeyboardShortcuts {
  static const KeyboardState selectAll = MultiKeysPressedState([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyA]);
  static const KeyboardState appendSelection = SingleKeyPressedState(LogicalKeyboardKey.controlLeft);
  static const KeyboardState modifySelection = SingleKeyPressedState(LogicalKeyboardKey.shiftLeft);
  static const KeyboardState modifyAppendSelection = MultiKeysPressedState([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft]);

  static const KeyboardState moveUp = SingleKeyPressedState(LogicalKeyboardKey.arrowUp);
  static const KeyboardState moveDown = SingleKeyPressedState(LogicalKeyboardKey.arrowDown);
  static const KeyboardState moveLeft = SingleKeyPressedState(LogicalKeyboardKey.arrowLeft);
  static const KeyboardState moveRight = SingleKeyPressedState(LogicalKeyboardKey.arrowRight);

  static const KeyboardState addRows = SingleKeyPressedState(LogicalKeyboardKey.keyR);
  static const KeyboardState addColumns = SingleKeyPressedState(LogicalKeyboardKey.keyC);

  static const KeyboardState reverseScroll = SingleKeyPressedState(LogicalKeyboardKey.shiftLeft);
}
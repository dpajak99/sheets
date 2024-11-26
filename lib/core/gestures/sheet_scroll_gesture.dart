import 'package:flutter/services.dart';
import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';

class SheetScrollGesture extends SheetGesture {
  SheetScrollGesture(this.delta);

  final Offset delta;

  @override
  void resolve(SheetController controller) {
    HardwareKeyboard keyboard = HardwareKeyboard.instance;

    if (keyboard.isShiftPressed) {
      controller.scroll.scrollBy(delta.reverse());
    } else {
      controller.scroll.scrollBy(delta);
    }
  }

  @override
  List<Object?> get props => <Object?>[delta];
}

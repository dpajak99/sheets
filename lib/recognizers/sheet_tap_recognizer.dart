import 'package:flutter/material.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/gestures/sheet_tap_gesture.dart';

class SheetTapRecognizer {
  SheetTapDetails _lastTap = SheetTapDetails.create(Offset.zero);

  SheetGesture onTap(SheetTapDetails details) {
    bool isDoubleTap = _lastTap.isDoubleTap(details);
    _lastTap = details;

    if (isDoubleTap) {
      return SheetDoubleTapGesture(details);
    } else {
      return SheetTapGesture(details);
    }
  }
}
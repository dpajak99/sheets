import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SheetCursor extends ValueNotifier<SystemMouseCursor> {
  SheetCursor._() : super(SystemMouseCursors.basic);

  bool isPressed = false;

  static final SheetCursor instance = SheetCursor._();
}

import 'package:flutter/material.dart';
import 'package:sheets/gestures/sheet_gesture.dart';

class SheetScrollGesture extends SheetGesture {
  final Offset delta;

  SheetScrollGesture(this.delta);

  @override
  List<Object?> get props => [delta];
}

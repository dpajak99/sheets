import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_fill_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/gestures/sheet_scroll_gesture.dart';
import 'package:sheets/core/sheet_item_config.dart';

class SheetMouseListener {
  final StreamController<SheetGesture> _gesturesStream = StreamController<SheetGesture>();

  Stream<SheetGesture> get stream => _gesturesStream.stream;

  final ValueNotifier<Offset> mousePosition = ValueNotifier(Offset.zero);
  final ValueNotifier<SheetItemConfig?> hoveredItem = ValueNotifier(null);
  final ValueNotifier<SystemMouseCursor> cursor = ValueNotifier(SystemMouseCursors.basic);

  bool _enabled = true;

  void disable() => _enabled = false;

  void enable() => _enabled = true;

  bool get enabled => _enabled;

  bool nativeDragging = false;
  bool customTapHovered = false;

  void dispose() {
    _gesturesStream.close();
  }

  void updateOffset(Offset offset, SheetItemConfig? element) {
    mousePosition.value = offset;
    hoveredItem.value = element;
  }

  void setCursor(SystemMouseCursor cursor) {
    this.cursor.value = cursor;
  }

  SheetDragDetails? _activeStartDragDetails;

  void dragStart(SheetItemConfig draggedItem) {
    nativeDragging = true;
    _activeStartDragDetails = SheetDragDetails.create(mousePosition.value, draggedItem);
    _addGesture(SheetDragStartGesture(_activeStartDragDetails!));
  }

  void dragUpdate() {
    if (nativeDragging && _activeStartDragDetails != null) {
      _addGesture(SheetDragUpdateGesture(
        SheetDragDetails.create(mousePosition.value, hoveredItem.value),
        startDetails: _activeStartDragDetails!,
      ));
    }
  }

  void dragEnd() {
    nativeDragging = false;
    _activeStartDragDetails = null;

    _addGesture(SheetDragEndGesture());
  }

  void fillStart() {
    SheetFillStartGesture fillStartGesture = SheetFillStartGesture();
    _gesturesStream.add(fillStartGesture);
  }

  void fillUpdate() {
    SheetGesture fillUpdateGesture = SheetFillUpdateGesture(endDetails: SheetDragDetails.create(mousePosition.value, hoveredItem.value));
    _gesturesStream.add(fillUpdateGesture);
  }

  void fillEnd() {
    SheetFillEndGesture fillEndGesture = SheetFillEndGesture();
    _gesturesStream.add(fillEndGesture);
  }

  void scroll(Offset delta) {
    _addGesture(SheetScrollGesture(delta));
  }

  void _addGesture(SheetGesture gesture) {
    if (!_enabled) return;
    _gesturesStream.add(gesture);
  }
}

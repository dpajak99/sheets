import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/utils/extensions/offset_extension.dart';

import 'dart:async';

import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/gestures/sheet_drag_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_fill_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_scroll_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_tap_gesture.dart';
import 'package:sheets/controller/selection/recognizers/sheet_tap_recognizer.dart';

class SheetMouseListener {
  final StreamController<SheetGesture> _gesturesStream = StreamController<SheetGesture>();

  Stream<SheetGesture> get stream => _gesturesStream.stream;

  final ValueNotifier<Offset> mousePosition = ValueNotifier(Offset.zero);
  final ValueNotifier<SheetItemConfig?> hoveredItem = ValueNotifier(null);
  final ValueNotifier<SystemMouseCursor> cursor = ValueNotifier(SystemMouseCursors.basic);

  final SheetTapRecognizer tapRecognizer = SheetTapRecognizer();

  bool _enabled = true;

  void disable() => _enabled = false;

  void enable() => _enabled = true;

  bool get enabled => _enabled;

  bool nativeDragging = false;
  bool customTapHovered = false;
  SheetItemConfig? _dragStartElement;

  void updateOffset(Offset offset, SheetItemConfig? element) {
    mousePosition.value = offset;
    hoveredItem.value = element;
  }

  void setCursor(SystemMouseCursor cursor) {
    this.cursor.value = cursor;
  }

  void tap() {
    if(customTapHovered) return;
    SheetGesture tapGesture = tapRecognizer.onTap(SheetTapDetails.create(mousePosition.value, hoveredItem.value));
    _addGesture(tapGesture);
  }

  SheetDragDetails? _activeStartDragDetails;

  void dragStart() {
    nativeDragging = true;
    _dragStartElement = hoveredItem.value;
    SheetDragDetails sheetDragDetails = SheetDragDetails.create(mousePosition.value, hoveredItem.value);
    _activeStartDragDetails = sheetDragDetails;
    _addGesture(SheetDragStartGesture(sheetDragDetails));
  }

  void dragUpdate() {
    if (_activeStartDragDetails == null) return;
    if (_dragStartElement == hoveredItem.value) return;

    SheetGesture dragUpdateGesture = SheetDragUpdateGesture(
      SheetDragDetails.create(mousePosition.value, hoveredItem.value),
      startDetails: _activeStartDragDetails!,
    );
    _addGesture(dragUpdateGesture);
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

  void dragEnd() {
    nativeDragging = false;
    if (_activeStartDragDetails == null) return;

    SheetGesture dragEndGesture = SheetDragEndGesture(
      SheetDragDetails.create(mousePosition.value, hoveredItem.value),
      startDetails: _activeStartDragDetails!,
    );
    _addGesture(dragEndGesture);
  }

  void scroll(Offset delta) {
    _addGesture(SheetScrollGesture(delta));
  }

  void _addGesture(SheetGesture gesture) {
    if (!_enabled) return;
    _gesturesStream.add(gesture);
  }
}

class SheetGestureDetector extends StatelessWidget {
  final ValueNotifier<SystemMouseCursor> cursorListener;
  final ValueChanged<Offset> onMouseOffsetChanged;
  final VoidCallback onTap;
  final VoidCallback onDragStart;
  final VoidCallback onDragUpdate;
  final VoidCallback onDragEnd;
  final ValueChanged<Offset> onScroll;

  const SheetGestureDetector({
    required this.cursorListener,
    required this.onMouseOffsetChanged,
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onScroll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cursorListener,
      builder: (BuildContext context, SystemMouseCursor cursor, _) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (PointerSignalEvent event) {
            if (event is PointerScrollEvent) {
              onScroll(event.scrollDelta);
            }
          },
          onPointerDown: _onDragStart,
          onPointerMove: _onDragUpdate,
          onPointerUp: _onDragEnd,
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            cursor: cursor,
            onHover: (event) => _notifyOffsetChanged(event.localPosition),
          ),
        );
      },
    );
  }

  void _onDragStart(PointerDownEvent event) {
    _notifyOffsetChanged(event.localPosition);
    onTap();
    onDragStart();
  }

  void _onDragUpdate(PointerMoveEvent event) {
    _notifyOffsetChanged(event.localPosition);
    onDragUpdate();
  }

  void _onDragEnd(PointerUpEvent event) {
    _notifyOffsetChanged(event.localPosition);
    onDragEnd();
  }

  void _notifyOffsetChanged(Offset value) {
    onMouseOffsetChanged(value.limitMin(0, 0));
  }
}

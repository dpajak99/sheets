import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/mouse/mouse_cursor_details.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/repeat_action_timer.dart';
import 'package:sheets/utils/silent_value_notifier.dart';
import 'package:sheets/utils/streamable.dart';

class MouseListener extends Streamable<SheetMouseGesture> {
  MouseListener({
    required List<MouseGestureRecognizer> mouseActionRecognizers,
    required SheetController sheetController,
  }) {
    cursor = SilentValueNotifier<SystemMouseCursor>(SystemMouseCursors.basic);

    _repeatDragUpdateTimer = RepeatActionTimer(
      startDuration: const Duration(milliseconds: 200),
      nextHoldDuration: const Duration(milliseconds: 50),
    );
    _mouseActionRecognizers = mouseActionRecognizers;
    _sheetController = sheetController;
  }

  late final SilentValueNotifier<SystemMouseCursor> cursor;

  late final RepeatActionTimer _repeatDragUpdateTimer;

  late final List<MouseGestureRecognizer> _mouseActionRecognizers;

  late final SheetController _sheetController;

  Offset _localOffset = Offset.zero;

  MouseCursorDetails? _dragStartDetails;

  @override
  void addEvent(SheetMouseGesture event) {
    super.addEvent(event);
    _resolveGesture(event);
  }

  void insertRecognizer(MouseGestureRecognizer recognizer) {
    _mouseActionRecognizers.insert(0, recognizer);
  }

  Future<void> removeRecognizer(MouseGestureRecognizer recognizer) async {
    if (recognizer.handler.isActive) {
      await recognizer.handler.future;
    }
    recognizer.handler.reset(_sheetController);
    _mouseActionRecognizers.remove(recognizer);
  }

  void setCursor(SystemMouseCursor systemMouseCursor) {
    cursor.setValue(systemMouseCursor);
  }

  void resetCursor() {
    cursor.setValue(SystemMouseCursors.basic);
  }

  void setGlobalOffset(Offset globalOffset) {
    Offset localOffset = _sheetController.viewport.globalOffsetToLocal(globalOffset);
    if (_localOffset != localOffset) {
      _localOffset = localOffset;
    }
  }

  void notifyMouseHovered(PointerHoverEvent event) {
    _updateGlobalOffset(event.position);
    addEvent(SheetMouseHoverGesture(_localOffset));
  }

  void notifyDragStarted(PointerDownEvent event) {
    _updateGlobalOffset(event.position);
    MouseCursorDetails cursorDetails = _cursorDetails;

    _dragStartDetails = cursorDetails;
    addEvent(SheetDragStartGesture(_dragStartDetails!));
  }

  void notifyDragUpdated(PointerMoveEvent event) {
    setGlobalOffset(event.position);

    if (_dragStartDetails != null) {
      _repeatDragUpdateTimer.reset();
      _repeatDragUpdateTimer.start(() => notifyDragUpdated(event));
      addEvent(SheetDragUpdateGesture(startDetails: _dragStartDetails!, updateDetails: _cursorDetails));
    }
  }

  void notifyDragEnd(PointerUpEvent event) {
    _updateGlobalOffset(event.position);
    _repeatDragUpdateTimer.reset();
    if (_dragStartDetails != null) {
      addEvent(SheetDragEndGesture(startDetails: _dragStartDetails!, endDetails: _cursorDetails));
    }
  }

  void _updateGlobalOffset(Offset position) {
    setGlobalOffset(position);
  }

  void _resolveGesture(SheetMouseGesture gesture) {
    bool activeRecognizerResolved = _resolveActiveRecognizers(gesture);
    if (!activeRecognizerResolved) {
      _resolveFirstRecognizer(gesture);
    }
  }

  bool _resolveActiveRecognizers(SheetMouseGesture gesture) {
    bool activeHandlerResolved = false;
    for (MouseGestureRecognizer recognizer in _mouseActionRecognizers) {
      MouseGestureHandler? handler = recognizer.handler;
      if (handler.isActive) {
        if (!activeHandlerResolved) {
          handler.resolve(_sheetController, gesture);
          activeHandlerResolved = true;
        } else {
          handler.reset(_sheetController);
        }
      }
    }
    return activeHandlerResolved;
  }

  void _resolveFirstRecognizer(SheetMouseGesture gesture) {
    for (MouseGestureRecognizer recognizer in _mouseActionRecognizers) {
      MouseGestureHandler? handler = recognizer.recognize(_sheetController, gesture);
      if (handler != null) {
        handler.resolve(_sheetController, gesture);
        return;
      }
    }
  }

  MouseCursorDetails get _cursorDetails {
    ViewportItem? hoveredItem = _sheetController.viewport.visibleContent.findAnyByOffset(_localOffset);

    return MouseCursorDetails(
      localOffset: _localOffset,
      scrollPosition: _sheetController.scroll.offset,
      hoveredItem: hoveredItem,
    );
  }
}

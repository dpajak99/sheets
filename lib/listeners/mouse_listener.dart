import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/recognizers/mouse_action_recognizer.dart';
import 'package:sheets/recognizers/repeat_action_timer.dart';
import 'package:sheets/utils/streamable.dart';
import 'package:sheets/viewport/viewport_item.dart';

/// A listener that handles mouse events and manages mouse gestures for the sheet.
class MouseListener extends Streamable<SheetMouseGesture> {
  /// Creates a [MouseListener] with the given [mouseActionRecognizers] and [sheetController].
  MouseListener({
    required List<MouseActionRecognizer> mouseActionRecognizers,
    required SheetController sheetController,
  }) {
    cursor = ValueNotifier<SystemMouseCursor>(SystemMouseCursors.basic);

    _repeatDragUpdateTimer = RepeatActionTimer(
      startDuration: const Duration(milliseconds: 200),
      nextHoldDuration: const Duration(milliseconds: 50),
    );
    _mouseActionRecognizers = mouseActionRecognizers;
    _sheetController = sheetController;
  }

  /// The current mouse cursor.
  late final ValueNotifier<SystemMouseCursor> cursor;

  /// Recognizer for handling pan and hold gestures.
  late final RepeatActionTimer _repeatDragUpdateTimer;

  /// List of mouse action recognizers to handle different mouse gestures.
  late final List<MouseActionRecognizer> _mouseActionRecognizers;

  /// Controller for managing the sheet state and viewport.
  late final SheetController _sheetController;

  /// The current local offset of the mouse.
  Offset _localOffset = Offset.zero;

  /// Details of the mouse cursor when a drag gesture starts.
  MouseCursorDetails? _dragStartDetails;

  @override
  void addEvent(SheetMouseGesture event) {
    super.addEvent(event);
    _resolveGesture(event);
  }

  /// Inserts a [MouseActionRecognizer] at the beginning of the list of recognizers.
  void insertRecognizer(MouseActionRecognizer recognizer) {
    _mouseActionRecognizers.insert(0, recognizer);
  }

  /// Removes a [MouseActionRecognizer] from the list of recognizers.
  Future<void> removeRecognizer(MouseActionRecognizer recognizer) async {
    if (recognizer is CustomDragRecognizer && recognizer.action.isActive) {
      await recognizer.action.future;
    }
    _mouseActionRecognizers.remove(recognizer);
  }

  /// Sets the mouse cursor to the given [systemMouseCursor].
  void setCursor(SystemMouseCursor systemMouseCursor) {
    cursor.value = systemMouseCursor;
  }

  /// Resets the mouse cursor to the basic cursor.
  void resetCursor() {
    cursor.value = SystemMouseCursors.basic;
  }

  /// Sets the global offset and updates the local offset accordingly.
  set globalOffset(Offset globalOffset) {
    Offset localOffset = _sheetController.viewport.globalOffsetToLocal(globalOffset);
    if (_localOffset != localOffset) {
      _localOffset = localOffset;
    }
  }

  /// Notifies that the mouse is hovering over the sheet at the given [event] position.
  void notifyMouseHovered(PointerHoverEvent event) {
    _updateGlobalOffset(event.position);
    addEvent(SheetMouseMoveGesture(_localOffset));
  }

  /// Notifies that a drag gesture has started at the given [event] position.
  void notifyDragStarted(PointerDownEvent event) {
    _updateGlobalOffset(event.position);
    _dragStartDetails = _cursorDetails;
    addEvent(SheetDragStartGesture(_dragStartDetails!));
  }

  /// Notifies that a drag gesture has been updated at the given [event] position.
  void notifyDragUpdated(PointerMoveEvent event) {
    globalOffset = event.position;

    if (_dragStartDetails != null) {
      _repeatDragUpdateTimer.reset();
      _repeatDragUpdateTimer.start(() => notifyDragUpdated(event));
      addEvent(SheetDragUpdateGesture(startDetails: _dragStartDetails!, updateDetails: _cursorDetails));
    }
  }

  /// Notifies that a drag gesture has ended at the given [event] position.
  void notifyDragEnd(PointerUpEvent event) {
    _updateGlobalOffset(event.position);
    _repeatDragUpdateTimer.reset();
    if (_dragStartDetails != null) {
      addEvent(SheetDragEndGesture(startDetails: _dragStartDetails!, endDetails: _cursorDetails));
    }
  }

  /// Updates the global offset to the given [position].
  void _updateGlobalOffset(Offset position) {
    globalOffset = position;
  }

  /// Resolves the given [gesture] by finding an appropriate recognizer.
  void _resolveGesture(SheetMouseGesture gesture) {
    bool activeRecognizerResolved = _resolveActiveRecognizers(gesture);
    if (!activeRecognizerResolved) {
      _resolveFirstHoveredRecognizer(gesture);
    }
  }

  /// Resolves active recognizers for the given [gesture].
  bool _resolveActiveRecognizers(SheetMouseGesture gesture) {
    bool activeRecognizerResolved = false;
    for (MouseActionRecognizer recognizer in _mouseActionRecognizers) {
      if (recognizer.action.isActive) {
        if (!activeRecognizerResolved) {
          recognizer.action.resolve(_sheetController, gesture);
          activeRecognizerResolved = true;
        } else {
          recognizer.action.reset(_sheetController);
        }
      }
    }
    return activeRecognizerResolved;
  }

  /// Resolves the first hovered recognizer for the given [gesture].
  void _resolveFirstHoveredRecognizer(SheetMouseGesture gesture) {
    for (MouseActionRecognizer recognizer in _mouseActionRecognizers) {
      MouseAction? action = recognizer.recognize(_sheetController, gesture);
      if (action != null) {
        action.resolve(_sheetController, gesture);
        return;
      }
    }
  }

  /// Gets the current mouse cursor details, including local offset, scroll position, and hovered item.
  MouseCursorDetails get _cursorDetails {
    ViewportItem? hoveredItem = _sheetController.viewport.visibleContent.findAnyByOffset(_localOffset);

    return MouseCursorDetails(
      localOffset: _localOffset,
      scrollPosition: _sheetController.scroll.offset,
      hoveredItem: hoveredItem,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';

abstract class MouseGestureRecognizer with EquatableMixin {
  MouseGestureRecognizer(this.handler);

  final MouseGestureHandler handler;

  MouseGestureHandler? recognize(SheetController controller, SheetMouseGesture gesture);
}

class MouseDoubleTapRecognizer extends MouseGestureRecognizer {
  MouseDoubleTapRecognizer() : super(MouseDoubleClickGestureHandler());

  DateTime? _lastTapTime;
  SheetIndex? _lastTapIndex;

  @override
  MouseGestureHandler? recognize(SheetController controller, SheetMouseGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => _handleTap(gesture.startDetails.hoveredItem?.index),
      _ => null,
    };
  }

  MouseGestureHandler? _handleTap(SheetIndex? currentTapIndex) {
    DateTime currentTime = DateTime.now();
    SheetIndex? lastTapIndex = _lastTapIndex;
    DateTime? lastTapTime = _lastTapTime;

    _lastTapIndex = currentTapIndex;
    _lastTapTime = currentTime;

    if (lastTapIndex == null || lastTapTime == null) {
      return null;
    } else if (currentTime.difference(lastTapTime) > const Duration(milliseconds: 500)) {
      return null;
    } else if (lastTapIndex == currentTapIndex) {
      return handler;
    } else {
      return null;
    }
  }

  @override
  List<Object?> get props => <Object?>[_lastTapTime, _lastTapIndex];
}

class MouseSelectionGestureRecognizer extends MouseGestureRecognizer {
  MouseSelectionGestureRecognizer() : super(MouseSelectionGestureHandler());

  @override
  MouseGestureHandler? recognize(SheetController controller, SheetMouseGesture gesture) => handler;

  @override
  List<Object?> get props => <Object?>[];
}

class DraggableGestureRecognizer extends MouseGestureRecognizer {
  DraggableGestureRecognizer(DraggableGestureHandler super.handler, [this.draggableArea = Rect.zero]);

  Rect draggableArea;

  @override
  MouseGestureHandler? recognize(SheetController controller, SheetMouseGesture gesture) {
    bool currentHovered = draggableArea.contains(gesture.currentOffset);
    handler.setHovered(controller, currentHovered);

    if (currentHovered) {
      return handler;
    } else {
      return null;
    }
  }

  void setDraggableArea(Rect area) {
    draggableArea = area;
  }

  @override
  DraggableGestureHandler get handler => super.handler as DraggableGestureHandler;

  @override
  List<Object?> get props => <Object?>[handler];
}

class TextfieldHoveredGestureRecognizer extends DraggableGestureRecognizer {
  TextfieldHoveredGestureRecognizer(
    TextfieldHoverGestureHandler super.handler,
  );
}

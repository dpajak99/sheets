import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';

abstract class MouseGestureRecognizer with EquatableMixin {
  final MouseGestureHandler handler;

  MouseGestureRecognizer(this.handler);

  MouseGestureHandler? recognize(SheetController controller, SheetMouseGesture gesture);
}

class MouseSelectionGestureRecognizer extends MouseGestureRecognizer {
  MouseSelectionGestureRecognizer() : super(MouseSelectionGestureHandler());

  @override
  MouseGestureHandler? recognize(SheetController controller, SheetMouseGesture gesture) => handler;

  @override
  List<Object?> get props => <Object?>[];
}

class DraggableGestureRecognizer extends MouseGestureRecognizer {
  Rect draggableArea = Rect.zero;

  DraggableGestureRecognizer(DraggableGestureHandler super.handler);

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
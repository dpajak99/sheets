import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_fill_gesture.dart';
import 'package:sheets/gestures/sheet_selection_gesture.dart';
import 'package:sheets/viewport/viewport_item.dart';

abstract class MouseActionRecognizer with EquatableMixin {
  final MouseAction action;

  MouseActionRecognizer(this.action);

  MouseAction? recognize(SheetController controller, SheetMouseGesture gesture);
}

class MouseSelectionRecognizer extends MouseActionRecognizer {
  MouseSelectionRecognizer() : super(MouseSelectionAction());

  @override
  MouseAction? recognize(SheetController controller, SheetMouseGesture gesture) => action;

  @override
  List<Object?> get props => <Object?>[];
}

class CustomDragRecognizer extends MouseActionRecognizer {
  Rect draggableArea = Rect.zero;

  CustomDragRecognizer(CustomDragAction super.action);

  @override
  MouseAction? recognize(SheetController controller, SheetMouseGesture gesture) {
    bool currentHovered = draggableArea.contains(gesture.currentOffset);
    action.setHovered(controller, currentHovered);

    if (currentHovered) {
      return action;
    } else {
      return null;
    }
  }

  void setDraggableArea(Rect area) {
    draggableArea = area;
  }

  @override
  CustomDragAction get action => super.action as CustomDragAction;

  @override
  List<Object?> get props => <Object?>[action];
}

abstract class MouseAction extends ChangeNotifier with EquatableMixin {
  Completer<void>? _completer;

  bool get isActive => _completer != null && _completer!.isCompleted == false;

  Future<void>? get future => _completer?.future;

  void setActive(bool active) {
    if (active) {
      _completer = Completer<void>();
    } else {
      _completer?.complete();
      _completer = null;
    }
    notifyListeners();
  }

  void reset(SheetController controller);

  void resolve(SheetController controller, SheetMouseGesture gesture);

  @override
  List<Object?> get props => <Object>[isActive];
}

abstract class CustomDragAction extends MouseAction {
  bool _previousHovered = false;

  bool get isHovered => _previousHovered;

  SystemMouseCursor get hoverCursor;

  void setHovered(SheetController controller, bool currentHovered) {
    if (_previousHovered == false && currentHovered) {
      setCursor(controller, hoverCursor);
    } else if (_previousHovered && currentHovered == false) {
      resetCursor(controller);
    }
    _previousHovered = currentHovered;
    notifyListeners();
  }

  void setCursor(SheetController controller, SystemMouseCursor cursor) {
    if (controller.mouse.cursor.value != cursor) {
      controller.mouse.setCursor(cursor);
    }
  }

  void resetCursor(SheetController controller) {
    if (controller.mouse.cursor.value != SystemMouseCursors.basic) {
      controller.mouse.resetCursor();
    }
  }

  @override
  List<Object?> get props => <Object>[hoverCursor, isHovered, isActive];
}

class MouseSelectionAction extends MouseAction {
  @override
  void resolve(SheetController controller, SheetMouseGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => _startSelection(controller, gesture),
      SheetDragUpdateGesture gesture => _updateSelection(controller, gesture),
      SheetDragEndGesture gesture => _endSelection(controller, gesture),
      _ => null,
    };
  }

  @override
  void reset(SheetController controller) {
    setActive(false);
  }

  void _startSelection(SheetController controller, SheetDragStartGesture gesture) {
    setActive(true);

    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    if (selectionStart == null) return;

    SheetSelectionStartGesture(selectionStart).resolve(controller);
  }

  void _updateSelection(SheetController controller, SheetDragUpdateGesture gesture) {
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    ViewportItem? selectionUpdate = gesture.updateDetails.hoveredItem;
    if (selectionStart == null || selectionUpdate == null) return;

    SheetSelectionUpdateGesture(selectionStart, selectionUpdate).resolve(controller);
  }

  void _endSelection(SheetController controller, SheetDragEndGesture gesture) {
    SheetSelectionEndGesture().resolve(controller);
    reset(controller);
  }
}

class MouseFillAction extends CustomDragAction {
  @override
  SystemMouseCursor get hoverCursor => SystemMouseCursors.precise;

  @override
  void resolve(SheetController controller, SheetMouseGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => _startFill(controller, gesture),
      SheetDragUpdateGesture gesture => _updateFill(controller, gesture),
      SheetDragEndGesture gesture => _endFill(controller, gesture),
      _ => null,
    };
  }

  @override
  void reset(SheetController controller) {
    controller.mouse.resetCursor();
    setActive(false);
    setHovered(controller, false);
  }

  void _startFill(SheetController controller, SheetDragStartGesture gesture) {
    setActive(true);
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    if (selectionStart == null) return;

    SheetFillStartGesture().resolve(controller);
    controller.mouse.setCursor(SystemMouseCursors.precise);
  }

  void _updateFill(SheetController controller, SheetDragUpdateGesture gesture) {
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    ViewportItem? selectionUpdate = gesture.updateDetails.hoveredItem;
    if (selectionStart == null || selectionUpdate == null) return;

    SheetFillUpdateGesture(selectionStart, selectionUpdate).resolve(controller);
  }

  void _endFill(SheetController controller, SheetDragEndGesture gesture) {
    SheetFillEndGesture().resolve(controller);
    reset(controller);
  }
}

class ResizeColumnMouseAction extends CustomDragAction {
  ViewportColumn viewportColumn;
  double? newWidth;

  ResizeColumnMouseAction(this.viewportColumn);

  @override
  SystemMouseCursor get hoverCursor => SystemMouseCursors.resizeColumn;

  @override
  void resolve(SheetController controller, SheetMouseGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => _startResize(controller, gesture),
      SheetDragUpdateGesture gesture => _updateResize(controller, gesture),
      SheetDragEndGesture gesture => _endResize(controller, gesture),
      _ => null,
    };
  }

  @override
  void reset(SheetController controller) {
    newWidth = null;
    setActive(false);
    setHovered(controller, false);
  }

  void _startResize(SheetController controller, SheetDragStartGesture gesture) {
    setActive(true);
    newWidth = viewportColumn.rect.width;
  }

  void _updateResize(SheetController controller, SheetDragUpdateGesture gesture) {
    double minColumnWidth = 20;

    double? maxLeft = viewportColumn.rect.left;
    double currentPosition = gesture.updateDetails.localOffset.dx;

    if (maxLeft < currentPosition - minColumnWidth) {
      newWidth = currentPosition - maxLeft;
      setCursor(controller, hoverCursor);
      notifyListeners();
    } else {
      newWidth = minColumnWidth;
      resetCursor(controller);
      notifyListeners();
    }
  }

  void _endResize(SheetController controller, SheetDragEndGesture gesture) {
    controller.resizeColumn(viewportColumn.index, newWidth!);
    _refreshColumnSize(controller);
    reset(controller);
  }

  void _refreshColumnSize(SheetController controller) {
    viewportColumn = controller.viewport.visibleContent.columns.firstWhere(
      (ViewportColumn column) => column.index == viewportColumn.index,
    );
  }
}

class ResizeRowMouseAction extends CustomDragAction {
  ViewportRow viewportRow;
  double? newHeight;

  ResizeRowMouseAction(this.viewportRow);

  @override
  SystemMouseCursor get hoverCursor => SystemMouseCursors.resizeRow;

  @override
  void resolve(SheetController controller, SheetMouseGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => _startResize(controller, gesture),
      SheetDragUpdateGesture gesture => _updateResize(controller, gesture),
      SheetDragEndGesture gesture => _endResize(controller, gesture),
      _ => null,
    };
  }

  @override
  void reset(SheetController controller) {
    newHeight = null;
    setActive(false);
    setHovered(controller, false);
  }

  void _startResize(SheetController controller, SheetDragStartGesture gesture) {
    setActive(true);
    newHeight = viewportRow.rect.height;
  }

  void _updateResize(SheetController controller, SheetDragUpdateGesture gesture) {
    double minRowHeight = 10;

    double? maxTop = viewportRow.rect.top;
    double currentPosition = gesture.updateDetails.localOffset.dy;

    if (maxTop < currentPosition - minRowHeight) {
      newHeight = currentPosition - maxTop;
      setCursor(controller, hoverCursor);
      notifyListeners();
    } else {
      newHeight = minRowHeight;
      resetCursor(controller);
      notifyListeners();
    }
  }

  void _endResize(SheetController controller, SheetDragEndGesture gesture) {
    controller.resizeRow(viewportRow.index, newHeight!);
    _refreshRowSize(controller);
    reset(controller);
    setActive(false);
  }

  void _refreshRowSize(SheetController controller) {
    viewportRow = controller.viewport.visibleContent.rows.firstWhere(
      (ViewportRow row) => row.index == viewportRow.index,
    );
  }
}
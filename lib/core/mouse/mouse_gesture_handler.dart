import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/selection/sheet_fill_gesture.dart';
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class MouseGestureHandler extends ChangeNotifier with EquatableMixin {
  Completer<void>? _completer;

  bool get isActive => _completer != null && !_completer!.isCompleted;

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

class MouseDoubleClickGestureHandler extends MouseGestureHandler {
  @override
  void resolve(SheetController controller, SheetMouseGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => _doubleTap(controller, gesture),
      _ => null,
    };
  }

  @override
  void reset(SheetController controller) {
    setActive(false);
  }

  void _doubleTap(SheetController controller, SheetDragStartGesture gesture) {
    if( gesture.startDetails.hoveredItem is! ViewportCell) {
      return;
    }
    ViewportCell cell = gesture.startDetails.hoveredItem! as ViewportCell;

    setActive(true);
    controller.setActiveViewportCell(cell);
    setActive(false);
  }
}

abstract class DraggableGestureHandler extends MouseGestureHandler {
  bool _previousHovered = false;

  bool get isHovered => _previousHovered;

  SystemMouseCursor get hoverCursor;

  void setHovered(SheetController controller, bool currentHovered) {
    if (!_previousHovered && currentHovered) {
      setCursor(controller, hoverCursor);
    } else if (_previousHovered && !currentHovered) {
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

class MouseSelectionGestureHandler extends MouseGestureHandler {
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
    if (selectionStart == null) {
      return;
    }

    SheetSelectionStartGesture(selectionStart).resolve(controller);
  }

  void _updateSelection(SheetController controller, SheetDragUpdateGesture gesture) {
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    ViewportItem? selectionUpdate = gesture.updateDetails.hoveredItem;
    if (selectionStart == null || selectionUpdate == null) {
      return;
    }

    SheetSelectionUpdateGesture(selectionStart, selectionUpdate).resolve(controller);
  }

  void _endSelection(SheetController controller, SheetDragEndGesture gesture) {
    SheetSelectionEndGesture().resolve(controller);
    reset(controller);
  }
}

class MouseFillGestureHandler extends DraggableGestureHandler {
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
    if (selectionStart == null) {
      return;
    }

    SheetFillStartGesture().resolve(controller);
    controller.mouse.setCursor(SystemMouseCursors.precise);
  }

  void _updateFill(SheetController controller, SheetDragUpdateGesture gesture) {
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    ViewportItem? selectionUpdate = gesture.updateDetails.hoveredItem;
    if (selectionStart == null || selectionUpdate == null) {
      return;
    }

    SheetFillUpdateGesture(selectionStart, selectionUpdate).resolve(controller);
  }

  void _endFill(SheetController controller, SheetDragEndGesture gesture) {
    SheetFillEndGesture().resolve(controller);
    reset(controller);
  }
}

class MouseColumnResizeGestureHandler extends DraggableGestureHandler {
  MouseColumnResizeGestureHandler(this.viewportColumn);

  ViewportColumn viewportColumn;
  double? newWidth;

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

class MouseRowResizeGestureHandler extends DraggableGestureHandler {
  MouseRowResizeGestureHandler(this.viewportRow);

  ViewportRow viewportRow;
  double? newHeight;

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

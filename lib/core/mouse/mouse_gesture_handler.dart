import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_fill_events.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_selection_events.dart';
import 'package:sheets/core/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class MouseGestureHandler extends ChangeNotifier {
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
    if (gesture.startDetails.hoveredItem is! ViewportCell) {
      return;
    }
    ViewportCell cell = gesture.startDetails.hoveredItem! as ViewportCell;

    setActive(true);
    controller.resolve(EnableEditingEvent(cell: cell.index));
    setActive(false);
  }
}

class TextfieldHoverGestureHandler extends DraggableGestureHandler {
  @override
  SystemMouseCursor get hoverCursor => SystemMouseCursors.text;

  @override
  void resolve(SheetController controller, SheetMouseGesture gesture) {}

  @override
  void reset(SheetController controller) {
    setActive(false);
    resetCursor(controller);
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
    if (SheetCursor.instance.value != cursor) {
      SheetCursor.instance.value = cursor;
    }
  }

  void resetCursor(SheetController controller) {
    if (SheetCursor.instance.value != SystemMouseCursors.basic) {
      controller.mouse.resetCursor();
    }
  }
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

    controller.resolve(StartSelectionEvent(selectionStart));
  }

  void _updateSelection(SheetController controller, SheetDragUpdateGesture gesture) {
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    ViewportItem? selectionUpdate = gesture.updateDetails.hoveredItem;
    if (selectionStart == null || selectionUpdate == null) {
      return;
    }

    controller.resolve(UpdateSelectionEvent(selectionStart, selectionUpdate));
  }

  void _endSelection(SheetController controller, SheetDragEndGesture gesture) {
    controller.resolve(CompleteSelectionEvent());
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

    controller.resolve(StartFillSelectionEvent(selectionStart));
    controller.mouse.setCursor(SystemMouseCursors.precise);
  }

  void _updateFill(SheetController controller, SheetDragUpdateGesture gesture) {
    ViewportItem? selectionStart = gesture.startDetails.hoveredItem;
    ViewportItem? selectionUpdate = gesture.updateDetails.hoveredItem;
    if (selectionStart == null || selectionUpdate == null) {
      return;
    }

    controller.resolve(UpdateFillSelectionEvent(selectionStart, selectionUpdate));
  }

  void _endFill(SheetController controller, SheetDragEndGesture gesture) {
    controller.resolve(CompleteFillSelectionEvent());
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
    controller.resolve(ResizeColumnEvent(viewportColumn.index, newWidth!));
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
    controller.resolve(ResizeRowEvent(viewportRow.index, newHeight!));
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

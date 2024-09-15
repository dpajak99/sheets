import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/recognizers/selection_drag_recognizer.dart';
import 'package:sheets/controller/selection/recognizers/selection_tap_recognizer.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SheetCursorController extends ChangeNotifier {
  final SheetController sheetController;

  Offset position = Offset.zero;
  SheetItemConfig? hoveredElement;

  ValueNotifier<SystemMouseCursor> cursorListener = ValueNotifier(SystemMouseCursors.basic);

  DateTime? lastTap;

  SelectionDragRecognizer? selectionDragRecognizer;

  SheetCursorController(this.sheetController);

  ColumnConfig? _resizedColumn;

  set resizedColumn(ColumnConfig? resizedColumn) {
    if (selectionDragRecognizer == null) {
      _resizedColumn = resizedColumn;
      cursorListener.value = resizedColumn != null ? SystemMouseCursors.resizeColumn : SystemMouseCursors.basic;
    }
  }

  RowConfig? _resizedRow;

  set resizedRow(RowConfig? resizedRow) {
    if (selectionDragRecognizer == null) {
      _resizedRow = resizedRow;
      cursorListener.value = resizedRow != null ? SystemMouseCursors.resizeRow : SystemMouseCursors.basic;
    }
  }

  void scrollBy(Offset delta) {
    sheetController.scrollBy(delta);
    hoveredElement = sheetController.getHoveredElement(position);
    notifyListeners();
  }

  bool get isResizing => _resizedRow != null || _resizedColumn != null;

  void dragStart(DragStartDetails details) {
    position = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position);

    if (isResizing) {
    } else if (dragHoveredElement != null) {
      selectionDragRecognizer = SelectionDragRecognizer(sheetController, dragHoveredElement);
    }

    notifyListeners();
  }

  void dragUpdate(DragUpdateDetails details) {
    position = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position);

    if (isResizing) {
    } else if (dragHoveredElement != null) {
      selectionDragRecognizer?.handleDragUpdate(dragHoveredElement);
    }

    notifyListeners();
  }

  void dragEnd(DragEndDetails details) {
    selectionDragRecognizer = null;

    position = details.globalPosition;

    if (isResizing) {
    } else {
      sheetController.selectionController.completeSelection();
    }
    notifyListeners();
  }

  void updateOffset(Offset newOffset) {
    position = newOffset;
    hoveredElement = sheetController.getHoveredElement(position);
    notifyListeners();
  }

  void tap() {
    DateTime tapTime = DateTime.now();
    if (lastTap != null && tapTime.difference(lastTap!) < const Duration(milliseconds: 300)) {
      doubleTap();
    } else if (hoveredElement != null) {
      SelectionTapRecognizer(sheetController).handleItemTap(hoveredElement!);
    }
    lastTap = tapTime;
  }

  void doubleTap() {
    switch (hoveredElement) {
      case CellConfig cellConfig:
        sheetController.edit(cellConfig);
    }
  }
}

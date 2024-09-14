import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_constants.dart';

class SheetCursorController extends ChangeNotifier {
  final SheetController sheetController;

  Offset position = Offset.zero;
  SheetItemConfig? hoveredElement;

  ValueNotifier<SystemMouseCursor> cursorListener = ValueNotifier(SystemMouseCursors.basic);

  DateTime? lastTap;

  bool _dragInProgress = false;

  SheetCursorController(this.sheetController);

  ColumnConfig? _resizedColumn;

  set resizedColumn(ColumnConfig? resizedColumn) {
    if (_dragInProgress == false) {
      _resizedColumn = resizedColumn;
      cursorListener.value = resizedColumn != null ? SystemMouseCursors.resizeColumn : SystemMouseCursors.basic;
    }
  }

  RowConfig? _resizedRow;

  set resizedRow(RowConfig? resizedRow) {
    if (_dragInProgress == false) {
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
    _dragInProgress = true;
    position = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position);

    if (isResizing) {
    } else {
      switch (dragHoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectSingle(cellConfig.cellIndex);
      }
    }

    notifyListeners();
  }

  void dragUpdate(DragUpdateDetails details) {
    position = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position);

    if (isResizing) {
    } else {
      switch (dragHoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectRange(end: cellConfig.cellIndex, completed: false);
      }
    }

    notifyListeners();
  }

  void dragEnd(DragEndDetails details) {
    _dragInProgress = false;

    position = details.globalPosition;
    if (isResizing) {
    } else {
      sheetController.completeSelection();
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
    } else if (sheetController.keyboardController.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      switch (hoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectSingle(cellConfig.cellIndex);
        case ColumnConfig columnConfig:
          sheetController.selectRange(
            start: CellIndex(rowIndex: RowIndex(0), columnIndex: sheetController.selection.start.columnIndex),
            end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
          );
        case RowConfig rowConfig:
          sheetController.selectRange(
            start: CellIndex(rowIndex: sheetController.selection.start.rowIndex, columnIndex: ColumnIndex(0)),
            end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
          );
      }
    } else if(sheetController.keyboardController.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      switch (hoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectRange(end: cellConfig.cellIndex);
        case ColumnConfig columnConfig:
          sheetController.selectRange(
            start: CellIndex(rowIndex: RowIndex(0), columnIndex: sheetController.selection.start.columnIndex),
            end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
          );
        case RowConfig rowConfig:
          sheetController.selectRange(
            start: CellIndex(rowIndex: sheetController.selection.start.rowIndex, columnIndex: ColumnIndex(0)),
            end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
          );
      }

    }else {
      sheetController.cancelEdit();
      switch (hoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectSingle(cellConfig.cellIndex);
        case ColumnConfig columnConfig:
          sheetController.selectRange(
            start: CellIndex(rowIndex: RowIndex(0), columnIndex: columnConfig.columnIndex),
            end: CellIndex(rowIndex: RowIndex(defaultRowCount), columnIndex: columnConfig.columnIndex),
            completed: true,
          );
        case RowConfig rowConfig:
          sheetController.selectRange(
            start: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(0)),
            end: CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: ColumnIndex(defaultColumnCount)),
            completed: true,
          );
      }
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/custom_scroll_controller.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/painters/sheet_painter_notifier.dart';
import 'package:sheets/sheet_constants.dart';

class MouseListener extends ChangeNotifier {
  final SheetController sheetController;

  Offset offset = Offset.zero;
  SheetItemConfig? hoveredElement;

  ValueNotifier<SystemMouseCursor> cursorListener = ValueNotifier(SystemMouseCursors.basic);

  DateTime? lastTap;

  bool _dragInProgress = false;

  ColumnConfig? _resizedColumn;
  RowConfig? _resizedRow;

  set resizedColumn(ColumnConfig? resizedColumn) {
    if (_dragInProgress == false) {
      _resizedColumn = resizedColumn;
      cursorListener.value = resizedColumn != null ? SystemMouseCursors.resizeColumn : SystemMouseCursors.basic;
    }
  }

  set resizedRow(RowConfig? resizedRow) {
    if (_dragInProgress == false) {
      _resizedRow = resizedRow;
      cursorListener.value = resizedRow != null ? SystemMouseCursors.resizeRow : SystemMouseCursors.basic;
    }
  }

  void scrollBy(Offset delta) {
    sheetController.scrollBy(delta);
    hoveredElement = sheetController.getHoveredElement(offset);
    notifyListeners();
  }

  bool get isResizing => _resizedRow != null || _resizedColumn != null;

  MouseListener({
    required this.sheetController,
  });

  void dragStart(DragStartDetails details) {
    _dragInProgress = true;
    offset = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(offset);

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
    offset = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(offset);

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

    offset = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(offset);

    if (isResizing) {
    } else {
      switch (dragHoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectRange(end: cellConfig.cellIndex, completed: true);
      }
    }
    notifyListeners();
  }

  void updateOffset(Offset newOffset) {
    offset = newOffset;
    hoveredElement = sheetController.getHoveredElement(offset);
    notifyListeners();
  }

  void tap() {
    DateTime tapTime = DateTime.now();
    if (lastTap != null && tapTime.difference(lastTap!) < const Duration(milliseconds: 300)) {
      doubleTap();
    } else {
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

class SheetController {
  final SheetProperties sheetProperties;
  final SheetScrollController scrollController;

  late final SheetPaintConfig paintConfig;
  late final MouseListener mouseListener = MouseListener(sheetController: this);
  late SheetSelection selection = SheetSingleSelection.defaultSelection(paintConfig: paintConfig);

  SheetPainterNotifier selectionPainterNotifier = SheetPainterNotifier();
  ValueNotifier<CellConfig?> editNotifier = ValueNotifier(null);

  SheetController({
    required this.sheetProperties,
    required this.scrollController,
  }) {
    paintConfig = SheetPaintConfig(sheetController: this);
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    scrollController.customRowExtents = sheetProperties.customRowExtents;
  }

  void resize(Size size) {
    scrollController.viewportSize = size;
    paintConfig.resize(size);
  }

  void scrollBy(Offset delta) {
    scrollController.scrollBy(delta);
    paintConfig.refresh();
  }

  void resizeColumnBy(ColumnConfig column, double delta) {
    ColumnStyle columnStyle = sheetProperties.getColumnStyle(column.columnIndex);
    sheetProperties.setColumnStyle(
      column.columnIndex,
      columnStyle.copyWith(width: max(10, columnStyle.width + delta)),
    );
    scrollController.customColumnExtents = sheetProperties.customColumnExtents;
    paintConfig.refresh();
  }

  void resizeRowBy(RowConfig row, double delta) {
    RowStyle rowStyle = sheetProperties.getRowStyle(row.rowIndex);
    sheetProperties.setRowStyle(
      row.rowIndex,
      rowStyle.copyWith(height: max(10, rowStyle.height + delta)),
    );
    scrollController.customRowExtents = sheetProperties.customRowExtents;
    paintConfig.refresh();
  }

  void selectSingle(CellIndex cellIndex, {bool editingEnabled = false}) {
    selection = SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex, editingEnabled: editingEnabled);
    selectionPainterNotifier.repaint();
  }

  void selectRange({CellIndex? start, required CellIndex end, bool completed = true}) {
    CellIndex computedStart = start ?? selection.start;
    if (computedStart == end) {
      selectSingle(computedStart);
    } else {
      selection = SheetRangeSelection(paintConfig: paintConfig, start: computedStart, end: end, completed: completed);
      selectionPainterNotifier.repaint();
    }
  }

  void edit(CellConfig cellConfig) {
    selectSingle(cellConfig.cellIndex, editingEnabled: true);
    editNotifier.value = cellConfig;
  }

  void cancelEdit() {
    editNotifier.value = null;
  }

  SheetItemConfig? getHoveredElement(Offset mousePosition) {
    try {
      SheetItemConfig sheetItemConfig = paintConfig.visibleItems.firstWhere(
        (element) => element.rect.contains(mousePosition),
      );
      return sheetItemConfig;
    } catch (e) {
      return null;
    }
  }
}

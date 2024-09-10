import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/painters/sheet_painter_notifier.dart';
import 'package:sheets/utils.dart';

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
  late final SheetPaintConfig paintConfig;
  late final MouseListener mouseListener = MouseListener(sheetController: this);
  late SheetSelection selection = SheetSingleSelection.defaultSelection(paintConfig: paintConfig);

  IntOffset scrollOffset = IntOffset.zero;

  SheetPainterNotifier selectionPainterNotifier = SheetPainterNotifier();
  ValueNotifier<CellConfig?> editNotifier = ValueNotifier(null);

  SheetController({
    required Map<ColumnIndex, ColumnStyle> customColumnProperties,
    required Map<RowIndex, RowStyle> customRowProperties,
  }) {
    paintConfig = SheetPaintConfig(
      sheetController: this,
      customRowProperties: customRowProperties,
      customColumnProperties: customColumnProperties,
    );
  }

  void resize(Size size) {
    paintConfig.resize(size);
  }

  void scroll(IntOffset offset) {
    IntOffset updatedOffset = scrollOffset + offset;
    updatedOffset = IntOffset(max(0, updatedOffset.dx), max(0, updatedOffset.dy));

    scrollOffset = updatedOffset;
    paintConfig.refresh();
  }

  void resizeColumnBy(ColumnConfig column, double delta) {
    ColumnStyle columnStyle = paintConfig.customColumnProperties[column.columnIndex] ?? ColumnStyle.defaults();
    paintConfig.customColumnProperties[column.columnIndex] = columnStyle.copyWith(
      width: max(10, columnStyle.width + delta),
    );
    paintConfig.refresh();
  }

  void resizeRowBy(RowConfig row, double delta) {
    RowStyle rowStyle = paintConfig.customRowProperties[row.rowIndex] ?? RowStyle.defaults();
    paintConfig.customRowProperties[row.rowIndex] = rowStyle.copyWith(
      height: max(10, rowStyle.height + delta),
    );
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
      selection = SheetRangeSelection(paintConfig: paintConfig, start: selection.start, end: end, completed: completed);
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
      return paintConfig.visibleItems.firstWhere(
        (element) => element.rect.contains(mousePosition),
      );
    } catch (e) {
      return null;
    }
  }
}

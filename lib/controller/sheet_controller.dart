import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/painters/sheet_painter_notifier.dart';
import 'package:sheets/utils.dart';

class SheetController {
  late final SheetPaintConfig paintConfig;
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

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

  void selectSingle(CellIndex cellIndex) {
    selection = SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex);
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

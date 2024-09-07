import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/painters/sheet_painter_notifier.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils.dart';
import 'package:sheets/utils/direction.dart';

enum SelectionDirection {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

class ProgramSelectionKeyBox {
  final CellIndex topLeft;
  final CellIndex topRight;
  final CellIndex bottomLeft;
  final CellIndex bottomRight;

  ProgramSelectionKeyBox({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory ProgramSelectionKeyBox.fromSheetSelection(SheetSelection selection) {
    SelectionDirection selectionDirection = selection.selectionDirection;
    CellIndex start = selection.start;
    CellIndex end = selection.end;

    switch (selectionDirection) {
      case SelectionDirection.bottomRight:
        return ProgramSelectionKeyBox(
          topLeft: start,
          topRight: CellIndex(rowIndex: start.rowIndex, columnIndex: end.columnIndex),
          bottomLeft: CellIndex(rowIndex: end.rowIndex, columnIndex: start.columnIndex),
          bottomRight: end,
        );
      case SelectionDirection.bottomLeft:
        return ProgramSelectionKeyBox(
          topLeft: CellIndex(rowIndex: start.rowIndex, columnIndex: end.columnIndex),
          topRight: start,
          bottomLeft: end,
          bottomRight: CellIndex(rowIndex: end.rowIndex, columnIndex: start.columnIndex),
        );
      case SelectionDirection.topRight:
        return ProgramSelectionKeyBox(
          topLeft: CellIndex(rowIndex: end.rowIndex, columnIndex: start.columnIndex),
          topRight: end,
          bottomLeft: start,
          bottomRight: CellIndex(rowIndex: start.rowIndex, columnIndex: end.columnIndex),
        );
      case SelectionDirection.topLeft:
        return ProgramSelectionKeyBox(
          topLeft: end,
          topRight: CellIndex(rowIndex: end.rowIndex, columnIndex: start.columnIndex),
          bottomLeft: CellIndex(rowIndex: start.rowIndex, columnIndex: end.columnIndex),
          bottomRight: start,
        );
    }
  }
}

class ProgramSelectionRectBox {
  final Rect topLeft;
  final Rect topRight;
  final Rect bottomLeft;
  final Rect bottomRight;
  final Rect startCellRect;

  final bool hideTopBorder;
  final bool hideRightBorder;
  final bool hideBottomBorder;
  final bool hideLeftBorder;

  final bool startCellVisible;
  final bool lastCellVisible;

  ProgramSelectionRectBox({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.startCellRect,
    this.hideTopBorder = false,
    this.hideRightBorder = false,
    this.hideBottomBorder = false,
    this.hideLeftBorder = false,
    this.startCellVisible = true,
    this.lastCellVisible = true,
  });

  factory ProgramSelectionRectBox.fromCellConfigs({
    required CellConfig start,
    required CellConfig end,
    required SelectionDirection selectionDirection,
    bool startCellVisible = true,
    bool lastCellVisible = true,
    bool hideTopBorder = false,
    bool hideRightBorder = false,
    bool hideBottomBorder = false,
    bool hideLeftBorder = false,
  }) {
    late Rect topLeft;
    late Rect topRight;
    late Rect bottomLeft;
    late Rect bottomRight;

    switch (selectionDirection) {
      case SelectionDirection.bottomRight:
        topLeft = start.rect;
        bottomRight = end.rect;
        topRight = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        bottomLeft = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        break;
      case SelectionDirection.bottomLeft:
        topLeft = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        bottomRight = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        topRight = start.rect;
        bottomLeft = end.rect;
        break;
      case SelectionDirection.topRight:
        topLeft = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        bottomRight = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        topRight = end.rect;
        bottomLeft = start.rect;
        break;
      case SelectionDirection.topLeft:
        topLeft = end.rect;
        bottomRight = start.rect;
        topRight = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        bottomLeft = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        break;
    }

    return ProgramSelectionRectBox(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
      startCellRect: start.rect,
      hideTopBorder: hideTopBorder,
      hideRightBorder: hideRightBorder,
      hideBottomBorder: hideBottomBorder,
      hideLeftBorder: hideLeftBorder,
      startCellVisible: startCellVisible,
      lastCellVisible: lastCellVisible,
    );
  }
}

class SheetController {
  late final SheetPaintConfig paintConfig;

  SheetSelection selection = SheetEmptySelection();
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

  void updateSelection(SheetSelection sheetSelection) {
    selection = sheetSelection;
    selectionPainterNotifier.repaint();
  }

  ProgramSelectionRectBox? getProgramSelectionRectBox() {
    bool startCellVisible = paintConfig.containsCell(selection.start);
    bool endCellVisible = paintConfig.containsCell(selection.end);

    if ((startCellVisible || endCellVisible) == false) {
      return null;
    }

    CellConfig? startCell = paintConfig.findCell(selection.start);
    CellConfig? endCell = paintConfig.findCell(selection.end);

    if (startCell != null && endCell != null) {
      return ProgramSelectionRectBox.fromCellConfigs(
        start: startCell,
        end: endCell,
        selectionDirection: selection.selectionDirection,
      );
    } else if (startCell == null && endCell != null) {
      Direction verticalDirection;
      Direction horizontalDirection;
      CellConfig closestCell;

      (verticalDirection, horizontalDirection, closestCell) = paintConfig.findClosestVisible(selection.start);

      return ProgramSelectionRectBox.fromCellConfigs(
        start: closestCell,
        end: endCell,
        selectionDirection: selection.selectionDirection,
        hideTopBorder: verticalDirection == Direction.top,
        hideRightBorder: horizontalDirection == Direction.right,
        hideBottomBorder: verticalDirection == Direction.bottom,
        hideLeftBorder: horizontalDirection == Direction.left,
        startCellVisible: false,
      );
    } else if (startCell != null && endCell == null) {
      Direction verticalDirection;
      Direction horizontalDirection;
      CellConfig closestCell;

      (verticalDirection, horizontalDirection, closestCell) = paintConfig.findClosestVisible(selection.end);

      return ProgramSelectionRectBox.fromCellConfigs(
        start: startCell,
        end: closestCell,
        selectionDirection: selection.selectionDirection,
        hideTopBorder: verticalDirection == Direction.top,
        hideRightBorder: horizontalDirection == Direction.right,
        hideBottomBorder: verticalDirection == Direction.bottom,
        hideLeftBorder: horizontalDirection == Direction.left,
        lastCellVisible: false,
      );
    } else {
      return null;
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

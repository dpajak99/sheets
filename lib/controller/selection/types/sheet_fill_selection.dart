import 'package:flutter/material.dart';
import 'package:sheets/models/selection_status.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/models/sheet_viewport_delegate.dart';
import 'package:sheets/models/selection_bounds.dart';
import 'package:sheets/models/selection_corners.dart';
import 'package:sheets/utils/direction.dart';

class SheetFillSelection extends SheetRangeSelection {
  final SheetSelection baseSelection;
  final Direction fillDirection;

  SheetFillSelection({
    required this.baseSelection,
    required this.fillDirection,
    required super.paintConfig,
    required super.start,
    required super.end,
    required super.completed,
  }) : assert(baseSelection is! SheetFillSelection);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => baseSelection.isColumnSelected(columnIndex);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => baseSelection.isRowSelected(rowIndex);

  @override
  bool get fillHandleVisible => true;

  @override
  Offset? get fillHandleOffset => baseSelection.fillHandleOffset;

  @override
  SheetSelection complete() {
    SelectionCellCorners parentCorners = baseSelection.selectionCorners!;
    SelectionCellCorners currentCorners = selectionCorners;

    switch (fillDirection) {
      case Direction.top:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: currentCorners.topLeft,
          end: parentCorners.bottomRight,
          completed: true,
        );
      case Direction.bottom:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: parentCorners.topLeft,
          end: currentCorners.bottomRight,
          completed: true,
        );
      case Direction.left:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: currentCorners.topLeft,
          end: parentCorners.bottomRight,
          completed: true,
        );
      case Direction.right:
        return SheetRangeSelection(
          paintConfig: paintConfig,
          start: parentCorners.topLeft,
          end: currentCorners.bottomRight,
          completed: true,
        );
    }
  }

  @override
  SheetSelection simplify() => this;

  @override
  SheetSelectionPaint get paint => SheetFillSelectionPaint(this);
}

class SheetFillSelectionPaint extends SheetSelectionPaint {
  final SheetFillSelection selection;

  SheetFillSelectionPaint(this.selection);

  @override
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size) {
    selection.baseSelection.paint.paint(paintConfig, canvas, size);

    SelectionBounds? selectionBounds = selection.getSelectionBounds();
    if (selectionBounds == null) {
      return;
    }

    Rect selectionRect = selectionBounds.selectionRect;

    paintFillBorder(canvas, selectionRect);
  }
}

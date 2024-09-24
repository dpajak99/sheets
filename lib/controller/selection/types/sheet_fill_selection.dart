import 'package:flutter/material.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';

class SheetFillSelection extends SheetRangeSelection {
  final SheetSelection baseSelection;

  SheetFillSelection({
    required this.baseSelection,
    required super.paintConfig,
    required super.start,
    required super.end,
    required super.completed,
  }) : assert(baseSelection is! SheetFillSelection);

  @override
  SheetSelectionPaint get paint => SheetFillSelectionPaint(this);
}

class SheetFillSelectionPaint extends SheetSelectionPaint {
  final SheetFillSelection selection;

  SheetFillSelectionPaint(this.selection);

  @override
  void paint(SheetVisibilityController paintConfig, Canvas canvas, Size size) {
    print('Paint baseSelection selection: ${selection.baseSelection}');
    selection.baseSelection.paint.paint(paintConfig, canvas, size);

    SelectionBounds? selectionBounds = selection.getSelectionBounds();
    if (selectionBounds == null) {
      return;
    }

    Rect selectionRect = selectionBounds.selectionRect;

    paintFillBorder(canvas, selectionRect);

    if (selection.isCompleted) {
      paintSelectionBorder(
        canvas,
        selectionRect,
        top: selectionBounds.isTopBorderVisible,
        right: selectionBounds.isRightBorderVisible,
        bottom: selectionBounds.isBottomBorderVisible,
        left: selectionBounds.isLeftBorderVisible,
      );

      paintFillHandle(canvas, selectionBounds.selectionRect.bottomRight);
    }
  }
}

import 'package:sheets/selection/renderers/sheet_fill_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/utils/direction.dart';

class SheetFillSelection extends SheetRangeSelection {
  final SheetSelection baseSelection;
  final Direction fillDirection;

  SheetFillSelection({
    required this.baseSelection,
    required this.fillDirection,
    required super.start,
    required super.end,
    required super.completed,
  }) : assert(baseSelection is! SheetFillSelection);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => baseSelection.isColumnSelected(columnIndex);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => baseSelection.isRowSelected(rowIndex);

  @override
  SheetSelection complete() {
    SelectionCellCorners parentCorners = baseSelection.selectionCellCorners!;
    SelectionCellCorners currentCorners = selectionCellCorners;

    switch (fillDirection) {
      case Direction.top:
        return SheetRangeSelection(start: currentCorners.topLeft, end: parentCorners.bottomRight, completed: true);
      case Direction.bottom:
        return SheetRangeSelection(start: parentCorners.topLeft, end: currentCorners.bottomRight, completed: true);
      case Direction.left:
        return SheetRangeSelection(start: currentCorners.topLeft, end: parentCorners.bottomRight, completed: true);
      case Direction.right:
        return SheetRangeSelection(start: parentCorners.topLeft, end: currentCorners.bottomRight, completed: true);
    }
  }

  @override
  SheetFillSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetFillSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }
}



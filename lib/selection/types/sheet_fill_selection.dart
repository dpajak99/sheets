import 'package:sheets/selection/renderers/sheet_fill_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/utils/direction.dart';

class SheetFillSelection<T extends SheetIndex> extends SheetRangeSelection<T> {
  final SheetSelection baseSelection;
  final Direction fillDirection;

  SheetFillSelection(
    super.start,
    super.end, {
    required this.baseSelection,
    required this.fillDirection,
    required super.completed,
  }) : assert(baseSelection is! SheetFillSelection);

  @override
  SheetFillSelection copyWith({
    T? start,
    T? end,
    bool? completed,
    SheetSelection? baseSelection,
    Direction? fillDirection,
  }) {
    return SheetFillSelection(
      start ?? selectionStart,
      end ?? selectionEnd,
      completed: completed ?? isCompleted,
      baseSelection: baseSelection ?? this.baseSelection,
      fillDirection: fillDirection ?? this.fillDirection,
    );
  }

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => baseSelection.isColumnSelected(columnIndex);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => baseSelection.isRowSelected(rowIndex);

  @override
  SheetSelection complete() {
    SelectionCellCorners parentCorners = baseSelection.cellCorners!;
    SelectionCellCorners currentCorners = cellCorners;

    switch (fillDirection) {
      case Direction.top:
        return SheetRangeSelection(currentCorners.topLeft, parentCorners.bottomRight, completed: true);
      case Direction.bottom:
        return SheetRangeSelection(parentCorners.topLeft, currentCorners.bottomRight, completed: true);
      case Direction.left:
        return SheetRangeSelection(currentCorners.topLeft, parentCorners.bottomRight, completed: true);
      case Direction.right:
        return SheetRangeSelection(parentCorners.topLeft, currentCorners.bottomRight, completed: true);
    }
  }

  @override
  SheetFillSelectionRenderer createRenderer(SheetViewport viewport) {
    return SheetFillSelectionRenderer(viewport: viewport, selection: this);
  }
}

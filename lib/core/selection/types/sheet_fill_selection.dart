import 'package:sheets/core/selection/renderers/sheet_fill_selection_renderer.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/utils/direction.dart';

class SheetFillSelection extends SheetRangeSelection<CellIndex> {
  SheetFillSelection(
    super.startIndex,
    super.endIndex, {
    required this.baseSelection,
    required this.fillDirection,
    super.customMainCell,
  })  : assert(baseSelection is! SheetFillSelection, 'Cannot fill a fill selection'),
        super(completed: false);

  final SheetSelection baseSelection;
  final Direction fillDirection;

  @override
  SheetFillSelection copyWith({
    CellIndex? startIndex,
    CellIndex? endIndex,
    bool? completed,
    SheetSelection? baseSelection,
    Direction? fillDirection,
    CellIndex? customMainCell,
  }) {
    return SheetFillSelection(
      startIndex ?? start.index as CellIndex,
      endIndex ?? end.index as CellIndex,
      baseSelection: baseSelection ?? this.baseSelection,
      fillDirection: fillDirection ?? this.fillDirection,
      customMainCell: customMainCell ?? mainCell,
    );
  }

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => baseSelection.isColumnSelected(columnIndex);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => baseSelection.isRowSelected(rowIndex);

  @override
  SheetSelection modifyEnd(SheetIndex itemIndex) => this;

  @override
  SheetSelection complete() {
    SelectionCellCorners parentCorners = baseSelection.cellCorners!;
    SelectionCellCorners currentCorners = cellCorners;

    switch (fillDirection) {
      case Direction.top:
        return SheetRangeSelection<CellIndex>(currentCorners.topLeft, parentCorners.bottomRight);
      case Direction.bottom:
        return SheetRangeSelection<CellIndex>(parentCorners.topLeft, currentCorners.bottomRight);
      case Direction.left:
        return SheetRangeSelection<CellIndex>(currentCorners.topLeft, parentCorners.bottomRight);
      case Direction.right:
        return SheetRangeSelection<CellIndex>(parentCorners.topLeft, currentCorners.bottomRight);
    }
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) => <SheetSelection>[this];

  @override
  SheetFillSelectionRenderer createRenderer(SheetViewport viewport) {
    return SheetFillSelectionRenderer(viewport: viewport, selection: this);
  }

  @override
  List<Object?> get props => super.props..addAll(<Object?>[baseSelection, fillDirection]);
}

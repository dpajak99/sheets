import 'package:sheets/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;

  SheetSingleSelection({
    required this.cellIndex,
    required super.completed,
  });

  SheetSingleSelection.defaultSelection()
      : cellIndex = CellIndex.zero,
        super(completed: true);

  @override
  CellIndex get start => cellIndex;

  @override
  CellIndex get end => cellIndex;

  @override
  Set<CellIndex> get selectedCells => {cellIndex};

  @override
  SelectionCellCorners get selectionCellCorners => SelectionCellCorners.single(cellIndex);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => SelectionStatus(cellIndex.columnIndex == columnIndex, false);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => SelectionStatus(cellIndex.rowIndex == rowIndex, false);

  @override
  bool containsCell(CellIndex cellIndex) => this.cellIndex == cellIndex;

  @override
  String stringifySelection() => cellIndex.stringifyPosition();

  @override
  SheetSingleSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetSingleSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  SheetSelection complete() {
    return SheetSingleSelection(cellIndex: cellIndex, completed: true);
  }

  @override
  SheetSelection modifyEnd(CellIndex cellIndex, {required bool completed}) {
    return SheetRangeSelection(start: start, end: cellIndex, completed: completed);
  }

  @override
  bool containsSelection(SheetSelection nestedSelection) {
    return nestedSelection is SheetSingleSelection && nestedSelection.cellIndex == cellIndex;
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) {
    if (subtractedSelection.contains(cellIndex)) {
      return [];
    } else {
      return [this];
    }
  }

  @override
  List<Object?> get props => <Object?>[cellIndex, isCompleted];
}


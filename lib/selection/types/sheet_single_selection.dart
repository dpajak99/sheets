import 'package:sheets/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex selectedIndex;

  SheetSingleSelection({
    required this.selectedIndex,
    required super.completed,
  });

  SheetSingleSelection.defaultSelection()
      : selectedIndex = CellIndex.zero,
        super(completed: true);

  @override
  CellIndex get start => selectedIndex;

  @override
  CellIndex get end => selectedIndex;

  @override
  Set<CellIndex> get selectedCells => {selectedIndex};

  @override
  SelectionCellCorners get selectionCellCorners => SelectionCellCorners.single(selectedIndex);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => SelectionStatus(selectedIndex.columnIndex == columnIndex, false);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => SelectionStatus(selectedIndex.rowIndex == rowIndex, false);

  @override
  bool containsCell(CellIndex cellIndex) => selectedIndex == cellIndex;

  @override
  String stringifySelection() => selectedIndex.stringifyPosition();

  @override
  SheetSingleSelectionRenderer createRenderer(SheetViewport viewportDelegate) {
    return SheetSingleSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  SheetSelection complete() {
    return SheetSingleSelection(selectedIndex: selectedIndex, completed: true);
  }

  @override
  SheetSelection modifyEnd(SheetItemIndex itemIndex, {required bool completed}) {
    return SheetSelection.range(start: start, end: itemIndex, completed: completed);
  }

  @override
  bool containsSelection(SheetSelection nestedSelection) {
    return nestedSelection is SheetSingleSelection && nestedSelection.selectedIndex == selectedIndex;
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) {
    if (subtractedSelection.contains(selectedIndex)) {
      return [];
    } else {
      return [this];
    }
  }

  @override
  List<Object?> get props => <Object?>[selectedIndex, isCompleted];
}


import 'package:sheets/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex selectedIndex;

  SheetSingleSelection(
    this.selectedIndex, {
    super.completed = false,
  });

  SheetSingleSelection.defaultSelection()
      : selectedIndex = CellIndex.zero,
        super(completed: true);

  @override
  SheetSingleSelection copyWith({
    CellIndex? selectedIndex,
    bool? completed,
  }) {
    return SheetSingleSelection(
      selectedIndex ?? this.selectedIndex,
      completed: completed ?? isCompleted,
    );
  }

  @override
  CellIndex get mainCell => selectedIndex;

  @override
  CellIndex get selectionStart => selectedIndex;

  @override
  CellIndex get selectionEnd => selectedIndex;

  @override
  SelectionCellCorners get cellCorners => SelectionCellCorners.single(selectedIndex);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => SelectionStatus(selectedIndex.columnIndex == columnIndex, false);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => SelectionStatus(selectedIndex.rowIndex == rowIndex, false);

  @override
  String stringifySelection() => selectedIndex.stringifyPosition();

  @override
  SheetSingleSelectionRenderer createRenderer(SheetViewport viewport) {
    return SheetSingleSelectionRenderer(viewport: viewport, selection: this);
  }

  @override
  SheetSelection complete() {
    return SheetSingleSelection(selectedIndex, completed: true);
  }

  @override
  SheetSelection modifyEnd(SheetIndex itemIndex) {
    return SheetSelection.range(start: selectionStart, end: itemIndex);
  }

  @override
  bool containsColumn(ColumnIndex index) => selectedIndex.columnIndex == index;

  @override
  bool containsRow(RowIndex index) => selectedIndex.rowIndex == index;

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

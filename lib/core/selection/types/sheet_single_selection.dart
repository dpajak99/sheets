import 'package:sheets/core/selection/renderers/sheet_single_selection_renderer.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetSingleSelection extends SheetSelectionBase {
  SheetSingleSelection(
    this._selectedIndex, {
    this.fillHandleVisible = true,
  }) : super(startIndex: _selectedIndex, endIndex: _selectedIndex, completed: true);

  factory SheetSingleSelection.defaultSelection() {
    return SheetSingleSelection(CellIndex.zero);
  }

  final CellIndex _selectedIndex;
  final bool fillHandleVisible;

  @override
  SheetSingleSelection copyWith({
    CellIndex? selectedIndex,
    bool? completed,
    bool? fillHandleVisible,
  }) {
    return SheetSingleSelection(
      selectedIndex ?? _selectedIndex,
      fillHandleVisible: fillHandleVisible ?? this.fillHandleVisible,
    );
  }

  @override
  CellIndex get mainCell => _selectedIndex;

  @override
  SelectionCellCorners get cellCorners {
    return SelectionCellCorners.single(_selectedIndex);
  }

  @override
  bool containsRow(RowIndex index) {
    if (_selectedIndex is MergedCellIndex) {
      return _selectedIndex.containsRow(index);
    } else {
      return _selectedIndex.row == index;
    }
  }

  @override
  bool containsColumn(ColumnIndex index) {
    if (_selectedIndex is MergedCellIndex) {
      return _selectedIndex.containsColumn(index);
    } else {
      return _selectedIndex.column == index;
    }
  }

  @override
  bool containsSelection(SheetSelection nestedSelection) {
    return nestedSelection is SheetSingleSelection && nestedSelection._selectedIndex == _selectedIndex;
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    if(_selectedIndex is MergedCellIndex) {
      return SelectionStatus(_selectedIndex.containsRow(rowIndex), false);
    } else {
      return SelectionStatus(_selectedIndex.row == rowIndex, false);
    }
  }

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    if(_selectedIndex is MergedCellIndex) {
      return SelectionStatus(_selectedIndex.containsColumn(columnIndex), false);
    } else {
      return SelectionStatus(_selectedIndex.column == columnIndex, false);
    }
  }

  @override
  SheetSelection modifyEnd(SheetIndex itemIndex) {
    return SheetSelectionFactory.range(start: start.index, end: itemIndex);
  }

  @override
  SheetSelection complete() {
    return copyWith(selectedIndex: _selectedIndex, completed: true);
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) {
    if (subtractedSelection.contains(_selectedIndex)) {
      return <SheetSelection>[];
    } else {
      return <SheetSelection>[this];
    }
  }

  @override
  SheetSingleSelectionRenderer createRenderer(SheetViewport viewport) {
    return SheetSingleSelectionRenderer(viewport: viewport, selection: this);
  }

  @override
  String stringifySelection() {
    return _selectedIndex.stringifyPosition();
  }

  @override
  List<Object?> get props => <Object?>[_selectedIndex, isCompleted, fillHandleVisible];
}

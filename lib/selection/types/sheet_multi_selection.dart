import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/renderers/sheet_multi_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/utils/extensions/iterable_extensions.dart';

class SheetMultiSelection extends SheetSelection {
  final List<SheetSelection> mergedSelections;
  final CellIndex? _mainCell;

  SheetMultiSelection({
    required this.mergedSelections,
    CellIndex? mainCell,
  })  : _mainCell = mainCell,
        super(completed: true);

  SheetMultiSelection copyWith({
    List<SheetSelection>? mergedSelections,
    CellIndex? mainCell,
    bool? completed,
  }) {
    return SheetMultiSelection(
      mergedSelections: mergedSelections ?? this.mergedSelections,
      mainCell: mainCell ?? _mainCell,
    )..applyProperties(sheetProperties);
  }

  @override
  SheetItemIndex get start => mergedSelections.last.start;

  @override
  SheetItemIndex get end => mergedSelections.last.end;

  @override
  CellIndex get mainCell {
    if (_mainCell != null) {
      return _mainCell;
    } else {
      return trueEnd;
    }
  }

  @override
  bool containsCell(CellIndex cellIndex) {
    return mergedSelections.any((selection) => selection.containsCell(cellIndex));
  }

  @override
  Set<CellIndex> get selectedCells {
    return mergedSelections.fold(<CellIndex>{}, (Set<CellIndex> acc, SheetSelection selection) {
      acc.addAll(selection.selectedCells);
      return acc;
    });
  }

  @override
  SelectionCellCorners? get selectionCellCorners => null;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    return mergedSelections.fold(SelectionStatus(false, false), (SelectionStatus acc, SheetSelection selection) {
      SelectionStatus columnStatus = selection.isColumnSelected(columnIndex);
      return SelectionStatus(acc.isSelected || columnStatus.isSelected, acc.isFullySelected || columnStatus.isFullySelected);
    });
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    return mergedSelections.fold(SelectionStatus(false, false), (SelectionStatus acc, SheetSelection selection) {
      SelectionStatus rowStatus = selection.isRowSelected(rowIndex);
      return SelectionStatus(acc.isSelected || rowStatus.isSelected, acc.isFullySelected || rowStatus.isFullySelected);
    });
  }

  @override
  String stringifySelection() {
    return mergedSelections.last.stringifySelection();
  }

  @override
  SheetSelectionRenderer createRenderer(SheetViewport viewportDelegate) {
    return SheetMultiSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  SheetSelection modifyEnd(SheetItemIndex itemIndex, {required bool completed}) {
    List<SheetSelection> newMergedSelections = mergedSelections.sublist(0, mergedSelections.length - 1);
    SheetSelection modifiedSelection = mergedSelections.last.modifyEnd(itemIndex, completed: completed);
    newMergedSelections.add(modifiedSelection);

    return SheetMultiSelection(
      mergedSelections: newMergedSelections,
      mainCell: modifiedSelection.mainCell,
    );
  }

  @override
  SheetSelection append(SheetSelection appendedSelection) {
    return copyWith(
      mergedSelections: [
        ...mergedSelections,
        appendedSelection,
      ],
      mainCell: appendedSelection.mainCell,
    );
  }

  SheetMultiSelection replaceLast(SheetSelection sheetSelection) {
    sheetSelection.applyProperties(sheetProperties);

    List<SheetSelection> newMergedSelections = mergedSelections.sublist(0, mergedSelections.length - 1);
    newMergedSelections.add(sheetSelection);

    return copyWith(
      mergedSelections: newMergedSelections,
      mainCell: sheetSelection.mainCell,
    );
  }

  @override
  void applyProperties(SheetProperties properties) {
    for (SheetSelection selection in mergedSelections) {
      selection.applyProperties(properties);
    }
    super.applyProperties(properties);
  }

  @override
  bool containsSelection(SheetSelection nestedSelection) {
    return mergedSelections.any((selection) => selection.containsSelection(nestedSelection));
  }

  @override
  SheetSelection complete() {
    return this;
  }

  @override
  SheetSelection simplify() {
    SheetSelection lastSelection = mergedSelections.last;
    List<SheetSelection> previousSelections = mergedSelections.sublist(0, mergedSelections.length - 1);
    List<SheetSelection> updatedSelections = [];
    SheetSelection mainSelection = lastSelection;

    bool subtracted = false;
    for (SheetSelection selection in previousSelections) {
      if (subtracted == false && selection.containsSelection(lastSelection)) {
        subtracted = true;
        List<SheetSelection> subtractedSelection = selection.subtract(lastSelection);
        if (subtractedSelection.isNotEmpty) {
          mainSelection = subtractedSelection.last;
          updatedSelections.addAll(subtractedSelection);
        }
      } else {
        updatedSelections.add(selection);
      }
    }

    return copyWith(
      completed: true,
      mergedSelections: subtracted ? updatedSelections : mergedSelections,
      mainCell: mainSelection.mainCell,
    );
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) {
    List<SheetSelection> updatedSelections = mergedSelections.map((selection) => selection.subtract(subtractedSelection)).whereNotNull().cast();
    if (updatedSelections.isEmpty) {
      return [];
    } else {
      return updatedSelections;
    }
  }

  @override
  List<Object?> get props => [mergedSelections, _mainCell];
}

import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/controller/selection/types/sheet_range_selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/selection/types/sheet_single_selection.dart';
import 'package:sheets/controller/sheet_visibility_controller.dart';

class SheetMultiSelection extends SheetSelection {
  late Set<CellIndex> _selectedCells;
  late List<SheetSelection> mergedSelections;

  SheetMultiSelection._({
    required super.paintConfig,
    required Set<CellIndex> selectedCells,
    required this.mergedSelections,
  })  : _selectedCells = selectedCells,
        super(completed: true);

  factory SheetMultiSelection({
    required SheetVisibilityController paintConfig,
    required List<CellIndex> selectedCells,
    List<SheetSelection>? mergedSelections,
  }) {
    return SheetMultiSelection._(
      paintConfig: paintConfig,
      selectedCells: selectedCells.toSet(),
      mergedSelections:
          mergedSelections ?? selectedCells.map((CellIndex cellIndex) => SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex)).toList(),
    );
  }

  @override
  List<CellIndex> get selectedCells => _selectedCells.toList();

  @override
  CellIndex get start => _selectedCells.first;

  @override
  CellIndex get end => _selectedCells.last;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    return mergedSelections.fold(SelectionStatus.statusFalse, (status, mergedSelection) => status.merge(mergedSelection.isColumnSelected(columnIndex)));
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    return mergedSelections.fold(SelectionStatus.statusFalse, (status, mergedSelection) => status.merge(mergedSelection.isRowSelected(rowIndex)));
  }

  void addSingle(CellIndex cellIndex) {
    if (selectedCells.contains(cellIndex) && _selectedCells.length > 1) {
      _selectedCells.remove(cellIndex);
    } else {
      _selectedCells.add(cellIndex);
    }
    updatePainters();
  }

  void addAll(List<CellIndex> cells) {
    _selectedCells.addAll(cells);
    updatePainters();
  }

  @override
  SheetSelection simplify() {
    if (selectedCells.length == 1) {
      return SheetSingleSelection(
        paintConfig: paintConfig,
        cellIndex: selectedCells.first,
      );
    }

    // Group cells by their column index
    List<SheetSelection> mergedSelections = [];
    var groupedByColumn = selectedCells.groupListsBy((cell) => cell.columnIndex);

    for (var columnCells in groupedByColumn.values) {
      // Sort cells within the column by their row index
      columnCells.sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

      // Merge consecutive cells in the same column
      int start = 0;
      for (int i = 0; i < columnCells.length; i++) {
        bool isLastCell = i == columnCells.length - 1;
        bool isNonConsecutive = !isLastCell && columnCells[i].rowIndex.value + 1 != columnCells[i + 1].rowIndex.value;

        if (isLastCell || isNonConsecutive) {
          mergedSelections.add(SheetRangeSelection(
            paintConfig: paintConfig,
            start: columnCells[start],
            end: columnCells[i],
            completed: true,
          ));
          start = i + 1;
        }
      }
    }

    return SheetMultiSelection(paintConfig: paintConfig, selectedCells: selectedCells, mergedSelections: mergedSelections);
  }

  @override
  SheetSelectionPaint get paint => SheetMultiSelectionPaint(this);

  void updatePainters() {
    mergedSelections = selectedCells.map((CellIndex cellIndex) => SheetSingleSelection(paintConfig: paintConfig, cellIndex: cellIndex)).toList();
  }

  @override
  Offset? get fillHandleOffset => null;

  @override
  List<Object?> get props => [selectedCells];

  @override
  String stringifySelection() {
    return selectedCells.map((cellIndex) => cellIndex.stringifyPosition()).join(', ');
  }
}

class SheetMultiSelectionPaint extends SheetSelectionPaint {
  final SheetMultiSelection selection;

  SheetMultiSelectionPaint(this.selection);

  @override
  void paint(SheetVisibilityController paintConfig, Canvas canvas, Size size) {
    for (SheetSelection mergedSelection in selection.mergedSelections) {
      if (mergedSelection is SheetRangeSelection) {
        SelectionBounds? selectionBounds = mergedSelection.getSelectionBounds();
        if (selectionBounds == null) {
          return;
        }

        Rect selectionRect = selectionBounds.selectionRect;
        paintSelectionBackground(canvas, selectionRect);

        paintSelectionBorder(
          canvas,
          selectionRect,
          top: selectionBounds.isTopBorderVisible,
          right: selectionBounds.isRightBorderVisible,
          bottom: selectionBounds.isBottomBorderVisible,
          left: selectionBounds.isLeftBorderVisible,
        );
      } else if (mergedSelection is SheetSingleSelection) {
        CellConfig? selectedCell = mergedSelection.selectedCell;
        if (selectedCell == null) {
          return;
        }

        paintSelectionBackground(canvas, selectedCell.rect);
        paintSelectionBorder(canvas, selectedCell.rect);
      }
    }

    CellConfig? selectedCell = selection.paintConfig.findCell(selection.selectedCells.last);
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
  }
}

extension ListExtensions<T> on List<T> {
  /// Groups the list elements by a key returned by the provided [keySelector] function.
  Map<K, List<T>> groupListsBy<K>(K Function(T) keySelector) {
    Map<K, List<T>> groupedMap = {};

    for (var element in this) {
      final key = keySelector(element);
      groupedMap.putIfAbsent(key, () => []).add(element);
    }

    return groupedMap;
  }
}

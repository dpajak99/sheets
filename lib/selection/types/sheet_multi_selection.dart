import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_bounds.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/types/sheet_range_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SheetMultiSelection extends SheetSelection {
  final Set<CellIndex> _selectedCells;
  final List<SheetSelection> mergedSelections;
  final CellIndex? _mainCell;

  SheetMultiSelection._({
    required Set<CellIndex> selectedCells,
    required this.mergedSelections,
    CellIndex? mainCell,
  })  : _selectedCells = selectedCells,
        _mainCell = mainCell,
        super(completed: true);

  factory SheetMultiSelection({
    required Set<CellIndex> selectedCells,
    List<SheetSelection>? mergedSelections,
    CellIndex? mainCell,
  }) {
    return SheetMultiSelection._(
      selectedCells: selectedCells,
      mergedSelections:
          mergedSelections ?? selectedCells.map((CellIndex cellIndex) => SheetSingleSelection(cellIndex: cellIndex, completed: false)).toList(),
      mainCell: mainCell,
    );
  }

  @override
  CellIndex get start => _selectedCells.first;

  @override
  CellIndex get end => _selectedCells.last;

  @override
  CellIndex get mainCell {
    if (_mainCell != null) {
      return _mainCell;
    } else {
      return end;
    }
  }

  @override
  Set<CellIndex> get selectedCells => _selectedCells;

  @override
  SelectionCellCorners? get selectionCellCorners => null;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    Set<CellIndex> columnCells = selectedCells.where((cell) => cell.columnIndex == columnIndex).toSet();

    bool selected = columnCells.isNotEmpty;
    bool fullySelected = columnCells.length == sheetProperties.rowCount;

    return SelectionStatus(selected, fullySelected);
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    Set<CellIndex> rowCells = selectedCells.where((cell) => cell.rowIndex == rowIndex).toSet();

    bool selected = rowCells.isNotEmpty;
    bool fullySelected = rowCells.length == sheetProperties.columnCount;

    return SelectionStatus(selected, fullySelected);
  }

  @override
  SheetSelection simplify() {
    if (selectedCells.length == 1) {
      return SheetSingleSelection(cellIndex: selectedCells.first, completed: true)..applyProperties(sheetProperties);
    }

    List<SheetSelection> mergedSelections = [];
    Map<ColumnIndex, List<CellIndex>> groupedByColumn = selectedCells.groupListsBy((cell) => cell.columnIndex);

    for (List<CellIndex> columnCells in groupedByColumn.values) {
      columnCells.sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

      int start = 0;
      for (int i = 0; i < columnCells.length; i++) {
        bool isLastCell = i == columnCells.length - 1;
        bool isNonConsecutive = !isLastCell && columnCells[i].rowIndex.value + 1 != columnCells[i + 1].rowIndex.value;

        if (isLastCell || isNonConsecutive) {
          mergedSelections.add(
            SheetRangeSelection(start: columnCells[start], end: columnCells[i], completed: true)..applyProperties(sheetProperties),
          );
          start = i + 1;
        }
      }
    }

    return SheetMultiSelection(selectedCells: selectedCells, mergedSelections: mergedSelections, mainCell: _mainCell)
      ..applyProperties(sheetProperties);
  }

  @override
  String stringifySelection() {
    return selectedCells.map((cellIndex) => cellIndex.stringifyPosition()).join(', ');
  }

  @override
  SheetSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetMultiSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  List<Object?> get props => [selectedCells];
}

class SheetMultiSelectionRenderer extends SheetSelectionRenderer {
  final SheetMultiSelection selection;

  SheetMultiSelectionRenderer({
    required super.viewportDelegate,
    required this.selection,
  });

  @override
  bool get fillHandleVisible => false;

  @override
  Offset? get fillHandleOffset => null;

  @override
  SheetSelectionPaint get paint => SheetMultiSelectionPaint(this);

  CellConfig? get lastSelectedCell => viewportDelegate.findCell(selection.mainCell);
}

class SheetMultiSelectionPaint extends SheetSelectionPaint {
  final SheetMultiSelectionRenderer renderer;

  SheetMultiSelectionPaint(this.renderer);

  @override
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size) {
    for (SheetSelection mergedSelection in renderer.selection.mergedSelections) {
      if (mergedSelection is SheetRangeSelection) {
        SheetRangeSelectionRenderer sheetRangeSelectionRenderer = mergedSelection.createRenderer(paintConfig);
        SelectionBounds? selectionBounds = sheetRangeSelectionRenderer.selectionBounds;
        if (selectionBounds == null) {
          continue;
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
        SheetSingleSelectionRenderer sheetSingleSelectionRenderer = mergedSelection.createRenderer(paintConfig);
        CellConfig? selectedCell = sheetSingleSelectionRenderer.selectedCell;
        if (selectedCell == null) {
          return;
        }

        paintSelectionBackground(canvas, selectedCell.rect);
        paintSelectionBorder(canvas, selectedCell.rect);
      } else {}
    }

    CellConfig? selectedCell = renderer.lastSelectedCell;
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
  }
}

extension SetExtensions<T extends Object> on Set<T> {
  /// Groups the list elements by a key returned by the provided [keySelector] function.
  Map<K, List<T>> groupListsBy<K extends Comparable>(K Function(T) keySelector) {
    Map<K, List<T>> groupedMap = {};

    for (var element in this) {
      final key = keySelector(element);
      groupedMap.putIfAbsent(key, () => []).add(element);
    }

    SplayTreeMap sortedMap = SplayTreeMap<K, List<T>>.from(groupedMap, (K a, K b) => a.compareTo(b));
    return Map.from(sortedMap);
  }
}

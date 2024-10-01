import 'package:flutter/material.dart';
import 'package:sheets/models/selection_status.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/models/selection_bounds.dart';
import 'package:sheets/models/selection_corners.dart';
import 'package:sheets/models/sheet_item_config.dart';
import 'package:sheets/models/sheet_viewport_delegate.dart';
import 'package:sheets/selection/sheet_range_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/sheet_single_selection.dart';

class SheetMultiSelection extends SheetSelection {
  late Set<CellIndex> _selectedCells;
  late List<SheetSelection> mergedSelections;

  SheetMultiSelection._({
    required Set<CellIndex> selectedCells,
    required this.mergedSelections,
  })  : _selectedCells = selectedCells,
        super(completed: true);

  factory SheetMultiSelection({
    required List<CellIndex> selectedCells,
    List<SheetSelection>? mergedSelections,
  }) {
    return SheetMultiSelection._(
      selectedCells: selectedCells.toSet(),
      mergedSelections: mergedSelections ?? selectedCells.map((CellIndex cellIndex) => SheetSingleSelection(cellIndex: cellIndex)).toList(),
    );
  }

  @override
  CellIndex get start => _selectedCells.first;

  @override
  CellIndex get end => _selectedCells.last;

  @override
  List<CellIndex> get selectedCells => _selectedCells.toList();

  @override
  SelectionCellCorners? get selectionCellCorners => null;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    return mergedSelections.fold(SelectionStatus.statusFalse, (status, mergedSelection) => status.merge(mergedSelection.isColumnSelected(columnIndex)));
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    return mergedSelections.fold(SelectionStatus.statusFalse, (status, mergedSelection) => status.merge(mergedSelection.isRowSelected(rowIndex)));
  }

  @override
  SheetSelection simplify() {
    if (selectedCells.length == 1) {
      return SheetSingleSelection(cellIndex: selectedCells.first);
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
          mergedSelections.add(SheetRangeSelection(start: columnCells[start], end: columnCells[i], completed: true));
          start = i + 1;
        }
      }
    }

    return SheetMultiSelection(selectedCells: selectedCells, mergedSelections: mergedSelections);
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

  CellConfig? get lastSelectedCell => viewportDelegate.findCell(selection.selectedCells.last);
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
        SheetSingleSelectionRenderer sheetSingleSelectionRenderer = mergedSelection.createRenderer(paintConfig);
        CellConfig? selectedCell = sheetSingleSelectionRenderer.selectedCell;
        if (selectedCell == null) {
          return;
        }

        paintSelectionBackground(canvas, selectedCell.rect);
        paintSelectionBorder(canvas, selectedCell.rect);
      }
    }

    CellConfig? selectedCell = renderer.lastSelectedCell;
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

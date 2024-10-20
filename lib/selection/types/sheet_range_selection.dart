import 'package:sheets/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/selection_direction.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
import 'package:sheets/viewport/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection.dart';

class SheetRangeSelection<T extends SheetIndex> extends SheetSelection {
  final T _start;
  final T _end;

  SheetRangeSelection(
    T start,
    T end, {
    super.completed = true,
  })  : _end = end,
        _start = start;

  factory SheetRangeSelection.single(T index, {required bool completed}) {
    return SheetRangeSelection<T>(index, index, completed: completed);
  }

  @override
  SheetRangeSelection<T> copyWith({T? start, T? end, bool? completed}) {
    return SheetRangeSelection<T>(start ?? _start, end ?? _end, completed: completed ?? isCompleted);
  }

  @override
  CellIndex get mainCell => cellStart;

  @override
  T get selectionStart => _start;

  @override
  T get selectionEnd => _end;

  @override
  SelectionCellCorners get cellCorners {
    return SelectionCellCorners.fromDirection(
      topLeft: cellStart,
      topRight: CellIndex(row: rowStart, column: columnEnd),
      bottomLeft: CellIndex(row: rowEnd, column: columnStart),
      bottomRight: cellEnd,
      direction: direction,
    );
  }

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    bool selected = containsColumn(columnIndex);
    return SelectionStatus(selected, allSelected || selected && T == ColumnIndex);
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    bool selected = containsRow(rowIndex);
    return SelectionStatus(selected, allSelected || selected && T == RowIndex);
  }

  bool get allSelected {
    bool startIsZero = selectionStart == CellIndex(row: RowIndex.zero, column: ColumnIndex.zero);
    bool endIsMax = selectionEnd == CellIndex(row: RowIndex.max, column: ColumnIndex.max);

    return startIsZero && endIsMax;
  }

  @override
  SheetSelection complete() {
    return copyWith(completed: true).simplify();
  }

  SheetSelection simplify() {
    if (T == CellIndex && selectionStart == selectionEnd) {
      return SheetSingleSelection(cellStart, completed: isCompleted);
    } else {
      return this;
    }
  }

  @override
  String stringifySelection() {
    return '${selectionStart.stringifyPosition()}:${selectionEnd.stringifyPosition()}';
  }

  @override
  SheetRangeSelectionRenderer<T> createRenderer(SheetViewport viewport) {
    return SheetRangeSelectionRenderer<T>(viewport: viewport, selection: this);
  }

  @override
  SheetSelection modifyEnd(SheetIndex itemIndex) {
    return SheetSelection.range(start: selectionStart, end: itemIndex);
  }

  SelectionDirection get direction {
    bool rowStartBeforeEnd = rowStart.value <= rowEnd.value;
    bool columnStartBeforeEndC = columnStart.value <= columnEnd.value;

    if (rowStartBeforeEnd) {
      return columnStartBeforeEndC ? SelectionDirection.bottomRight : SelectionDirection.bottomLeft;
    } else {
      return columnStartBeforeEndC ? SelectionDirection.topRight : SelectionDirection.topLeft;
    }
  }

  @override
  bool containsSelection(SheetSelection nestedSelection) {
    SelectionCellCorners? nestedCorners = nestedSelection.cellCorners;
    if (nestedCorners == null) return false;

    SelectionCellCorners currentCorners = cellCorners;
    return nestedCorners.isNestedIn(currentCorners);
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) {
    List<SheetRangeSelection<CellIndex>> newSelections = <SheetRangeSelection<CellIndex>>[];

    SelectionCellCorners currentCorners = cellCorners;
    SelectionCellCorners? subtractedCorners = subtractedSelection.cellCorners;
    if (subtractedCorners == null) {
      return <SheetSelection>[this];
    }

    CellIndex currentStart = currentCorners.topLeft;
    CellIndex subtractionStart = subtractedCorners.topLeft;

    CellIndex currentEnd = currentCorners.bottomRight;
    CellIndex subtractionEnd = subtractedCorners.bottomRight;

    if (currentStart.row != subtractionStart.row) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        currentStart,
        CellIndex(row: subtractionStart.row.move(-1), column: currentEnd.column),
        completed: true,
      ));
    }

    if (currentStart.column != subtractionStart.column) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        CellIndex(row: subtractionStart.row, column: currentStart.column),
        CellIndex(row: subtractionEnd.row, column: subtractionStart.column.move(-1)),
        completed: true,
      ));
    }

    if (currentEnd.row != subtractionEnd.row) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        CellIndex(row: subtractionEnd.row.move(1), column: currentStart.column),
        currentEnd,
        completed: true,
      ));
    }

    if (currentEnd.column != subtractionEnd.column) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        CellIndex(row: subtractionStart.row, column: subtractionEnd.column.move(1)),
        CellIndex(row: subtractionEnd.row, column: currentEnd.column),
        completed: true,
      ));
    }

    return newSelections;
  }

  @override
  List<Object?> get props => <Object?>[_start, _end, isCompleted];
}

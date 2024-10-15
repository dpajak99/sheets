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
      topRight: CellIndex(rowIndex: rowStart, columnIndex: columnEnd),
      bottomLeft: CellIndex(rowIndex: rowEnd, columnIndex: columnStart),
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
    bool startIsZero = selectionStart == CellIndex(rowIndex: RowIndex.zero, columnIndex: ColumnIndex.zero);
    bool endIsMax = selectionEnd == CellIndex(rowIndex: RowIndex.max, columnIndex: ColumnIndex.max);

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

    if (currentStart.rowIndex != subtractionStart.rowIndex) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        currentStart,
        CellIndex(rowIndex: subtractionStart.rowIndex.move(-1), columnIndex: currentEnd.columnIndex),
        completed: true,
      ));
    }

    if (currentStart.columnIndex != subtractionStart.columnIndex) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        CellIndex(rowIndex: subtractionStart.rowIndex, columnIndex: currentStart.columnIndex),
        CellIndex(rowIndex: subtractionEnd.rowIndex, columnIndex: subtractionStart.columnIndex.move(-1)),
        completed: true,
      ));
    }

    if (currentEnd.rowIndex != subtractionEnd.rowIndex) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        CellIndex(rowIndex: subtractionEnd.rowIndex.move(1), columnIndex: currentStart.columnIndex),
        currentEnd,
        completed: true,
      ));
    }

    if (currentEnd.columnIndex != subtractionEnd.columnIndex) {
      newSelections.add(SheetRangeSelection<CellIndex>(
        CellIndex(rowIndex: subtractionStart.rowIndex, columnIndex: subtractionEnd.columnIndex.move(1)),
        CellIndex(rowIndex: subtractionEnd.rowIndex, columnIndex: currentEnd.columnIndex),
        completed: true,
      ));
    }

    return newSelections;
  }

  @override
  List<Object?> get props => <Object?>[_start, _end, isCompleted];
}

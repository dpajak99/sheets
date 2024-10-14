import 'package:sheets/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
import 'package:sheets/utils/range.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/selection_direction.dart';
import 'package:sheets/core/sheet_viewport.dart';
import 'package:sheets/selection/sheet_selection.dart';

class SheetRangeSelection<T extends SheetItemIndex> extends SheetSelection {
  final T _start;
  final T _end;

  SheetRangeSelection({
    required T start,
    required T end,
    required super.completed,
  })  : _end = end,
        _start = start;

  @override
  T get start => _start;

  @override
  T get end => _end;

  @override
  Set<CellIndex> get selectedCells {
    SelectionCellCorners selectionCorners = selectionCellCorners;
    List<CellIndex> cells = [];
    for (int rowIndex = selectionCorners.topLeft.rowIndex.value; rowIndex <= selectionCorners.bottomLeft.rowIndex.value; rowIndex++) {
      for (int columnIndex = selectionCorners.topLeft.columnIndex.value; columnIndex <= selectionCorners.topRight.columnIndex.value; columnIndex++) {
        cells.add(CellIndex(rowIndex: RowIndex(rowIndex), columnIndex: ColumnIndex(columnIndex)));
      }
    }
    return cells.toSet();
  }

  @override
  bool containsCell(CellIndex cellIndex) {
    SelectionCellCorners selectionCorners = selectionCellCorners;
    return cellIndex.rowIndex.value >= selectionCorners.topLeft.rowIndex.value &&
        cellIndex.rowIndex.value <= selectionCorners.bottomLeft.rowIndex.value &&
        cellIndex.columnIndex.value >= selectionCorners.topLeft.columnIndex.value &&
        cellIndex.columnIndex.value <= selectionCorners.topRight.columnIndex.value;
  }

  @override
  SelectionCellCorners get selectionCellCorners {
    return SelectionCellCorners.fromDirection(
      topLeft: startCellIndex,
      topRight: CellIndex(rowIndex: startCellIndex.rowIndex, columnIndex: endCellIndex.columnIndex),
      bottomLeft: CellIndex(rowIndex: endCellIndex.rowIndex, columnIndex: startCellIndex.columnIndex),
      bottomRight: endCellIndex,
      direction: direction,
    );
  }

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    bool selected = horizontalRange.contains(columnIndex);

    return SelectionStatus(
      selected,
      allSelected || selected && T == ColumnIndex,
    );
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    bool selected = verticalRange.contains(rowIndex);

    return SelectionStatus(
      selected,
      allSelected || selected && T == RowIndex,
    );

  }

  bool get allSelected {
    bool startIsZero = start == CellIndex(rowIndex: RowIndex.zero, columnIndex: ColumnIndex.zero);
    bool endIsMax = end == CellIndex(rowIndex: RowIndex.max, columnIndex: ColumnIndex.max);

    return startIsZero && endIsMax;
  }

  @override
  SheetSelection complete() => SheetRangeSelection(start: start, end: end, completed: true)..applyProperties(sheetProperties);

  @override
  String stringifySelection() {
    return '${start.stringifyPosition()}:${end.stringifyPosition()}';
  }

  @override
  SheetRangeSelectionRenderer createRenderer(SheetViewport viewportDelegate) {
    return SheetRangeSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  SheetSelection modifyEnd(SheetItemIndex itemIndex, {required bool completed}) {
    return SheetSelection.range(start: start, end: itemIndex, completed: completed);
  }

  Range<ColumnIndex> get horizontalRange => Range(startCellIndex.columnIndex, endCellIndex.columnIndex);

  Range<RowIndex> get verticalRange => Range(startCellIndex.rowIndex, endCellIndex.rowIndex);

  SelectionDirection get direction {
    bool startBeforeEndRow = startCellIndex.rowIndex.value < endCellIndex.rowIndex.value;
    bool startBeforeEndColumn = startCellIndex.columnIndex.value < endCellIndex.columnIndex.value;

    if (startBeforeEndRow) {
      return startBeforeEndColumn ? SelectionDirection.bottomRight : SelectionDirection.bottomLeft;
    } else {
      return startBeforeEndColumn ? SelectionDirection.topRight : SelectionDirection.topLeft;
    }
  }

  @override
  bool containsSelection(SheetSelection nestedSelection) {
    SelectionCellCorners? nestedCorners = nestedSelection.selectionCellCorners;
    if (nestedCorners == null) return false;

    SelectionCellCorners currentCorners = selectionCellCorners;
    return nestedCorners.isNestedIn(currentCorners);
  }

  @override
  List<SheetSelection> subtract(SheetSelection subtractedSelection) {
    if (subtractedSelection.containsCell(startCellIndex) && subtractedSelection.containsCell(endCellIndex)) {
      return [];
    }
    List<SheetRangeSelection> newSelections = [];

    SelectionCellCorners currentCorners = selectionCellCorners;
    SelectionCellCorners? subtractedCorners = subtractedSelection.selectionCellCorners;
    if (subtractedCorners == null) {
      return [this];
    }

    CellIndex currentStart = currentCorners.topLeft;
    CellIndex subtractionStart = subtractedCorners.topLeft;

    CellIndex currentEnd = currentCorners.bottomRight;
    CellIndex subtractionEnd = subtractedCorners.bottomRight;

    if (currentStart.rowIndex != subtractionStart.rowIndex) {
      newSelections.add(SheetRangeSelection(
        start: currentStart,
        end: CellIndex(rowIndex: subtractionStart.rowIndex.move(-1), columnIndex: currentEnd.columnIndex),
        completed: true,
      ));
    }

    if (currentStart.columnIndex != subtractionStart.columnIndex) {
      newSelections.add(SheetRangeSelection(
        start: CellIndex(rowIndex: subtractionStart.rowIndex, columnIndex: currentStart.columnIndex),
        end: CellIndex(rowIndex: subtractionEnd.rowIndex, columnIndex: subtractionStart.columnIndex.move(-1)),
        completed: true,
      ));
    }

    if (currentEnd.rowIndex != subtractionEnd.rowIndex) {
      newSelections.add(SheetRangeSelection(
        start: CellIndex(rowIndex: subtractionEnd.rowIndex.move(1), columnIndex: currentStart.columnIndex),
        end: currentEnd,
        completed: true,
      ));
    }

    if (currentEnd.columnIndex != subtractionEnd.columnIndex) {
      newSelections.add(SheetRangeSelection(
        start: CellIndex(rowIndex: subtractionStart.rowIndex, columnIndex: subtractionEnd.columnIndex.move(1)),
        end: CellIndex(rowIndex: subtractionEnd.rowIndex, columnIndex: currentEnd.columnIndex),
        completed: true,
      ));
    }

    return newSelections;
  }

  @override
  SheetSelection simplify() {
    if (startCellIndex == endCellIndex) {
      return SheetSingleSelection(selectedIndex: startCellIndex, completed: true)..applyProperties(sheetProperties);
    } else {
      return this;
    }
  }

  @override
  List<Object?> get props => [_start, _end, isCompleted];
}

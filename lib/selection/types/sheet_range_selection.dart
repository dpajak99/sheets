import 'package:sheets/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
import 'package:sheets/utils/range.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/selection_direction.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/sheet_selection.dart';

class SheetRangeSelection extends SheetSelection {
  final CellIndex _start;
  final CellIndex _end;

  SheetRangeSelection({
    required CellIndex start,
    required CellIndex end,
    required super.completed,
  })  : _end = end,
        _start = start;

  SheetRangeSelection copyWith({
    CellIndex? start,
    CellIndex? end,
    bool? completed,
  }) {
    return SheetRangeSelection(
      start: start ?? _start,
      end: end ?? _end,
      completed: completed ?? isCompleted,
    );
  }

  @override
  CellIndex get start => _start;

  @override
  CellIndex get end => _end;

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
      topLeft: trueStart,
      topRight: CellIndex(rowIndex: trueStart.rowIndex, columnIndex: trueEnd.columnIndex),
      bottomLeft: CellIndex(rowIndex: trueEnd.rowIndex, columnIndex: trueStart.columnIndex),
      bottomRight: trueEnd,
      direction: direction,
    );
  }

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    bool selected = horizontalRange.contains(columnIndex);
    return SelectionStatus(
      selected,
      selected && verticalRange.containsRange(Range<RowIndex>(RowIndex.zero, RowIndex(sheetProperties.rowCount - 1))),
    );
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    bool selected = verticalRange.contains(rowIndex);
    return SelectionStatus(
      selected,
      selected && horizontalRange.containsRange(Range<ColumnIndex>(ColumnIndex.zero, ColumnIndex(sheetProperties.columnCount - 1))),
    );
  }

  @override
  SheetSelection complete() => copyWith(completed: true);

  @override
  String stringifySelection() {
    return '${trueStart.stringifyPosition()}:${trueEnd.stringifyPosition()}';
  }

  @override
  SheetRangeSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetRangeSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  SheetSelection modifyEnd(CellIndex cellIndex, {required bool completed}) {
    return copyWith(end: cellIndex, completed: completed);
  }

  Range<ColumnIndex> get horizontalRange => Range(trueStart.columnIndex, trueEnd.columnIndex);

  Range<RowIndex> get verticalRange => Range(trueStart.rowIndex, trueEnd.rowIndex);

  SelectionDirection get direction {
    bool startBeforeEndRow = trueStart.rowIndex.value < trueEnd.rowIndex.value;
    bool startBeforeEndColumn = trueStart.columnIndex.value < trueEnd.columnIndex.value;

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
    if (subtractedSelection.containsCell(trueStart) && subtractedSelection.containsCell(trueEnd)) {
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
    if (trueStart == trueEnd) {
      return SheetSingleSelection(selectedIndex: trueStart, completed: true);
    } else {
      return this;
    }
  }

  @override
  List<Object?> get props => [_start, _end, isCompleted];
}




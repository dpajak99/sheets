import 'package:flutter/material.dart';
import 'package:sheets/utils/range.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_bounds.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/selection_direction.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
import 'package:sheets/utils/cached_value.dart';
import 'package:sheets/utils/direction.dart';

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
  SheetSelection simplify() {
    if (trueStart == trueEnd) {
      return SheetSingleSelection(cellIndex: trueStart, completed: isCompleted)..applyProperties(sheetProperties);
    }
    return this;
  }

  @override
  String stringifySelection() {
    return '${trueStart.stringifyPosition()}:${trueEnd.stringifyPosition()}';
  }

  @override
  SheetRangeSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetRangeSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
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
  List<Object?> get props => [_start, _end, isCompleted];
}

class SheetRangeSelectionRenderer extends SheetSelectionRenderer {
  final SheetRangeSelection selection;
  late final CachedValue<SelectionBounds?> _selectionBounds;

  SheetRangeSelectionRenderer({
    required super.viewportDelegate,
    required this.selection,
  }) {
    _selectionBounds = CachedValue<SelectionBounds?>(_calculateSelectionBounds);
  }

  @override
  bool get fillHandleVisible => selection.isCompleted;

  @override
  Offset? get fillHandleOffset => selectionBounds?.selectionRect.bottomRight;

  @override
  SheetSelectionPaint get paint => SheetRangeSelectionPaint(this);

  SelectionBounds? get selectionBounds => _selectionBounds.value;

  SelectionBounds? _calculateSelectionBounds() {
    CellConfig? startCell = viewportDelegate.findCell(selection.trueStart);
    CellConfig? endCell = viewportDelegate.findCell(selection.trueEnd);

    if (startCell != null && endCell != null) {
      return SelectionBounds(startCell, endCell, selection.direction);
    }

    if (startCell == null && endCell != null) {
      ClosestVisible<CellIndex> startClosest = viewportDelegate.findClosestVisible(selection.trueStart);
      CellConfig updatedStartCell = viewportDelegate.findCell(startClosest.item) as CellConfig;
      return SelectionBounds(updatedStartCell, endCell, selection.direction, hiddenBorders: startClosest.hiddenBorders, startCellVisible: false);
    }

    if (startCell != null && endCell == null) {
      ClosestVisible<CellIndex> endClosest = viewportDelegate.findClosestVisible(selection.trueEnd);
      CellConfig updatedEndCell = viewportDelegate.findCell(endClosest.item) as CellConfig;

      return SelectionBounds(startCell, updatedEndCell, selection.direction, hiddenBorders: endClosest.hiddenBorders, lastCellVisible: false);
    }

    if (startCell == null && endCell == null && (_isFullHeightSelection || _isFullWidthSelection)) {
      ClosestVisible<CellIndex> startClosest = viewportDelegate.findClosestVisible(selection.trueStart);
      ClosestVisible<CellIndex> endClosest = viewportDelegate.findClosestVisible(selection.trueEnd);

      CellConfig updatedStartCell = viewportDelegate.findCell(startClosest.item) as CellConfig;
      CellConfig updatedEndCell = viewportDelegate.findCell(endClosest.item) as CellConfig;

      List<Direction> hiddenBorders = [...startClosest.hiddenBorders, ...endClosest.hiddenBorders];

      return SelectionBounds(updatedStartCell, updatedEndCell, selection.direction, hiddenBorders: hiddenBorders, startCellVisible: false);
    }

    return null;
  }

  bool get _isFullHeightSelection {
    List<RowConfig> visibleRows = viewportDelegate.visibleRows;
    bool vertical1 = selection.trueStart.rowIndex < visibleRows.first.rowIndex && selection.trueEnd.rowIndex > visibleRows.last.rowIndex;
    bool vertical2 = selection.trueEnd.rowIndex < visibleRows.first.rowIndex && selection.trueStart.rowIndex > visibleRows.last.rowIndex;

    return vertical1 || vertical2;
  }

  bool get _isFullWidthSelection {
    List<ColumnConfig> visibleColumns = viewportDelegate.visibleColumns;
    bool horizontal1 = selection.trueStart.columnIndex < visibleColumns.first.columnIndex && selection.trueEnd.columnIndex > visibleColumns.last.columnIndex;
    bool horizontal2 = selection.trueEnd.columnIndex < visibleColumns.first.columnIndex && selection.trueStart.columnIndex > visibleColumns.last.columnIndex;

    return horizontal1 || horizontal2;
  }
}

class SheetRangeSelectionPaint extends SheetSelectionPaint {
  final SheetRangeSelectionRenderer renderer;

  SheetRangeSelectionPaint(this.renderer);

  @override
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size) {
    SelectionBounds? selectionBounds = renderer.selectionBounds;
    if (selectionBounds == null) {
      return;
    }

    Rect selectionRect = selectionBounds.selectionRect;

    if (selectionBounds.isStartCellVisible) {
      paintMainCell(canvas, selectionBounds.mainCellRect);
    }

    paintSelectionBackground(canvas, selectionRect);

    if (renderer.selection.isCompleted) {
      paintSelectionBorder(
        canvas,
        selectionRect,
        top: selectionBounds.isTopBorderVisible,
        right: selectionBounds.isRightBorderVisible,
        bottom: selectionBounds.isBottomBorderVisible,
        left: selectionBounds.isLeftBorderVisible,
      );
    }
  }
}

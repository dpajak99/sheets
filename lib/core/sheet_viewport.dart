import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/directional_values.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/utils/direction.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

class SheetViewport extends ChangeNotifier {
  final SheetScrollController scrollController;

  Rect _sheetRect = Rect.zero;

  void setViewportSize(Rect rect) {
    if (rect == _sheetRect) return;
    _sheetRect = rect;
    scrollController.setViewportSize(rect.size);
    _recalculateVisibleElements();
  }

  Rect get sheetRect => _sheetRect;

  Rect get visibleGridRect {
    return Rect.fromLTRB(
      max(visibleColumns.first.rect.left, sheetRect.left),
      min(visibleRows.first.rect.top, sheetRect.top),
      min(visibleColumns.last.rect.right, sheetRect.right),
      min(visibleRows.last.rect.bottom, sheetRect.bottom),
    );
  }

  Offset globalOffsetToLocal(Offset globalOffset) {
    Offset localOffset = globalOffset - Offset(sheetRect.left, sheetRect.top);
    return localOffset.limit(
      Offset(0, visibleGridRect.right),
      Offset(0, visibleGridRect.bottom),
    );
  }

  SheetViewport({
    required SheetProperties sheetProperties,
    required this.scrollController,
  }) {
    _sheetProperties = sheetProperties;
    _scrollPosition = scrollController.position;
    _recalculateVisibleElements();

    sheetProperties.addListener(() => _updateSheetProperties(sheetProperties));
    scrollController.addListener(() => _updateScrollPosition(scrollController));
  }

  SheetProperties get properties => _sheetProperties;

  List<RowConfig> get visibleRows => _visibleRows;
  List<RowConfig> _visibleRows = <RowConfig>[];

  List<ColumnConfig> get visibleColumns => _visibleColumns;
  List<ColumnConfig> _visibleColumns = <ColumnConfig>[];

  List<CellConfig> get visibleCells => _visibleCells;
  List<CellConfig> _visibleCells = <CellConfig>[];

  List<SheetItemConfig> get visibleItems => [...visibleRows, ...visibleColumns, ...visibleCells];

  late DirectionalValues<SheetScrollPosition> _scrollPosition;

  void _updateScrollPosition(SheetScrollController scrollController) {
    _scrollPosition = scrollController.position;
    _recalculateVisibleElements();
  }

  late SheetProperties _sheetProperties;

  void _updateSheetProperties(SheetProperties sheetProperties) {
    _sheetProperties = sheetProperties;
    _recalculateVisibleElements();
  }

  void _recalculateVisibleElements() {
    _visibleRows = _calculateVisibleRows();
    _visibleColumns = _calculateVisibleColumns();
    _visibleCells = _calculateVisibleCells(_visibleRows, _visibleColumns);
    notifyListeners();
  }

  SheetItemConfig? findByOffset(Offset mousePosition) {
    try {
      SheetItemConfig sheetItemConfig = visibleItems.firstWhere(
        (element) => element.rect.within(mousePosition),
      );
      return sheetItemConfig;
    } catch (e) {
      return null;
    }
  }

  ClosestVisible<CellIndex> findClosestVisible(CellIndex cellIndex) {
    ClosestVisible<RowIndex> closestVisibleRowIndex = _findClosestVisibleRowIndex(cellIndex);
    ClosestVisible<ColumnIndex> closestVisibleColumnIndex = _findVisibleColumnIndex(cellIndex);

    return ClosestVisible.combineCellIndex(closestVisibleRowIndex, closestVisibleColumnIndex);
  }

  CellConfig? findCell(CellIndex cellIndex) {
    return visibleCells.where((cell) => cell.cellIndex == cellIndex).firstOrNull;
  }

  bool containsCell(CellIndex cellIndex) {
    return visibleCells.any((cell) => cell.cellIndex == cellIndex);
  }

  (RowIndex, double) calculateFirstVisibleRow() {
    double contentHeight = 0;
    int hiddenRows = 0;

    while (contentHeight < _scrollPosition.vertical.offset) {
      hiddenRows++;
      double rowHeight = _sheetProperties.getRowHeight(RowIndex(hiddenRows));
      contentHeight += rowHeight;
    }

    double rowHeight = _sheetProperties.getRowHeight(RowIndex(hiddenRows));
    double verticalOverscroll = _scrollPosition.vertical.offset - contentHeight;
    if (verticalOverscroll != 0) {
      double hiddenHeight = ((-rowHeight) - verticalOverscroll);
      return (RowIndex(hiddenRows), hiddenHeight);
    } else {
      return (RowIndex(hiddenRows), 0);
    }
  }

  (ColumnIndex, double) calculateFirstVisibleColumn() {
    double contentWidth = 0;
    int hiddenColumns = 0;

    while (contentWidth < _scrollPosition.horizontal.offset) {
      hiddenColumns++;
      double columnWidth = _sheetProperties.getColumnWidth(ColumnIndex(hiddenColumns));
      contentWidth += columnWidth;
    }

    double columnWidth = _sheetProperties.getColumnWidth(ColumnIndex(hiddenColumns));
    double horizontalOverscroll = _scrollPosition.horizontal.offset - contentWidth;

    if (horizontalOverscroll != 0) {
      double hiddenWidth = ((-columnWidth) - horizontalOverscroll);
      return (ColumnIndex(hiddenColumns), hiddenWidth);
    } else {
      return (ColumnIndex(hiddenColumns), 0);
    }
  }

  List<RowConfig> _calculateVisibleRows() {
    List<RowConfig> visibleRows = [];

    RowIndex firstVisibleRow;
    double hiddenHeight;
    (firstVisibleRow, hiddenHeight) = calculateFirstVisibleRow();

    double cursorSheetHeight = hiddenHeight;

    int index = 0;

    while (cursorSheetHeight < _sheetRect.height && firstVisibleRow.value + index < properties.rowCount) {
      RowIndex rowIndex = RowIndex(firstVisibleRow.value + index);
      RowStyle rowStyle = _sheetProperties.getRowStyle(rowIndex);

      RowConfig rowConfig = RowConfig(
        rowIndex: rowIndex,
        rowStyle: rowStyle,
        rect: Rect.fromLTWH(0, cursorSheetHeight + columnHeadersHeight, rowHeadersWidth, rowStyle.height),
      );
      visibleRows.add(rowConfig);

      index++;
      cursorSheetHeight += rowConfig.rowStyle.height;
    }
    return visibleRows;
  }

  List<ColumnConfig> _calculateVisibleColumns() {
    List<ColumnConfig> visibleColumns = [];

    ColumnIndex firstVisibleColumn;
    double hiddenWidth;
    (firstVisibleColumn, hiddenWidth) = calculateFirstVisibleColumn();

    double cursorSheetWidth = hiddenWidth;
    int index = 0;

    while (cursorSheetWidth < _sheetRect.width && firstVisibleColumn.value + index < properties.columnCount) {
      ColumnIndex columnIndex = ColumnIndex(firstVisibleColumn.value + index);
      ColumnStyle columnStyle = _sheetProperties.getColumnStyle(columnIndex);

      ColumnConfig columnConfig = ColumnConfig(
        columnIndex: columnIndex,
        columnStyle: columnStyle,
        rect: Rect.fromLTWH(cursorSheetWidth + rowHeadersWidth, 0, columnStyle.width, columnHeadersHeight),
      );

      visibleColumns.add(columnConfig);

      cursorSheetWidth += columnConfig.columnStyle.width;
      index++;
    }

    return visibleColumns;
  }

  List<CellConfig> _calculateVisibleCells(List<RowConfig> visibleRows, List<ColumnConfig> visibleColumns) {
    List<CellConfig> visibleCells = [];

    for (RowConfig row in visibleRows) {
      for (ColumnConfig column in visibleColumns) {
        CellConfig cellConfig = CellConfig.fromColumnRow(column, row, value: '');
        visibleCells.add(cellConfig);
      }
    }

    return visibleCells;
  }

  ClosestVisible<RowIndex> _findClosestVisibleRowIndex(CellIndex cellIndex) {
    RowIndex firstVisibleRow = _visibleRows.first.rowIndex;
    RowIndex lastVisibleRow = _visibleRows.last.rowIndex;
    RowIndex cellRow = cellIndex.rowIndex;

    bool visible = cellRow >= firstVisibleRow && cellRow <= lastVisibleRow;
    bool missingTop = cellRow < firstVisibleRow;

    if (visible) {
      return ClosestVisible<RowIndex>.fullyVisible(cellRow);
    } else if (missingTop) {
      return ClosestVisible<RowIndex>.partiallyVisible(hiddenBorders: [Direction.top], item: firstVisibleRow);
    } else {
      return ClosestVisible<RowIndex>.partiallyVisible(hiddenBorders: [Direction.bottom], item: lastVisibleRow);
    }
  }

  ClosestVisible<ColumnIndex> _findVisibleColumnIndex(CellIndex cellIndex) {
    ColumnIndex firstVisibleColumn = _visibleColumns.first.columnIndex;
    ColumnIndex lastVisibleColumn = _visibleColumns.last.columnIndex;
    ColumnIndex cellColumn = cellIndex.columnIndex;

    bool visible = cellColumn >= firstVisibleColumn && cellColumn <= lastVisibleColumn;
    bool missingLeft = cellColumn < firstVisibleColumn;

    if (visible) {
      return ClosestVisible<ColumnIndex>.fullyVisible(cellColumn);
    } else if (missingLeft) {
      return ClosestVisible<ColumnIndex>.partiallyVisible(hiddenBorders: [Direction.left], item: firstVisibleColumn);
    } else {
      return ClosestVisible<ColumnIndex>.partiallyVisible(hiddenBorders: [Direction.right], item: lastVisibleColumn);
    }
  }
}

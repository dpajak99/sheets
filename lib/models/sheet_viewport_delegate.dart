import 'package:flutter/material.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/models/sheet_item_config.dart';
import 'package:sheets/models/sheet_properties.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/config/sheet_constants.dart';
import 'package:sheets/models/closest_visible.dart';
import 'package:sheets/models/directional_values.dart';
import 'package:sheets/models/sheet_scroll_metrics.dart';
import 'package:sheets/models/sheet_scroll_position.dart';
import 'package:sheets/utils/direction.dart';

abstract class SheetViewportDelegate extends ChangeNotifier {
  CellConfig? findCell(CellIndex cellIndex);

  SheetItemConfig? findByOffset(Offset mousePosition);

  ClosestVisible<CellIndex> findClosestVisible(CellIndex cellIndex);

  bool containsCell(CellIndex cellIndex);

  List<RowConfig> get visibleRows;

  List<ColumnConfig> get visibleColumns;

  List<CellConfig> get visibleCells;

  List<SheetItemConfig> get visibleItems => [...visibleRows, ...visibleColumns, ...visibleCells];
}

class SheetViewportBaseDelegate extends SheetViewportDelegate {
  SheetViewportBaseDelegate({
    required SheetProperties sheetProperties,
    required SheetScrollController scrollController,
  }) {
    _sheetProperties = sheetProperties;
    _scrollPosition = scrollController.position;
    _scrollMetrics = scrollController.metrics;

    sheetProperties.addListener(() => _updateSheetProperties(sheetProperties));
    scrollController.addListener(() => _updateScrollPosition(scrollController));
  }

  @override
  List<RowConfig> get visibleRows => _visibleRows;
  List<RowConfig> _visibleRows = <RowConfig>[];

  @override
  List<ColumnConfig> get visibleColumns => _visibleColumns;
  List<ColumnConfig> _visibleColumns = <ColumnConfig>[];

  @override
  List<CellConfig> get visibleCells => _visibleCells;
  List<CellConfig> _visibleCells = <CellConfig>[];

  late DirectionalValues<SheetScrollPosition> _scrollPosition;
  late DirectionalValues<SheetScrollMetrics> _scrollMetrics;

  void _updateScrollPosition(SheetScrollController scrollController) {
    _scrollPosition = scrollController.position;
    _scrollMetrics = scrollController.metrics;
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

  @override
  SheetItemConfig? findByOffset(Offset mousePosition) {
    try {
      SheetItemConfig sheetItemConfig = visibleItems.firstWhere(
        (element) => element.rect.contains(mousePosition),
      );
      return sheetItemConfig;
    } catch (e) {
      return null;
    }
  }

  @override
  ClosestVisible<CellIndex> findClosestVisible(CellIndex cellIndex) {
    ClosestVisible<RowIndex> closestVisibleRowIndex = _findClosestVisibleRowIndex(cellIndex);
    ClosestVisible<ColumnIndex> closestVisibleColumnIndex = _findVisibleColumnIndex(cellIndex);

    return ClosestVisible.combineCellIndex(closestVisibleRowIndex, closestVisibleColumnIndex);
  }

  @override
  CellConfig? findCell(CellIndex cellIndex) {
    return visibleCells.where((cell) => cell.index == cellIndex).firstOrNull;
  }

  @override
  bool containsCell(CellIndex cellIndex) {
    return visibleCells.any((cell) => cell.index == cellIndex);
  }

  (RowIndex, double) get _firstVisibleRow {
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

  (ColumnIndex, double) get _firstVisibleColumn {
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
    (firstVisibleRow, hiddenHeight) = _firstVisibleRow;

    double cursorSheetHeight = hiddenHeight;

    int index = 0;

    while (cursorSheetHeight < _scrollMetrics.vertical.viewportDimension && firstVisibleRow.value + index < defaultRowCount) {
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
    (firstVisibleColumn, hiddenWidth) = _firstVisibleColumn;

    double cursorSheetWidth = hiddenWidth;
    int index = 0;

    while (cursorSheetWidth < _scrollMetrics.horizontal.viewportDimension && firstVisibleColumn.value + index < defaultColumnCount) {
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

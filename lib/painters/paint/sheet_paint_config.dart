import 'package:flutter/material.dart';
import 'package:sheets/controller/custom_scroll_controller.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils/direction.dart';

class SheetProperties {
  final Map<ColumnIndex, ColumnStyle> customColumnProperties;
  final Map<RowIndex, RowStyle> customRowProperties;

  SheetProperties({
    required this.customColumnProperties,
    required this.customRowProperties,
  });

  RowStyle getRowStyle(RowIndex rowIndex) {
    return customRowProperties[rowIndex] ?? RowStyle.defaults();
  }

  void setRowStyle(RowIndex rowIndex, RowStyle rowStyle) {
    customRowProperties[rowIndex] = rowStyle;
  }

  ColumnStyle getColumnStyle(ColumnIndex columnIndex) {
    return customColumnProperties[columnIndex] ?? ColumnStyle.defaults();
  }

  void setColumnStyle(ColumnIndex columnIndex, ColumnStyle columnStyle) {
    customColumnProperties[columnIndex] = columnStyle;
  }


  Map<int, double> get customRowExtents {
    return customRowProperties.map((key, value) => MapEntry(key.value, value.height));
  }

  Map<int, double> get customColumnExtents {
    return customColumnProperties.map((key, value) => MapEntry(key.value, value.width));
  }
}

class SheetPaintConfig extends ChangeNotifier {
  final SheetController sheetController;

  Size canvasSize = Size.zero;

  List<RowConfig> visibleRows = <RowConfig>[];
  List<ColumnConfig> visibleColumns = <ColumnConfig>[];
  List<CellConfig> visibleCells = <CellConfig>[];


  List<SheetItemConfig> get visibleItems => [...visibleRows, ...visibleColumns, ...visibleCells];

  SheetPaintConfig({
    required this.sheetController,
  });

  void resize(Size size) {
    canvasSize = size;
    refresh();
  }

  void refresh() {
    if (canvasSize == Size.zero) {
      return;
    }

    visibleRows = _calculateVisibleRows();
    visibleColumns = _calculateVisibleColumns();
    visibleCells = _calculateVisibleCells(visibleRows, visibleColumns);

    notifyListeners();
  }

  (Direction, Direction, CellConfig) findClosestVisible(CellIndex cellIndex) {
    Direction verticalDirection, horizontalDirection;
    RowIndex rowIndex;
    ColumnIndex columnIndex;

    (verticalDirection, rowIndex) = _findVisibleRowIndex(cellIndex);
    (horizontalDirection, columnIndex) = _findVisibleColumnIndex(cellIndex);

    CellIndex closestCellIndex = CellIndex(
      rowIndex: rowIndex,
      columnIndex: columnIndex,
    );
    return (verticalDirection, horizontalDirection, findCell(closestCellIndex)!);
  }

  (Direction, RowIndex) _findVisibleRowIndex(CellIndex cellIndex) {
    RowIndex firstVisibleRow = visibleRows.first.rowIndex;
    RowIndex lastVisibleRow = visibleRows.last.rowIndex;
    RowIndex cellRow = cellIndex.rowIndex;

    bool visible = cellRow >= firstVisibleRow && cellRow <= lastVisibleRow;
    bool missingTop = cellRow < firstVisibleRow;

    if (visible) {
      return (Direction.center, cellRow);
    } else if (missingTop) {
      return (Direction.top, firstVisibleRow);
    } else {
      return (Direction.bottom, lastVisibleRow);
    }
  }

  (Direction, ColumnIndex) _findVisibleColumnIndex(CellIndex cellIndex) {
    ColumnIndex firstVisibleColumn = visibleColumns.first.columnIndex;
    ColumnIndex lastVisibleColumn = visibleColumns.last.columnIndex;
    ColumnIndex cellColumn = cellIndex.columnIndex;

    bool visible = cellColumn >= firstVisibleColumn && cellColumn <= lastVisibleColumn;
    bool missingLeft = cellColumn < firstVisibleColumn;

    if (visible) {
      return (Direction.center, cellColumn);
    } else if (missingLeft) {
      return (Direction.left, firstVisibleColumn);
    } else {
      return (Direction.right, lastVisibleColumn);
    }
  }

  CellConfig? findCell(CellIndex cellIndex) {
    return visibleCells.where((cell) => cell.cellIndex == cellIndex).firstOrNull;
  }

  bool containsCell(CellIndex cellIndex) {
    return visibleCells.any((cell) => cell.cellIndex == cellIndex);
  }

  List<RowConfig> _calculateVisibleRows() {
    List<RowConfig> visibleRows = [];

    RowIndex firstVisibleRow;
    double hiddenHeight;
    (hiddenHeight, firstVisibleRow) = sheetController.scrollController.firstVisibleRow;

    double cursorSheetHeight = hiddenHeight;

    int index = 0;

    while (cursorSheetHeight < canvasSize.height && firstVisibleRow.value + index < defaultRowCount) {
      RowIndex rowIndex = RowIndex(firstVisibleRow.value + index);
      RowStyle rowStyle = sheetController.sheetProperties.getRowStyle(rowIndex);

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
    (hiddenWidth, firstVisibleColumn) = sheetController.scrollController.firstVisibleColumn;

    double cursorSheetWidth = hiddenWidth;
    int index = 0;

    while (cursorSheetWidth < canvasSize.width && firstVisibleColumn.value + index < defaultColumnCount) {
      ColumnIndex columnIndex = ColumnIndex(firstVisibleColumn.value + index);
      ColumnStyle columnStyle = sheetController.sheetProperties.getColumnStyle(columnIndex);

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
}

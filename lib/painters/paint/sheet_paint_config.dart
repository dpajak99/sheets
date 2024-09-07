import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils/direction.dart';

class SheetPaintConfig extends ChangeNotifier {
  final Map<ColumnIndex, ColumnStyle> customColumnProperties;
  final Map<RowIndex, RowStyle> customRowProperties;
  final SheetController sheetController;

  Size canvasSize = Size.zero;

  List<RowConfig> visibleRows = <RowConfig>[];
  List<ColumnConfig> visibleColumns = <ColumnConfig>[];
  List<CellConfig> visibleCells = <CellConfig>[];

  SheetPaintConfig({
    required this.customColumnProperties,
    required this.customRowProperties,
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

  List<SheetItemConfig> get visibleItems {
    List<SheetItemConfig> elements = [];
    elements.addAll(visibleRows);
    elements.addAll(visibleColumns);
    elements.addAll(visibleCells);
    return elements;
  }

  (Direction, Direction, CellConfig) findClosestVisible(CellIndex cellIndex) {
    Direction verticalDirection;
    Direction horizontalDirection;
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
    double cursorSheetHeight = 0;
    int index = 0;

    while (cursorSheetHeight < canvasSize.height) {
      RowIndex rowIndex = RowIndex(sheetController.scrollOffset.dy + index);
      RowStyle rowStyle = customRowProperties[rowIndex] ?? RowStyle.defaults();

      RowConfig rowConfig = RowConfig(
        rowIndex: rowIndex,
        rowStyle: rowStyle,
        rect: Rect.fromLTWH(0, cursorSheetHeight + columnHeadersHeight, rowHeadersWidth, rowStyle.height),
      );
      visibleRows.add(rowConfig);

      cursorSheetHeight += rowConfig.rowStyle.height;
      index++;
    }

    return visibleRows;
  }

  List<ColumnConfig> _calculateVisibleColumns() {
    List<ColumnConfig> visibleColumns = [];
    double cursorSheetWidth = 0;
    int index = 0;

    while (cursorSheetWidth < canvasSize.width) {
      ColumnIndex columnIndex = ColumnIndex(sheetController.scrollOffset.dx + index);
      ColumnStyle columnStyle = customColumnProperties[columnIndex] ?? ColumnStyle.defaults();

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
        CellConfig cellConfig = CellConfig.fromColumnRow(column, row);
        visibleCells.add(cellConfig);
      }
    }

    return visibleCells;
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
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

class SheetVisibilityController extends ChangeNotifier {
  SheetVisibilityController({
    required this.sheetProperties,
    required this.scrollController,
  }) : super() {
    scrollController.metrics.addListener(refresh);
    scrollController.position.addListener(() {
      print('position listener');
      refresh();
    });
    refresh();
  }

  final SheetProperties sheetProperties;
  final SheetScrollController scrollController;

  List<RowConfig> visibleRows = <RowConfig>[];
  List<ColumnConfig> visibleColumns = <ColumnConfig>[];
  List<CellConfig> visibleCells = <CellConfig>[];

  List<SheetItemConfig> get visibleItems => [...visibleRows, ...visibleColumns, ...visibleCells];

  void refresh() {
    print('refresh');
    visibleRows = _calculateVisibleRows();
    visibleColumns = _calculateVisibleColumns();
    visibleCells = _calculateVisibleCells(visibleRows, visibleColumns);

    notifyListeners();
  }

  SheetItemConfig? findHoveredElement(Offset mousePosition) {
    try {
      SheetItemConfig sheetItemConfig = visibleItems.firstWhere(
        (element) => element.rect.contains(mousePosition),
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

  ClosestVisible<RowIndex> _findClosestVisibleRowIndex(CellIndex cellIndex) {
    RowIndex firstVisibleRow = visibleRows.first.rowIndex;
    RowIndex lastVisibleRow = visibleRows.last.rowIndex;
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
    ColumnIndex firstVisibleColumn = visibleColumns.first.columnIndex;
    ColumnIndex lastVisibleColumn = visibleColumns.last.columnIndex;
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

  CellConfig? findCell(CellIndex cellIndex) {
    return visibleCells.where((cell) => cell.index == cellIndex).firstOrNull;
  }

  bool containsCell(CellIndex cellIndex) {
    return visibleCells.any((cell) => cell.index == cellIndex);
  }

  List<RowConfig> _calculateVisibleRows() {
    List<RowConfig> visibleRows = [];

    RowIndex firstVisibleRow;
    double hiddenHeight;
    (firstVisibleRow, hiddenHeight) = scrollController.firstVisibleRow;

    double cursorSheetHeight = hiddenHeight;

    int index = 0;

    while (cursorSheetHeight < scrollController.metrics.vertical.viewportDimension && firstVisibleRow.value + index < defaultRowCount) {
      RowIndex rowIndex = RowIndex(firstVisibleRow.value + index);
      RowStyle rowStyle = sheetProperties.getRowStyle(rowIndex);

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
    (firstVisibleColumn, hiddenWidth) = scrollController.firstVisibleColumn;

    double cursorSheetWidth = hiddenWidth;
    int index = 0;

    while (cursorSheetWidth < scrollController.metrics.horizontal.viewportDimension && firstVisibleColumn.value + index < defaultColumnCount) {
      ColumnIndex columnIndex = ColumnIndex(firstVisibleColumn.value + index);
      ColumnStyle columnStyle = sheetProperties.getColumnStyle(columnIndex);

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

class ClosestVisible<T extends SheetItemIndex> with EquatableMixin {
  final List<Direction> hiddenBorders;
  final T item;

  ClosestVisible._({required this.hiddenBorders, required this.item});

  ClosestVisible.fullyVisible(this.item) : hiddenBorders = [];

  ClosestVisible.partiallyVisible({required this.hiddenBorders, required this.item});

  static ClosestVisible<CellIndex> combineCellIndex(ClosestVisible<RowIndex> rowIndex, ClosestVisible<ColumnIndex> columnIndex) {
    return ClosestVisible<CellIndex>._(
      hiddenBorders: [...rowIndex.hiddenBorders, ...columnIndex.hiddenBorders],
      item: CellIndex(rowIndex: rowIndex.item, columnIndex: columnIndex.item),
    );
  }

  @override
  List<Object?> get props => [hiddenBorders, item];
}

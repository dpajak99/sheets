import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/utils.dart';

double columnHeadersHeight = 24;
double rowHeadersWidth = 46;
double cellHeight = 22;
double cellWidth = 100;

class ColumnProperties with EquatableMixin {
  final double width;

  ColumnProperties({
    required this.width,
  });

  ColumnProperties.defaults() : width = 100;

  @override
  List<Object?> get props => [width];
}

class ColumnKey with EquatableMixin {
  final int value;

  ColumnKey(this.value);

  @override
  List<Object?> get props => [value];
}

class RowProperties with EquatableMixin {
  final double height;

  RowProperties({
    required this.height,
  });

  RowProperties.defaults() : height = 22;

  @override
  List<Object?> get props => [height];
}

class RowKey with EquatableMixin {
  final int value;

  RowKey(this.value);

  @override
  List<Object?> get props => [value];
}

class ProgramRowConfig with EquatableMixin {
  final RowKey rowKey;
  final RowProperties rowProperties;
  final Rect sheetRect;
  final bool selected;

  ProgramRowConfig({
    required this.rowKey,
    required this.rowProperties,
    required this.sheetRect,
    required this.selected,
  });

  @override
  List<Object?> get props => [rowKey, rowProperties, sheetRect, selected];
}

class ProgramColumnConfig with EquatableMixin {
  final ColumnKey columnKey;
  final ColumnProperties columnProperties;
  final Rect headerRect;
  final bool selected;

  ProgramColumnConfig({
    required this.columnKey,
    required this.columnProperties,
    required this.headerRect,
    required this.selected,
  });

  @override
  List<Object?> get props => [columnKey, columnProperties, headerRect, selected];
}

class ProgramCellConfig with EquatableMixin {
  final CellKey cellKey;
  final ProgramRowConfig programRowConfig;
  final ProgramColumnConfig programColumnConfig;
  final Rect rect;

  ProgramCellConfig({
    required this.cellKey,
    required this.programRowConfig,
    required this.programColumnConfig,
    required this.rect,
  });

  bool get selected => programRowConfig.selected && programColumnConfig.selected;

  @override
  List<Object?> get props => [programRowConfig, programColumnConfig];
}

class SheetVisibilityConfig with EquatableMixin {
  final List<ProgramRowConfig> visibleRows;
  final List<ProgramColumnConfig> visibleColumns;
  final List<ProgramCellConfig> visibleCells;

  SheetVisibilityConfig({
    required this.visibleRows,
    required this.visibleColumns,
    required this.visibleCells,
  });

  List<ProgramCellConfig> getSelectedCells(SheetSelection selection) {
    return visibleCells.where((cell) => selection.selectedCells.contains(cell.cellKey)).toList();
  }

  @override
  List<Object?> get props => [visibleRows, visibleColumns];
}

class CellKey with EquatableMixin {
  final RowKey rowKey;
  final ColumnKey columnKey;

  CellKey({
    required this.rowKey,
    required this.columnKey,
  });

  @override
  List<Object?> get props => [rowKey, columnKey];
}

abstract class SheetSelection {
  List<CellKey> get selectedCells;

  bool isColumnSelected(ColumnKey columnKey);

  bool isRowSelected(RowKey rowKey);

  int get length => selectedCells.length;

  bool get isCompleted => length > 0;

  bool get isEmpty => length == 0;
}

class SheetEmptySelection extends SheetSelection {
  @override
  List<CellKey> get selectedCells => [];

  @override
  bool isColumnSelected(ColumnKey columnKey) => false;

  @override
  bool isRowSelected(RowKey rowKey) => false;
}

class SheetRangeSelection extends SheetSelection {
  final CellKey start;
  final CellKey end;

  SheetRangeSelection({
    required this.start,
    required this.end,
  });

  @override
  List<CellKey> get selectedCells {
    List<CellKey> selectedCells = [];
    for (int row = start.rowKey.value; row <= end.rowKey.value; row++) {
      for (int column = start.columnKey.value; column <= end.columnKey.value; column++) {
        selectedCells.add(CellKey(rowKey: RowKey(row), columnKey: ColumnKey(column)));
      }
    }
    return selectedCells;
  }

  @override
  bool isColumnSelected(ColumnKey columnKey) {
    return columnKey.value >= start.columnKey.value && columnKey.value <= end.columnKey.value;
  }

  @override
  bool isRowSelected(RowKey rowKey) {
    return rowKey.value >= start.rowKey.value && rowKey.value <= end.rowKey.value;
  }
}

class SheetController {
  final Map<ColumnKey, ColumnProperties> customColumnProperties;
  final Map<RowKey, RowProperties> customRowProperties;

  // SheetSelection selection = SheetEmptySelection();
  SheetSelection selection = SheetRangeSelection(
    start: CellKey(rowKey: RowKey(2), columnKey: ColumnKey(2)),
    end: CellKey(rowKey: RowKey(10), columnKey: ColumnKey(10)),
  );
  IntOffset sheetOffset = IntOffset.zero;

  SheetController({
    this.customColumnProperties = const {},
    this.customRowProperties = const {},
  });

  SheetVisibilityConfig getVisibilityConfig(Size sheetSize) {
    List<ProgramRowConfig> visibleRows = getVisibleRows(sheetSize.height);
    List<ProgramColumnConfig> visibleColumns = getVisibleColumns(sheetSize.width);
    List<ProgramCellConfig> visibleCells = getVisibleCells(visibleRows, visibleColumns);

    return SheetVisibilityConfig(
      visibleRows: visibleRows,
      visibleColumns: visibleColumns,
      visibleCells: visibleCells,
    );
  }

  List<ProgramRowConfig> getVisibleRows(double sheetHeight) {
    List<ProgramRowConfig> visibleRows = [];
    double cursorSheetHeight = 0;
    int index = 0;

    while (cursorSheetHeight < sheetHeight) {
      RowKey rowKey = RowKey(sheetOffset.dy + index);
      RowProperties rowProperties = customRowProperties[rowKey] ?? RowProperties.defaults();

      ProgramRowConfig rowConfig = ProgramRowConfig(
        rowKey: rowKey,
        rowProperties: rowProperties,
        sheetRect: Rect.fromLTWH(0, cursorSheetHeight + columnHeadersHeight, rowHeadersWidth, rowProperties.height),
        selected: selection.isRowSelected(rowKey),
      );
      visibleRows.add(rowConfig);

      cursorSheetHeight += rowConfig.rowProperties.height;
      index++;
    }

    return visibleRows;
  }

  List<ProgramColumnConfig> getVisibleColumns(double sheetWidth) {
    List<ProgramColumnConfig> visibleColumns = [];
    double cursorSheetWidth = 0;
    int index = 0;

    while (cursorSheetWidth < sheetWidth) {
      ColumnKey columnKey = ColumnKey(sheetOffset.dx + index);
      ColumnProperties columnProperties = customColumnProperties[columnKey] ?? ColumnProperties.defaults();

      ProgramColumnConfig columnConfig = ProgramColumnConfig(
        columnKey: columnKey,
        columnProperties: columnProperties,
        headerRect: Rect.fromLTWH(cursorSheetWidth + rowHeadersWidth, 0, columnProperties.width, columnHeadersHeight),
        selected: selection.isColumnSelected(columnKey),
      );

      visibleColumns.add(columnConfig);

      cursorSheetWidth += columnConfig.columnProperties.width;
      index++;
    }

    return visibleColumns;
  }

  List<ProgramCellConfig> getVisibleCells(List<ProgramRowConfig> visibleRows, List<ProgramColumnConfig> visibleColumns) {
    List<ProgramCellConfig> visibleCells = [];

    for (ProgramRowConfig row in visibleRows) {
      for (ProgramColumnConfig column in visibleColumns) {
        ProgramCellConfig programCellConfig = ProgramCellConfig(
          cellKey: CellKey(rowKey: row.rowKey, columnKey: column.columnKey),
          programRowConfig: row,
          programColumnConfig: column,
          rect: Rect.fromLTWH(
            column.headerRect.left,
            row.sheetRect.top,
            column.columnProperties.width,
            row.rowProperties.height,
          ),
        );
        visibleCells.add(programCellConfig);
      }
    }

    return visibleCells;
  }
}

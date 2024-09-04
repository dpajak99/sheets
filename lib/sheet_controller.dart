import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/sheet_painter.dart';
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

abstract class ProgramElementConfig with EquatableMixin {
  final Rect rect;

  ProgramElementConfig({
    required this.rect,
  });}

class ProgramRowConfig extends ProgramElementConfig {
  final RowKey rowKey;
  final RowProperties rowProperties;

  ProgramRowConfig({
    required super.rect,
    required this.rowKey,
    required this.rowProperties,
  });

  @override
  String toString() {
    return 'Row(${rowKey.value})';
  }

  @override
  List<Object?> get props => [rowKey, rowProperties, rect];
}

class ProgramColumnConfig extends ProgramElementConfig {
  final ColumnKey columnKey;
  final ColumnProperties columnProperties;

  ProgramColumnConfig({
    required super.rect,
    required this.columnKey,
    required this.columnProperties,
  });

  @override
  String toString() {
    return 'Column(${columnKey.value})';
  }

  @override
  List<Object?> get props => [columnKey, columnProperties, rect];
}

class ProgramCellConfig extends ProgramElementConfig {
  final CellKey cellKey;
  final ProgramRowConfig programRowConfig;
  final ProgramColumnConfig programColumnConfig;

  ProgramCellConfig({
    required super.rect,
    required this.cellKey,
    required this.programRowConfig,
    required this.programColumnConfig,
  });

  @override
  String toString() {
    return 'Cell(${cellKey.rowKey.value}, ${cellKey.columnKey.value})';
  }

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

  SheetVisibilityConfig.empty()
      : visibleRows = [],
        visibleColumns = [],
        visibleCells = [];

  List<ProgramElementConfig> get visibleElements {
    List<ProgramElementConfig> elements = [];
    elements.addAll(visibleRows);
    elements.addAll(visibleColumns);
    elements.addAll(visibleCells);
    return elements;
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

abstract class SheetSelection with EquatableMixin {
  List<CellKey> get selectedCells;
  
  CellKey get start;
  
  CellKey get end;

  bool isColumnSelected(ColumnKey columnKey);

  bool isRowSelected(RowKey rowKey);

  int get length => selectedCells.length;

  bool get isCompleted => length > 0;

  bool get isEmpty => length == 0;
}

class SheetEmptySelection extends SheetSelection {
  @override
  List<CellKey> get selectedCells => [CellKey(rowKey: RowKey(0), columnKey: ColumnKey(0))];

  @override
  CellKey get start => selectedCells.first;

  @override
  CellKey get end => selectedCells.first;

  @override
  bool isColumnSelected(ColumnKey columnKey) => false;

  @override
  bool isRowSelected(RowKey rowKey) => false;

  @override
  List<Object?> get props => [];
}

class SheetSingleSelection extends SheetSelection {
  final CellKey cellKey;

  SheetSingleSelection(this.cellKey);

  @override
  CellKey get start => cellKey;
  
  @override
  CellKey get end => cellKey;
  
  @override
  List<CellKey> get selectedCells => [cellKey];

  @override
  bool isColumnSelected(ColumnKey columnKey) => cellKey.columnKey == columnKey;

  @override
  bool isRowSelected(RowKey rowKey) => cellKey.rowKey == rowKey;

  @override
  List<Object?> get props => [cellKey];
}

class SheetRangeSelection extends SheetSelection {
  final CellKey _start;
  final CellKey _end;

  SheetRangeSelection({
    required CellKey start,
    required CellKey end,
  }) : _end = end, _start = start;

  @override
  CellKey get start => _start;

  @override
  CellKey get end => _end;

  @override
  List<CellKey> get selectedCells {
    List<CellKey> selectedCells = [];
    for (int row = _start.rowKey.value; row <= _end.rowKey.value; row++) {
      for (int column = _start.columnKey.value; column <= _end.columnKey.value; column++) {
        selectedCells.add(CellKey(rowKey: RowKey(row), columnKey: ColumnKey(column)));
      }
    }
    return selectedCells;
  }

  @override
  bool isColumnSelected(ColumnKey columnKey) {
    return columnKey.value >= _start.columnKey.value && columnKey.value <= _end.columnKey.value;
  }

  @override
  bool isRowSelected(RowKey rowKey) {
    return rowKey.value >= _start.rowKey.value && rowKey.value <= _end.rowKey.value;
  }

  @override
  List<Object?> get props => [_start, _end];
}

class SheetController {
  final Map<ColumnKey, ColumnProperties> customColumnProperties;
  final Map<RowKey, RowProperties> customRowProperties;

  // SheetSelection selection = SheetEmptySelection();
  SheetSelection selection = SheetEmptySelection();
  IntOffset sheetOffset = IntOffset.zero;

  SheetVisibilityConfig visibilityConfig = SheetVisibilityConfig.empty();

  SheetPainterNotifier gridPainterNotifier = SheetPainterNotifier();
  SheetPainterNotifier selectionPainterNotifier = SheetPainterNotifier();

  SheetController({
    this.customColumnProperties = const {},
    this.customRowProperties = const {},
  });

  void updateSelection(SheetSelection sheetSelection) {
    selection = sheetSelection;
    selectionPainterNotifier.repaint();
  }

  List<ProgramCellConfig> getSelectionRange() {
    List<CellKey> selectedCells = [selection.start, selection.end];
    List<ProgramCellConfig> selectedCellsConfig = visibilityConfig.visibleCells.where(
      (cell) => selectedCells.contains(cell.cellKey),
    ).toList();

    return selectedCellsConfig;
  }

  ProgramElementConfig? getHoveredElement(Offset mousePosition) {
    try {
      return visibilityConfig.visibleElements.firstWhere(
        (element) => element.rect.contains(mousePosition),
      );
    } catch (e) {
      return null;
    }
  }

  SheetVisibilityConfig getVisibilityConfig(Size sheetSize) {
    List<ProgramRowConfig> visibleRows = getVisibleRows(sheetSize.height);
    List<ProgramColumnConfig> visibleColumns = getVisibleColumns(sheetSize.width);
    List<ProgramCellConfig> visibleCells = getVisibleCells(visibleRows, visibleColumns);

    visibilityConfig = SheetVisibilityConfig(
      visibleRows: visibleRows,
      visibleColumns: visibleColumns,
      visibleCells: visibleCells,
    );

    return visibilityConfig;
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
        rect: Rect.fromLTWH(0, cursorSheetHeight + columnHeadersHeight, rowHeadersWidth, rowProperties.height),
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
        rect: Rect.fromLTWH(cursorSheetWidth + rowHeadersWidth, 0, columnProperties.width, columnHeadersHeight),
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
            column.rect.left,
            row.rect.top,
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

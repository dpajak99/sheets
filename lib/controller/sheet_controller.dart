import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/cell_keys.dart';
import 'package:sheets/controller/properties.dart';
import 'package:sheets/painters/sheet_painter_notifier.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils.dart';


abstract class ProgramElementConfig with EquatableMixin {
  final Rect rect;

  ProgramElementConfig({
    required this.rect,
  });
}

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

  (Direction, Direction, ProgramCellConfig) findClosestVisible(CellKey cellKey) {
    Direction verticalDirection;
    Direction horizontalDirection;
    RowKey rowKey;
    ColumnKey columnKey;

    (verticalDirection, rowKey) = _findVisibleRowKey(cellKey);
    (horizontalDirection, columnKey) = _findVisibleColumnKey(cellKey);

    CellKey closestCellKey = CellKey(
      rowKey: rowKey,
      columnKey: columnKey,
    );
    return (verticalDirection, horizontalDirection, findCell(closestCellKey)!);
  }

  (Direction, RowKey) _findVisibleRowKey(CellKey cellKey) {
    RowKey firstVisibleRow = visibleRows.first.rowKey;
    RowKey lastVisibleRow = visibleRows.last.rowKey;
    RowKey cellRow = cellKey.rowKey;

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

  (Direction, ColumnKey) _findVisibleColumnKey(CellKey cellKey) {
    ColumnKey firstVisibleColumn = visibleColumns.first.columnKey;
    ColumnKey lastVisibleColumn = visibleColumns.last.columnKey;
    ColumnKey cellColumn = cellKey.columnKey;

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

  ProgramCellConfig? findCell(CellKey cellKey) {
    return visibleCells.where((cell) => cell.cellKey == cellKey).firstOrNull;
  }

  bool containsCell(CellKey cellKey) {
    return visibleCells.any((cell) => cell.cellKey == cellKey);
  }

  @override
  List<Object?> get props => [visibleRows, visibleColumns];
}

enum Direction {
  top,
  right,
  bottom,
  left,
  center,
}


abstract class SheetSelection with EquatableMixin {
  CellKey get start;

  CellKey get end;

  bool isColumnSelected(ColumnKey columnKey);

  bool isRowSelected(RowKey rowKey);

  SelectionDirection get selectionDirection;

  bool get isCompleted;
}

class SheetEmptySelection extends SheetSelection {
  @override
  CellKey get start => CellKey(rowKey: RowKey(0), columnKey: ColumnKey(0));

  @override
  CellKey get end => CellKey(rowKey: RowKey(0), columnKey: ColumnKey(0));

  @override
  bool isColumnSelected(ColumnKey columnKey) => false;

  @override
  bool isRowSelected(RowKey rowKey) => false;

  @override
  SelectionDirection get selectionDirection => SelectionDirection.topRight;

  @override
  bool get isCompleted => true;

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
  bool isColumnSelected(ColumnKey columnKey) => cellKey.columnKey == columnKey;

  @override
  bool isRowSelected(RowKey rowKey) => cellKey.rowKey == rowKey;

  @override
  SelectionDirection get selectionDirection => SelectionDirection.topRight;

  @override
  bool get isCompleted => true;

  @override
  List<Object?> get props => [cellKey];
}

enum SelectionDirection {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

class SheetRangeSelection extends SheetSelection {
  final CellKey _start;
  final CellKey _end;
  final bool _completed;

  SheetRangeSelection({
    required CellKey start,
    required CellKey end,
    required bool completed,
  })  : _end = end,
        _start = start,
        _completed = completed;

  @override
  CellKey get start => _start;

  @override
  CellKey get end => _end;

  @override
  bool isColumnSelected(ColumnKey columnKey) {
    ProgramSelectionKeyBox programSelectionKeyBox = ProgramSelectionKeyBox.fromSheetSelection(this);
    int startColumnIndex = programSelectionKeyBox.topLeft.columnKey.value;
    int endColumnIndex = programSelectionKeyBox.topRight.columnKey.value;

    return columnKey.value >= startColumnIndex && columnKey.value <= endColumnIndex;
  }

  @override
  bool isRowSelected(RowKey rowKey) {
    ProgramSelectionKeyBox programSelectionKeyBox = ProgramSelectionKeyBox.fromSheetSelection(this);
    int startRowIndex = programSelectionKeyBox.topLeft.rowKey.value;
    int endRowIndex = programSelectionKeyBox.bottomLeft.rowKey.value;

    return rowKey.value >= startRowIndex && rowKey.value <= endRowIndex;
  }

  @override
  SelectionDirection get selectionDirection {
    bool startBeforeEndRow = _start.rowKey.value < _end.rowKey.value;
    bool startBeforeEndColumn = _start.columnKey.value < _end.columnKey.value;

    if (startBeforeEndRow) {
      return startBeforeEndColumn ? SelectionDirection.bottomRight : SelectionDirection.bottomLeft;
    } else {
      return startBeforeEndColumn ? SelectionDirection.topRight : SelectionDirection.topLeft;
    }
  }

  @override
  bool get isCompleted => _completed;

  @override
  List<Object?> get props => [_start, _end];
}

class ProgramSelectionKeyBox {
  final CellKey topLeft;
  final CellKey topRight;
  final CellKey bottomLeft;
  final CellKey bottomRight;

  ProgramSelectionKeyBox({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory ProgramSelectionKeyBox.fromSheetSelection(SheetSelection selection) {
    SelectionDirection selectionDirection = selection.selectionDirection;
    CellKey start = selection.start;
    CellKey end = selection.end;

    switch (selectionDirection) {
      case SelectionDirection.bottomRight:
        return ProgramSelectionKeyBox(
          topLeft: start,
          topRight: CellKey(rowKey: start.rowKey, columnKey: end.columnKey),
          bottomLeft: CellKey(rowKey: end.rowKey, columnKey: start.columnKey),
          bottomRight: end,
        );
      case SelectionDirection.bottomLeft:
        return ProgramSelectionKeyBox(
          topLeft: CellKey(rowKey: start.rowKey, columnKey: end.columnKey),
          topRight: start,
          bottomLeft: end,
          bottomRight: CellKey(rowKey: end.rowKey, columnKey: start.columnKey),
        );
      case SelectionDirection.topRight:
        return ProgramSelectionKeyBox(
          topLeft: CellKey(rowKey: end.rowKey, columnKey: start.columnKey),
          topRight: end,
          bottomLeft: start,
          bottomRight: CellKey(rowKey: start.rowKey, columnKey: end.columnKey),
        );
      case SelectionDirection.topLeft:
        return ProgramSelectionKeyBox(
          topLeft: end,
          topRight: CellKey(rowKey: end.rowKey, columnKey: start.columnKey),
          bottomLeft: CellKey(rowKey: start.rowKey, columnKey: end.columnKey),
          bottomRight: start,
        );
    }
  }
}

class ProgramSelectionRectBox {
  final Rect topLeft;
  final Rect topRight;
  final Rect bottomLeft;
  final Rect bottomRight;
  final Rect startCellRect;

  final bool hideTopBorder;
  final bool hideRightBorder;
  final bool hideBottomBorder;
  final bool hideLeftBorder;

  final bool startCellVisible;
  final bool lastCellVisible;

  ProgramSelectionRectBox({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.startCellRect,
    this.hideTopBorder = false,
    this.hideRightBorder = false,
    this.hideBottomBorder = false,
    this.hideLeftBorder = false,
    this.startCellVisible = true,
    this.lastCellVisible = true,
  });

  factory ProgramSelectionRectBox.fromProgramCellConfig({
    required ProgramCellConfig start,
    required ProgramCellConfig end,
    required SelectionDirection selectionDirection,
    bool startCellVisible = true,
    bool lastCellVisible = true,
    bool hideTopBorder = false,
    bool hideRightBorder = false,
    bool hideBottomBorder = false,
    bool hideLeftBorder = false,
  }) {
    late Rect topLeft;
    late Rect topRight;
    late Rect bottomLeft;
    late Rect bottomRight;

    switch (selectionDirection) {
      case SelectionDirection.bottomRight:
        topLeft = start.rect;
        bottomRight = end.rect;
        topRight = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        bottomLeft = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        break;
      case SelectionDirection.bottomLeft:
        topLeft = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        bottomRight = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        topRight = start.rect;
        bottomLeft = end.rect;
        break;
      case SelectionDirection.topRight:
        topLeft = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        bottomRight = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        topRight = end.rect;
        bottomLeft = start.rect;
        break;
      case SelectionDirection.topLeft:
        topLeft = end.rect;
        bottomRight = start.rect;
        topRight = Rect.fromPoints(Offset(end.rect.left, start.rect.top), Offset(end.rect.right, start.rect.bottom));
        bottomLeft = Rect.fromPoints(Offset(start.rect.left, end.rect.top), Offset(start.rect.right, end.rect.bottom));
        break;
    }

    return ProgramSelectionRectBox(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
      startCellRect: start.rect,
      hideTopBorder: hideTopBorder,
      hideRightBorder: hideRightBorder,
      hideBottomBorder: hideBottomBorder,
      hideLeftBorder: hideLeftBorder,
      startCellVisible: startCellVisible,
      lastCellVisible: lastCellVisible,
    );
  }
}

class SheetController {
  final Map<ColumnKey, ColumnProperties> customColumnProperties;
  final Map<RowKey, RowProperties> customRowProperties;

  SheetSelection selection = SheetEmptySelection();
  IntOffset sheetOffset = IntOffset.zero;

  SheetVisibilityConfig visibilityConfig = SheetVisibilityConfig.empty();

  SheetPainterNotifier selectionPainterNotifier = SheetPainterNotifier();
  SheetPainterNotifier scrollNotifier = SheetPainterNotifier();

  Size sheetSize = const Size(0, 0);

  SheetController({
    this.customColumnProperties = const {},
    this.customRowProperties = const {},
  });

  void setSheetSize(Size size) {
    sheetSize = size;
    _calculateVisibilityConfig();
  }

  void scroll(IntOffset offset) {
    IntOffset updatedOffset = sheetOffset + offset;
    updatedOffset = IntOffset(max(0, updatedOffset.dx), max(0, updatedOffset.dy));

    sheetOffset = updatedOffset;

    _calculateVisibilityConfig();
    scrollNotifier.repaint();
  }

  void updateSelection(SheetSelection sheetSelection) {
    selection = sheetSelection;
    selectionPainterNotifier.repaint();
  }

  ProgramSelectionRectBox? getProgramSelectionRectBox() {
    bool startCellVisible = visibilityConfig.containsCell(selection.start);
    bool endCellVisible = visibilityConfig.containsCell(selection.end);

    if ((startCellVisible || endCellVisible) == false) {
      return null;
    }

    ProgramCellConfig? startCell = visibilityConfig.findCell(selection.start);
    ProgramCellConfig? endCell = visibilityConfig.findCell(selection.end);

    if (startCell != null && endCell != null) {
      return ProgramSelectionRectBox.fromProgramCellConfig(
        start: startCell,
        end: endCell,
        selectionDirection: selection.selectionDirection,
      );
    } else if (startCell == null && endCell != null) {
      Direction verticalDirection;
      Direction horizontalDirection;
      ProgramCellConfig closestCell;

      (verticalDirection, horizontalDirection, closestCell) = visibilityConfig.findClosestVisible(selection.start);

      return ProgramSelectionRectBox.fromProgramCellConfig(
        start: closestCell,
        end: endCell,
        selectionDirection: selection.selectionDirection,
        hideTopBorder: verticalDirection == Direction.top,
        hideRightBorder: horizontalDirection == Direction.right,
        hideBottomBorder: verticalDirection == Direction.bottom,
        hideLeftBorder: horizontalDirection == Direction.left,
        startCellVisible: false,
      );
    } else if (startCell != null && endCell == null) {
      Direction verticalDirection;
      Direction horizontalDirection;
      ProgramCellConfig closestCell;

      (verticalDirection, horizontalDirection, closestCell) = visibilityConfig.findClosestVisible(selection.end);

      return ProgramSelectionRectBox.fromProgramCellConfig(
        start: startCell,
        end: closestCell,
        selectionDirection: selection.selectionDirection,
        hideTopBorder: verticalDirection == Direction.top,
        hideRightBorder: horizontalDirection == Direction.right,
        hideBottomBorder: verticalDirection == Direction.bottom,
        hideLeftBorder: horizontalDirection == Direction.left,
        lastCellVisible: false,
      );
    } else {
      return null;
    }
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

  SheetVisibilityConfig _calculateVisibilityConfig() {
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

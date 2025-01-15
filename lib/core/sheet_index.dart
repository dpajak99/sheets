import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';
import 'package:sheets/utils/numeric_index_mixin.dart';

sealed class SheetIndex with EquatableMixin {
  String get reference;

  static SheetIndex matchType(SheetIndex base, SheetIndex other) {
    switch (base) {
      case CellIndex _:
        return switch (other) {
          CellIndex other => other,
          ColumnIndex other => CellIndex(row: RowIndex.zero, column: other),
          RowIndex other => CellIndex(row: other, column: ColumnIndex.zero),
        };
      case ColumnIndex _:
        return switch (other) {
          CellIndex other => other.column,
          ColumnIndex other => other,
          RowIndex _ => ColumnIndex.zero,
        };
      case RowIndex _:
        return switch (other) {
          CellIndex other => other.row,
          ColumnIndex _ => RowIndex.zero,
          RowIndex other => other,
        };
    }
  }

  Rect getSheetCoordinates(Worksheet worksheet);

  CellIndex toCellIndex() {
    return switch (this) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex.fromColumnMin(columnIndex),
      RowIndex rowIndex => CellIndex.fromRowMin(rowIndex),
    };
  }

  @override
  String toString() {
    return reference;
  }
}

class MergedCellIndex extends CellIndex {
  MergedCellIndex({
    required this.start,
    required this.end,
  }) : super(row: start.row, column: start.column);

  final CellIndex start;
  final CellIndex end;

  bool containsRow(RowIndex rowIndex) {
    return rowIndex >= start.row && rowIndex <= end.row;
  }

  bool containsColumn(ColumnIndex columnIndex) {
    return columnIndex >= start.column && columnIndex <= end.column;
  }

  bool containsCell(CellIndex cellIndex) {
    return containsRow(cellIndex.row) && containsColumn(cellIndex.column);
  }

  @override
  MergedCellIndex clamp(CellIndex max) {
    return MergedCellIndex(
      start: start.clamp(max),
      end: end.clamp(max),
    );
  }

  @override
  CellIndex move({required int dx, required int dy}) {
    RowIndex row = dy < 0 ? start.row + dy : end.row + dy;
    ColumnIndex column = dx < 0 ? start.column + dx : end.column + dx;

    return CellIndex(row: row, column: column);
  }

  int get width {
    return end.column.value - start.column.value;
  }

  int get height {
    return end.row.value - start.row.value;
  }

  List<CellIndex> get selectedCells {
    List<CellIndex> selectedCells = <CellIndex>[];
    for (int i = start.row.value; i <= end.row.value; i++) {
      for (int j = start.column.value; j <= end.column.value; j++) {
        selectedCells.add(CellIndex(row: RowIndex(i), column: ColumnIndex(j)));
      }
    }
    return selectedCells;
  }

  @override
  String get reference {
    return '${start.reference}:${end.reference}';
  }
  @override
  List<Object?> get props => <Object?>[start, end];
}

class CellIndex extends SheetIndex {
  CellIndex({required this.row, required this.column});

  CellIndex.raw(int row, int column)
      : row = RowIndex(row),
        column = ColumnIndex(column);

  factory CellIndex.fromColumnMin(ColumnIndex columnIndex) {
    return CellIndex(row: RowIndex.zero, column: columnIndex);
  }

  factory CellIndex.fromColumnMax(ColumnIndex columnIndex) {
    return CellIndex(row: RowIndex.max, column: columnIndex);
  }

  factory CellIndex.fromRowMin(RowIndex rowIndex) {
    return CellIndex(row: rowIndex, column: ColumnIndex.zero);
  }

  factory CellIndex.fromRowMax(RowIndex rowIndex) {
    return CellIndex(row: rowIndex, column: ColumnIndex.max);
  }

  CellIndex copyWith({RowIndex? row, ColumnIndex? column}) {
    return CellIndex(row: row ?? this.row, column: column ?? this.column);
  }

  static CellIndex zero = CellIndex(row: RowIndex(0), column: ColumnIndex(0));
  static CellIndex max = CellIndex(row: RowIndex.max, column: ColumnIndex.max);

  final RowIndex row;
  final ColumnIndex column;

  CellIndex toRealIndex({required int cols, required int rows}) {
    ColumnIndex realColumnIndex = column.toRealIndex(cols: cols);
    RowIndex realRowIndex = row.toRealIndex(rows: rows);

    return CellIndex(row: realRowIndex, column: realColumnIndex);
  }

  @override
  Rect getSheetCoordinates(Worksheet worksheet) {
    Rect xRect = column.getSheetCoordinates(worksheet);
    Rect yRect = row.getSheetCoordinates(worksheet);

    return Rect.fromLTWH(xRect.left, yRect.top, xRect.width, yRect.height);
  }

  CellIndex move({required int dx, required int dy}) {
    int movedRow = row.value + dy;
    int movedColumn = column.value + dx;

    return CellIndex(
      row: RowIndex(movedRow < 0 ? 0 : movedRow),
      column: ColumnIndex(movedColumn < 0 ? 0 : movedColumn),
    );
  }

  CellIndex clamp(CellIndex max) {
    return CellIndex(row: row.clamp(max.row), column: column.clamp(max.column));
  }

  @override
  String get reference {
    return '${column.reference}${row.reference}';
  }

  int compareTo(CellIndex other) {
    int rowComparison = row.compareTo(other.row);
    if (rowComparison != 0) {
      return rowComparison;
    } else {
      return column.compareTo(other.column);
    }
  }

  @override
  List<Object?> get props => <Object?>[row, column];
}

class ColumnIndex extends SheetIndex with NumericIndexMixin implements Comparable<ColumnIndex> {
  ColumnIndex(this._value);

  final int _value;

  static ColumnIndex zero = ColumnIndex(0);

  static ColumnIndex max = ColumnIndex(Int.max);

  ColumnIndex toRealIndex({required int cols}) {
    if (this == max) {
      return ColumnIndex(cols - 1);
    } else {
      return this;
    }
  }

  @override
  Rect getSheetCoordinates(Worksheet worksheet) {
    double x = 0;
    for (int i = 0; i < value; i++) {
      ColumnConfig columnConfig = worksheet.getColumn(ColumnIndex(i));
      x += columnConfig.width + borderWidth;
    }

    ColumnConfig columnConfig = worksheet.getColumn(this);
    return Rect.fromLTWH(x, 0, columnConfig.width + borderWidth, defaultRowHeight + borderWidth);
  }

  ColumnIndex operator +(int number) {
    return ColumnIndex(value + number);
  }

  ColumnIndex operator -(int number) {
    return ColumnIndex(value - number);
  }

  ColumnIndex move(int number) {
    return ColumnIndex(value + number);
  }

  @override
  int get value => _value;

  @override
  String get reference {
    return numberToExcelColumn(value + 1);
  }

  String numberToExcelColumn(int number) {
    String result = '';

    int parsedNumber = number;
    while (parsedNumber > 0) {
      parsedNumber--;
      result = String.fromCharCode(65 + (parsedNumber % 26)) + result;
      parsedNumber = parsedNumber ~/ 26;
    }

    return result;
  }

  ColumnIndex clamp(ColumnIndex max) {
    return ColumnIndex(value.clamp(0, max.value));
  }

  @override
  int compareTo(NumericIndexMixin other) {
    if (other is ColumnIndex) {
      return value.compareTo(other.value);
    } else {
      return -1;
    }
  }

  @override
  List<Object?> get props => <Object?>[value];
}

class RowIndex extends SheetIndex with NumericIndexMixin implements Comparable<RowIndex> {
  RowIndex(this._value);

  final int _value;

  static RowIndex zero = RowIndex(0);

  static RowIndex max = RowIndex(Int.max);

  RowIndex toRealIndex({required int rows}) {
    if (this == max) {
      return RowIndex(rows - 1);
    } else {
      return this;
    }
  }

  @override
  int get value => _value;

  @override
  Rect getSheetCoordinates(Worksheet worksheet) {
    double y = 0;
    for (int i = 0; i < value; i++) {
      RowConfig rowConfig = worksheet.getRow(RowIndex(i));
      y += rowConfig.height + borderWidth;
    }
    RowConfig rowConfig = worksheet.getRow(this);
    return Rect.fromLTWH(0, y, defaultColumnWidth + borderWidth, rowConfig.height + borderWidth);
  }

  RowIndex move(int number) {
    return RowIndex(value + number);
  }

  RowIndex clamp(RowIndex max) {
    return RowIndex(value.clamp(0, max.value));
  }

  @override
  String get reference {
    return (value + 1).toString();
  }

  RowIndex operator +(int number) {
    return RowIndex(value + number);
  }

  RowIndex operator -(int number) {
    return RowIndex(value - number);
  }

  @override
  int compareTo(NumericIndexMixin other) {
    if (other is RowIndex) {
      return value.compareTo(other.value);
    } else {
      return -1;
    }
  }

  @override
  List<Object?> get props => <Object?>[_value];
}

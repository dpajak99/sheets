import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';
import 'package:sheets/utils/numeric_index_mixin.dart';

sealed class SheetIndex with EquatableMixin {
  String stringifyPosition();

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

  SheetIndex toRealIndex(SheetProperties properties);

  Rect getSheetCoordinates(SheetProperties properties);

  CellIndex toCellIndex() {
    return switch (this) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex.fromColumnMin(columnIndex),
      RowIndex rowIndex => CellIndex.fromRowMin(rowIndex),
    };
  }

  @override
  String toString() {
    return stringifyPosition();
  }
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

  static CellIndex zero = CellIndex(row: RowIndex(0), column: ColumnIndex(0));
  static CellIndex max = CellIndex(row: RowIndex.max, column: ColumnIndex.max);

  final RowIndex row;
  final ColumnIndex column;

  @override
  CellIndex toRealIndex(SheetProperties properties) {
    ColumnIndex realColumnIndex = column.toRealIndex(properties);
    RowIndex realRowIndex = row.toRealIndex(properties);

    return CellIndex(row: realRowIndex, column: realColumnIndex);
  }

  @override
  Rect getSheetCoordinates(SheetProperties properties) {
    Rect xRect = column.getSheetCoordinates(properties);
    Rect yRect = row.getSheetCoordinates(properties);

    return Rect.fromLTWH(xRect.left, yRect.top, xRect.width, yRect.height);
  }

  CellIndex move(int rowOffset, int columnOffset) {
    int movedRow = row.value + rowOffset;
    int movedColumn = column.value + columnOffset;

    return CellIndex(
      row: RowIndex(movedRow < 0 ? 0 : movedRow),
      column: ColumnIndex(movedColumn < 0 ? 0 : movedColumn),
    );
  }

  CellIndex clamp(CellIndex max) {
    return CellIndex(row: row.clamp(max.row), column: column.clamp(max.column));
  }

  @override
  String stringifyPosition() {
    return '${column.stringifyPosition()}${row.stringifyPosition()}';
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

  @override
  ColumnIndex toRealIndex(SheetProperties properties) {
    if (this == max) {
      return ColumnIndex(properties.columnCount - 1);
    } else {
      return this;
    }
  }

  @override
  Rect getSheetCoordinates(SheetProperties properties) {
    double x = 0;
    for (int i = 0; i < value; i++) {
      double columnWidth = properties.getColumnWidth(ColumnIndex(i));
      x += columnWidth + borderWidth;
    }

    double width = properties.getColumnWidth(this);

    return Rect.fromLTWH(x, 0, width + borderWidth, defaultRowHeight + borderWidth);
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
  String stringifyPosition() {
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

  @override
  RowIndex toRealIndex(SheetProperties properties) {
    if (this == max) {
      return RowIndex(properties.rowCount - 1);
    } else {
      return this;
    }
  }

  @override
  int get value => _value;

  @override
  Rect getSheetCoordinates(SheetProperties properties) {
    double y = 0;
    for (int i = 0; i < value; i++) {
      double rowHeight = properties.getRowHeight(RowIndex(i));
      y += rowHeight + borderWidth;
    }

    double height = properties.getRowHeight(this);
    return Rect.fromLTWH(0, y, defaultColumnWidth + borderWidth, height + borderWidth);
  }

  RowIndex move(int number) {
    return RowIndex(value + number);
  }

  RowIndex clamp(RowIndex max) {
    return RowIndex(value.clamp(0, max.value));
  }

  @override
  String stringifyPosition() {
    return (value + 1).toString();
  }

  RowIndex operator +(int number) {
    return RowIndex(value + number);
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

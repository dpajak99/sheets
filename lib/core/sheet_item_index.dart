import 'package:equatable/equatable.dart';
import 'package:sheets/utils/numeric_index_mixin.dart';

sealed class SheetItemIndex with EquatableMixin {
  String stringifyPosition();

  static SheetItemIndex matchType(SheetItemIndex base, SheetItemIndex other) {
    switch(base) {
      case CellIndex _:
        return switch(other) {
          CellIndex other => other,
          ColumnIndex other => CellIndex(columnIndex: other, rowIndex: RowIndex.zero),
          RowIndex other => CellIndex(rowIndex: other, columnIndex: ColumnIndex.zero),
        };
      case ColumnIndex _:
        return switch(other) {
          CellIndex other => other.columnIndex,
          ColumnIndex other => other,
          RowIndex _ => ColumnIndex.zero,
        };
      case RowIndex _:
        return switch(other) {
          CellIndex other => other.rowIndex,
          ColumnIndex _ => RowIndex.zero,
          RowIndex other => other,
        };
    }
  }
}

class CellIndex extends SheetItemIndex {
  final RowIndex rowIndex;
  final ColumnIndex columnIndex;

  CellIndex({
    required this.rowIndex,
    required this.columnIndex,
  });

  static CellIndex zero = CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0));

  static CellIndex max = CellIndex(rowIndex: RowIndex.max, columnIndex: ColumnIndex.max);

  CellIndex move(int row, int column) {
    return CellIndex(
      rowIndex: RowIndex(rowIndex.value + row),
      columnIndex: ColumnIndex(columnIndex.value + column),
    );
  }

  @override
  String toString() {
    return 'Cell(${rowIndex.value}, ${columnIndex.value})';
  }

  @override
  String stringifyPosition() {
    return '${columnIndex.stringifyPosition()}${rowIndex.stringifyPosition()}';
  }

  @override
  List<Object?> get props => [rowIndex, columnIndex];
}

class ColumnIndex extends SheetItemIndex with NumericIndexMixin implements Comparable {
  final int _value;

  ColumnIndex(this._value);

  static ColumnIndex zero = ColumnIndex(0);

  static ColumnIndex max = ColumnIndex(-1);

  ColumnIndex operator -(int number) {
    return ColumnIndex(value - number);
  }

  @override
  int get value => _value;

  @override
  String stringifyPosition() {
    return numberToExcelColumn(value + 1);
  }

  String numberToExcelColumn(int number) {
    String result = '';

    while (number > 0) {
      number--;
      result = String.fromCharCode(65 + (number % 26)) + result;
      number = (number ~/ 26);
    }

    return result;
  }

  @override
  int compareTo(other) {
    if (other is ColumnIndex) {
      return value.compareTo(other.value);
    } else {
      return -1;
    }
  }

  @override
  List<Object?> get props => [value];
}

class RowIndex extends SheetItemIndex with NumericIndexMixin implements Comparable {
  final int _value;

  RowIndex(this._value);

  static RowIndex zero = RowIndex(0);

  static RowIndex max = RowIndex(-1);

  @override
  int get value => _value;

  @override
  String stringifyPosition() {
    return (value + 1).toString();
  }

  @override
  int compareTo(other) {
    if (other is RowIndex) {
      return value.compareTo(other.value);
    } else {
      return -1;
    }
  }

  @override
  List<Object?> get props => [_value];
}

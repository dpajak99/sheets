import 'package:equatable/equatable.dart';

mixin NumericIndexMixin {
  int get value;

  bool operator <(NumericIndexMixin other) {
    return value < other.value;
  }

  bool operator <=(NumericIndexMixin other) {
    return value <= other.value;
  }

  bool operator >(NumericIndexMixin other) {
    return value > other.value;
  }

  bool operator >=(NumericIndexMixin other) {
    return value >= other.value;
  }

  int compareTo(NumericIndexMixin other) {
    return value.compareTo(other.value);
  }
}

abstract class SheetItemIndex with EquatableMixin {}

class CellIndex extends SheetItemIndex {
  final RowIndex rowIndex;
  final ColumnIndex columnIndex;

  CellIndex({
    required this.rowIndex,
    required this.columnIndex,
  });

  static CellIndex zero = CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0));

  @override
  String toString() {
    return 'Cell(${rowIndex.value}, ${columnIndex.value})';
  }

  @override
  List<Object?> get props => [rowIndex, columnIndex];
}

class ColumnIndex extends SheetItemIndex with NumericIndexMixin {
  final int _value;

  ColumnIndex(int value)
      : _value = value,
        assert(value >= 0);

  static ColumnIndex zero = ColumnIndex(0);

  ColumnIndex operator -(int number) {
    return ColumnIndex(value - number);
  }

  @override
  int get value => _value;

  @override
  List<Object?> get props => [value];
}

class RowIndex extends SheetItemIndex with NumericIndexMixin {
  final int _value;

  RowIndex(int value) : _value = value < 0 ? 0 : value;

  static RowIndex zero = RowIndex(0);

  @override
  int get value => _value;

  @override
  List<Object?> get props => [_value];
}

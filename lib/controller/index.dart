import 'package:equatable/equatable.dart';

class CellIndex with EquatableMixin {
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

class ColumnIndex with EquatableMixin {
  final int value;

  ColumnIndex(this.value) : assert(value >= 0);

  static ColumnIndex zero = ColumnIndex(0);

  bool operator <(ColumnIndex other) {
    return value < other.value;
  }

  bool operator <=(ColumnIndex other) {
    return value <= other.value;
  }

  ColumnIndex operator -(int number) {
    return ColumnIndex(value - number);
  }

  bool operator >(ColumnIndex other) {
    return value > other.value;
  }

  bool operator >=(ColumnIndex other) {
    return value >= other.value;
  }

  @override
  List<Object?> get props => [value];
}

class RowIndex with EquatableMixin {
  final int value;

  RowIndex(int value) : value = value < 0 ? 0 : value;

  static RowIndex zero = RowIndex(0);

  bool operator <(RowIndex other) {
    return value < other.value;
  }

  bool operator <=(RowIndex other) {
    return value <= other.value;
  }

  bool operator >(RowIndex other) {
    return value > other.value;
  }

  bool operator >=(RowIndex other) {
    return value >= other.value;
  }

  @override
  List<Object?> get props => [value];
}

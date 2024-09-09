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

  ColumnIndex(this.value);

  bool operator <(ColumnIndex other) {
    return value < other.value;
  }

  bool operator <=(ColumnIndex other) {
    return value <= other.value;
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

  RowIndex(this.value);

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

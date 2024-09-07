import 'package:equatable/equatable.dart';

class CellKey with EquatableMixin {
  final RowKey rowKey;
  final ColumnKey columnKey;

  CellKey({
    required this.rowKey,
    required this.columnKey,
  });

  @override
  List<Object?> get props => [rowKey, columnKey];

  @override
  String toString() {
    return 'Cell(${rowKey.value}, ${columnKey.value})';
  }
}


class ColumnKey with EquatableMixin {
  final int value;

  ColumnKey(this.value);

  bool operator <(ColumnKey other) {
    return value < other.value;
  }

  bool operator <=(ColumnKey other) {
    return value <= other.value;
  }

  bool operator >(ColumnKey other) {
    return value > other.value;
  }

  bool operator >=(ColumnKey other) {
    return value >= other.value;
  }

  @override
  List<Object?> get props => [value];
}

class RowKey with EquatableMixin {
  final int value;

  RowKey(this.value);

  bool operator <(RowKey other) {
    return value < other.value;
  }

  bool operator <=(RowKey other) {
    return value <= other.value;
  }

  bool operator >(RowKey other) {
    return value > other.value;
  }

  bool operator >=(RowKey other) {
    return value >= other.value;
  }

  @override
  List<Object?> get props => [value];
}

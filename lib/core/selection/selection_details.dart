import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';

class SelectionStartDetails with EquatableMixin {
  SelectionStartDetails(this.index);

  final SheetIndex index;

  CellIndex get cell {
    return switch (index) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex.fromColumnMin(columnIndex),
      RowIndex rowIndex => CellIndex.fromRowMin(rowIndex),
    };
  }

  ColumnIndex get column {
    return switch (index) {
      CellIndex cellIndex => cellIndex.column,
      ColumnIndex columnIndex => columnIndex,
      RowIndex _ => ColumnIndex.zero,
    };
  }

  RowIndex get row {
    return switch (index) {
      CellIndex cellIndex => cellIndex.row,
      ColumnIndex _ => RowIndex.zero,
      RowIndex rowIndex => rowIndex,
    };
  }

  @override
  List<Object?> get props => <Object?>[index];
}

class SelectionEndDetails with EquatableMixin {
  SelectionEndDetails(this.index);

  final SheetIndex index;

  CellIndex get cell {
    return switch (index) {
      CellIndex cellIndex => cellIndex,
      ColumnIndex columnIndex => CellIndex.fromColumnMax(columnIndex),
      RowIndex rowIndex => CellIndex.fromRowMax(rowIndex),
    };
  }

  ColumnIndex get column {
    return switch (index) {
      CellIndex cellIndex => cellIndex.column,
      ColumnIndex columnIndex => columnIndex,
      RowIndex _ => ColumnIndex.max,
    };
  }

  RowIndex get row {
    return switch (index) {
      CellIndex cellIndex => cellIndex.row,
      ColumnIndex _ => RowIndex.max,
      RowIndex rowIndex => rowIndex,
    };
  }

  @override
  List<Object?> get props => <Object?>[index];
}

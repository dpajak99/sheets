import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';

class SelectionStartDetails with EquatableMixin {
  final SheetIndex index;

  SelectionStartDetails(this.index);

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
  final SheetIndex index;

  SelectionEndDetails(this.index);

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
import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/cell_value.dart';

class SheetData with EquatableMixin {
  SheetData({
    Map<CellIndex, String>? data,
  }) {
    this.data = data ?? <CellIndex, String>{
      CellIndex(column: ColumnIndex(0), row: RowIndex(0)): '1',
      CellIndex(column: ColumnIndex(1), row: RowIndex(0)): '1.1',
      CellIndex(column: ColumnIndex(2), row: RowIndex(0)): '3',
      //
      CellIndex(column: ColumnIndex(0), row: RowIndex(1)): '2',
      CellIndex(column: ColumnIndex(1), row: RowIndex(1)): '2.2',
      CellIndex(column: ColumnIndex(2), row: RowIndex(1)): '2',
      //
      CellIndex(column: ColumnIndex(0), row: RowIndex(2)): '3',
      CellIndex(column: ColumnIndex(1), row: RowIndex(2)): '3.3',
      CellIndex(column: ColumnIndex(2), row: RowIndex(2)): '1',
    };
  }


  late final Map<CellIndex, String> data;

  void setCellValue(CellIndex cellIndex, String value) {
    data[cellIndex] = value;
  }

  CellValue getCellValue(CellIndex cellIndex) {
    return CellValueParser.parse(data[cellIndex] ?? '');
  }

  @override
  List<Object?> get props => <Object?>[data];
}

import 'package:equatable/equatable.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';

class SheetData with EquatableMixin {
  SheetData({
    Map<CellIndex, String>? data,
  }) {
    this.data = data ?? <CellIndex, String>{
      CellIndex(column: ColumnIndex(0), row: RowIndex(0)): '1',
      CellIndex(column: ColumnIndex(1), row: RowIndex(0)): 'A',
      CellIndex(column: ColumnIndex(2), row: RowIndex(0)): 'abc',
      CellIndex(column: ColumnIndex(0), row: RowIndex(1)): '2',
      CellIndex(column: ColumnIndex(1), row: RowIndex(1)): 'B',
      CellIndex(column: ColumnIndex(2), row: RowIndex(1)): 'abc',
      CellIndex(column: ColumnIndex(0), row: RowIndex(2)): '3',
      CellIndex(column: ColumnIndex(1), row: RowIndex(2)): 'C',
      CellIndex(column: ColumnIndex(2), row: RowIndex(2)): 'abc',
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

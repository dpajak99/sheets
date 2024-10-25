import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';

class SheetData with EquatableMixin {
  SheetData({
    Map<CellIndex, String>? data,
  }) {
    this.data = data ?? <CellIndex, String>{
      CellIndex(column: ColumnIndex(0), row: RowIndex(0)): 'A1',
      CellIndex(column: ColumnIndex(1), row: RowIndex(0)): 'B1',
      CellIndex(column: ColumnIndex(2), row: RowIndex(0)): 'C1',
      CellIndex(column: ColumnIndex(0), row: RowIndex(1)): 'A2',
      CellIndex(column: ColumnIndex(1), row: RowIndex(1)): 'B2',
      CellIndex(column: ColumnIndex(2), row: RowIndex(1)): 'C2',
      CellIndex(column: ColumnIndex(0), row: RowIndex(2)): 'A3',
      CellIndex(column: ColumnIndex(1), row: RowIndex(2)): 'B3',
      CellIndex(column: ColumnIndex(2), row: RowIndex(2)): 'C3',
    };
  }


  late final Map<CellIndex, String> data;

  void setCellValue(CellIndex cellIndex, String value) {
    data[cellIndex] = value;
  }

  String getCellValue(CellIndex cellIndex) {
    return data[cellIndex] ?? '';
  }

  @override
  List<Object?> get props => <Object?>[data];
}

import 'package:equatable/equatable.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/sheet_controller.dart';

abstract class SheetSelection with EquatableMixin {
  CellIndex get start;

  CellIndex get end;

  bool isColumnSelected(ColumnIndex columnIndex);

  bool isRowSelected(RowIndex rowIndex);

  SelectionDirection get selectionDirection;

  bool get isCompleted;
}

class SheetEmptySelection extends SheetSelection {
  @override
  CellIndex get start => CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0));

  @override
  CellIndex get end => CellIndex(rowIndex: RowIndex(0), columnIndex: ColumnIndex(0));

  @override
  bool isColumnSelected(ColumnIndex columnIndex) => false;

  @override
  bool isRowSelected(RowIndex rowIndex) => false;

  @override
  SelectionDirection get selectionDirection => SelectionDirection.topRight;

  @override
  bool get isCompleted => true;

  @override
  List<Object?> get props => [];
}

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;

  SheetSingleSelection(this.cellIndex);

  @override
  CellIndex get start => cellIndex;

  @override
  CellIndex get end => cellIndex;

  @override
  bool isColumnSelected(ColumnIndex columnIndex) => cellIndex.columnIndex == columnIndex;

  @override
  bool isRowSelected(RowIndex rowIndex) => cellIndex.rowIndex == rowIndex;

  @override
  SelectionDirection get selectionDirection => SelectionDirection.topRight;

  @override
  bool get isCompleted => true;

  @override
  List<Object?> get props => [cellIndex];
}


class SheetRangeSelection extends SheetSelection {
  final CellIndex _start;
  final CellIndex _end;
  final bool _completed;

  SheetRangeSelection({
    required CellIndex start,
    required CellIndex end,
    required bool completed,
  })  : _end = end,
        _start = start,
        _completed = completed;

  @override
  CellIndex get start => _start;

  @override
  CellIndex get end => _end;

  @override
  bool isColumnSelected(ColumnIndex columnIndex) {
    ProgramSelectionKeyBox programSelectionKeyBox = ProgramSelectionKeyBox.fromSheetSelection(this);
    int startColumnIndex = programSelectionKeyBox.topLeft.columnIndex.value;
    int endColumnIndex = programSelectionKeyBox.topRight.columnIndex.value;

    return columnIndex.value >= startColumnIndex && columnIndex.value <= endColumnIndex;
  }

  @override
  bool isRowSelected(RowIndex rowIndex) {
    ProgramSelectionKeyBox programSelectionKeyBox = ProgramSelectionKeyBox.fromSheetSelection(this);
    int startRowIndex = programSelectionKeyBox.topLeft.rowIndex.value;
    int endRowIndex = programSelectionKeyBox.bottomLeft.rowIndex.value;

    return rowIndex.value >= startRowIndex && rowIndex.value <= endRowIndex;
  }

  @override
  SelectionDirection get selectionDirection {
    bool startBeforeEndRow = _start.rowIndex.value < _end.rowIndex.value;
    bool startBeforeEndColumn = _start.columnIndex.value < _end.columnIndex.value;

    if (startBeforeEndRow) {
      return startBeforeEndColumn ? SelectionDirection.bottomRight : SelectionDirection.bottomLeft;
    } else {
      return startBeforeEndColumn ? SelectionDirection.topRight : SelectionDirection.topLeft;
    }
  }

  @override
  bool get isCompleted => _completed;

  @override
  List<Object?> get props => [_start, _end];
}
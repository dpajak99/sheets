import 'dart:ui';

import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/sheet_selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;
  final bool editingEnabled;

  SheetSingleSelection({
    required super.paintConfig,
    required this.cellIndex,
    this.editingEnabled = false,
  }) : super(completed: true);

  SheetSingleSelection.defaultSelection({required super.paintConfig})
      : cellIndex = CellIndex.zero,
        editingEnabled = false,
        super(completed: true);

  @override
  CellIndex get start => cellIndex;

  @override
  CellIndex get end => cellIndex;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => SelectionStatus(cellIndex.columnIndex == columnIndex, false);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => SelectionStatus(cellIndex.rowIndex == rowIndex, false);


  CellConfig? get selectedCell => paintConfig.findCell(cellIndex);

  @override
  SheetSelectionPaint get paint => SheetSingleSelectionPaint(this);

  @override
  List<Object?> get props => [cellIndex];
}

class SheetSingleSelectionPaint extends SheetSelectionPaint {
  final SheetSingleSelection selection;

  SheetSingleSelectionPaint(this.selection);

  @override
  void paint(SheetPaintConfig paintConfig, Canvas canvas, Size size) {
    CellConfig? selectedCell = selection.selectedCell;
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
    paintFillHandle(canvas, selectedCell.rect.bottomRight);
  }
}

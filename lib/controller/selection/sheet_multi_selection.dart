import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/sheet_selection.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';

class SheetMultiSelection extends SheetSelection {
  final List<CellIndex> cells;

  SheetMultiSelection({
    required super.paintConfig,
    required this.cells,
  }) : super(completed: true);

  @override
  CellIndex get end => cells.first;

  @override
  CellIndex get start => cells.last;

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) {
    return SelectionStatus(cells.any((CellIndex cellIndex) => cellIndex.columnIndex == columnIndex), false);
  }

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) {
    return SelectionStatus(cells.any((CellIndex cellIndex) => cellIndex.rowIndex == rowIndex), false);
  }

  @override
  List<Object?> get props => [cells];

  @override
  SheetSelectionPaint get paint => throw UnimplementedError();
}

class SheetMultiSelectionPaint extends SheetSelectionPaint {
  final SheetMultiSelection selection;

  SheetMultiSelectionPaint(this.selection);

  @override
  void paint(SheetPaintConfig paintConfig, Canvas canvas, Size size) {
    for (CellIndex selectedCellIndex in selection.cells) {
      CellConfig? selectedCell = paintConfig.findCell(selectedCellIndex);
      if (selectedCell == null) {
        continue;
      }

      paintMainCell(canvas, selectedCell.rect);
      paintFillHandle(canvas, selectedCell.rect.bottomRight);
    }
  }
}

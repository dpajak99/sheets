import 'dart:ui';

import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/controller/sheet_viewport_delegate.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;
  final bool _fillHandleVisible;

  SheetSingleSelection({
    required super.paintConfig,
    required this.cellIndex,
    bool fillHandleVisible = true,
  })  : _fillHandleVisible = fillHandleVisible,
        super(completed: true);

  SheetSingleSelection.defaultSelection({required super.paintConfig})
      : cellIndex = CellIndex.zero,
        _fillHandleVisible = true,
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
  bool get fillHandleVisible => _fillHandleVisible;

  @override
  Offset? get fillHandleOffset => paintConfig.findCell(cellIndex)?.rect.bottomRight;

  @override
  List<CellIndex> get selectedCells {
    return [cellIndex];
  }

  @override
  SelectionCellCorners get selectionCorners {
    return SelectionCellCorners(cellIndex, cellIndex, cellIndex, cellIndex);
  }

  @override
  String stringifySelection() {
    return cellIndex.stringifyPosition();
  }

  @override
  List<Object?> get props => [cellIndex];
}

class SheetSingleSelectionPaint extends SheetSelectionPaint {
  final SheetSingleSelection selection;

  SheetSingleSelectionPaint(this.selection);

  @override
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size) {
    CellConfig? selectedCell = selection.selectedCell;
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
  }
}

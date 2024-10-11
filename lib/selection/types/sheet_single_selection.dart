import 'dart:ui';

import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/utils/cached_value.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;

  SheetSingleSelection({
    required this.cellIndex,
    required super.completed,
  });

  SheetSingleSelection.defaultSelection()
      : cellIndex = CellIndex.zero,
        super(completed: true);

  @override
  CellIndex get start => cellIndex;

  @override
  CellIndex get end => cellIndex;

  @override
  Set<CellIndex> get selectedCells => {cellIndex};

  @override
  SelectionCellCorners get selectionCellCorners => SelectionCellCorners.single(cellIndex);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => SelectionStatus(cellIndex.columnIndex == columnIndex, false);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => SelectionStatus(cellIndex.rowIndex == rowIndex, false);

  @override
  bool containsCell(CellIndex cellIndex) => this.cellIndex == cellIndex;

  @override
  String stringifySelection() => cellIndex.stringifyPosition();

  @override
  SheetSingleSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetSingleSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  SheetSelection complete() {
    return SheetSingleSelection(cellIndex: cellIndex, completed: true);
  }

  @override
  List<Object?> get props => <Object?>[cellIndex, isCompleted];
}

class SheetSingleSelectionRenderer extends SheetSelectionRenderer {
  final SheetSingleSelection selection;
  late final CachedValue<CellConfig?> _selectedCell;

  SheetSingleSelectionRenderer({
    required super.viewportDelegate,
    required this.selection,
  }) {
    _selectedCell = CachedValue<CellConfig?>(() => viewportDelegate.findCell(selection.trueStart));
  }

  @override
  bool get fillHandleVisible => selection.isCompleted == true;

  @override
  Offset? get fillHandleOffset => selectedCell?.rect.bottomRight;

  @override
  SheetSelectionPaint get paint => SheetSingleSelectionPaint(this);

  CellConfig? get selectedCell => _selectedCell.value;
}

class SheetSingleSelectionPaint extends SheetSelectionPaint {
  final SheetSingleSelectionRenderer renderer;

  SheetSingleSelectionPaint(this.renderer);

  @override
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size) {
    CellConfig? selectedCell = renderer.selectedCell;
    if (selectedCell == null) {
      return;
    }

    paintMainCell(canvas, selectedCell.rect);
  }
}

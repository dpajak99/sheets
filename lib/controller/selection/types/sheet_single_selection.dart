import 'dart:ui';

import 'package:sheets/models/selection_status.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/models/selection_corners.dart';
import 'package:sheets/models/sheet_item_config.dart';
import 'package:sheets/controller/selection/types/sheet_selection.dart';
import 'package:sheets/models/sheet_viewport_delegate.dart';
import 'package:sheets/utils/cached_value.dart';

class SheetSingleSelection extends SheetSelection {
  final CellIndex cellIndex;
  final bool active;

  SheetSingleSelection({
    required this.cellIndex,
    this.active = false,
  }) : super(completed: true);

  SheetSingleSelection.defaultSelection()
      : cellIndex = CellIndex.zero,
        active = true,
        super(completed: true);

  @override
  CellIndex get start => cellIndex;

  @override
  CellIndex get end => cellIndex;

  @override
  List<CellIndex> get selectedCells => [cellIndex];

  @override
  SelectionCellCorners get selectionCellCorners => SelectionCellCorners.single(cellIndex);

  @override
  SelectionStatus isColumnSelected(ColumnIndex columnIndex) => SelectionStatus(cellIndex.columnIndex == columnIndex, false);

  @override
  SelectionStatus isRowSelected(RowIndex rowIndex) => SelectionStatus(cellIndex.rowIndex == rowIndex, false);

  @override
  String stringifySelection() => cellIndex.stringifyPosition();

  @override
  SheetSingleSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate) {
    return SheetSingleSelectionRenderer(viewportDelegate: viewportDelegate, selection: this);
  }

  @override
  List<Object?> get props => <Object?>[cellIndex, active];
}

class SheetSingleSelectionRenderer extends SheetSelectionRenderer {
  final SheetSingleSelection selection;
  late final CachedValue<CellConfig?> _selectedCell;

  SheetSingleSelectionRenderer({
    required super.viewportDelegate,
    required this.selection,
  }) {
    _selectedCell = CachedValue<CellConfig?>(() => viewportDelegate.findCell(selection.start));
  }

  @override
  bool get fillHandleVisible => selection.active == false;

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

import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/selection/paints/sheet_single_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';
import 'package:sheets/utils/cached_value.dart';

class SheetSingleSelectionRenderer extends SheetSelectionRenderer {
  final SheetSingleSelection selection;
  late final CachedValue<CellConfig?> _selectedCell;

  SheetSingleSelectionRenderer({
    required super.viewportDelegate,
    required this.selection,
  }) {
    _selectedCell = CachedValue<CellConfig?>(() => viewportDelegate.findCell(selection.startCellIndex));
  }

  @override
  bool get fillHandleVisible => selection.isCompleted == true;

  @override
  Offset? get fillHandleOffset => selectedCell?.rect.bottomRight;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetSingleSelectionPaint(this, mainCellVisible, backgroundVisible);
  }

  CellConfig? get selectedCell => _selectedCell.value;
}


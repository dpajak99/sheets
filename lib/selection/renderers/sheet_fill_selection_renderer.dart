import 'package:sheets/selection/paints/sheet_fill_selection_paint.dart';
import 'package:sheets/selection/renderers/sheet_range_selection_renderer.dart';
import 'package:sheets/selection/sheet_selection_paint.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';

class SheetFillSelectionRenderer extends SheetRangeSelectionRenderer {
  SheetFillSelectionRenderer({
    required super.viewportDelegate,
    required super.selection,
  });

  @override
  SheetFillSelection get selection => super.selection as SheetFillSelection;

  @override
  SheetSelectionPaint getPaint({bool? mainCellVisible, bool? backgroundVisible}) {
    return SheetFillSelectionPaint(this, mainCellVisible, backgroundVisible);
  }
}


import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetSelectionLayerPainter extends ChangeNotifier implements CustomPainter {
  late SheetSelection _selection;
  late SheetViewport _viewport;
  
  void rebuild({
    required SheetSelection selection,
    required SheetViewport viewport,
}) {
    _selection = selection;
    _viewport = viewport;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth - borderWidth, columnHeadersHeight - borderWidth, size.width, size.height));

    SheetSelectionRenderer<SheetSelection> selectionRenderer = _selection.createRenderer(_viewport);

    SheetSelectionPaint selectionPaint = selectionRenderer.getPaint();
    selectionPaint.paint(_viewport, canvas, size);
  }

  @override
  bool shouldRepaint(covariant SheetSelectionLayerPainter oldDelegate) {
    return _selection != oldDelegate._selection || _viewport != oldDelegate._viewport;
  }

  @override
  bool? hitTest(Offset position) => false;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

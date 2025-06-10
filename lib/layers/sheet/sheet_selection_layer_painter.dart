import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_paint.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SheetSelectionLayerPainter extends ChangeNotifier implements CustomPainter {
  late SheetSelection _selection;
  late SheetViewport _viewport;
  late double _pinnedColumnsWidth;
  late double _pinnedRowsHeight;

  void rebuild({
    required SheetSelection selection,
    required SheetViewport viewport,
    required double pinnedColumnsWidth,
    required double pinnedRowsHeight,
  }) {
    _selection = selection;
    _viewport = viewport;
    _pinnedColumnsWidth = pinnedColumnsWidth;
    _pinnedRowsHeight = pinnedRowsHeight;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    List<Rect> clipRegions = <Rect>[
      Rect.fromLTWH(
        rowHeadersWidth + _pinnedColumnsWidth - borderWidth,
        columnHeadersHeight + _pinnedRowsHeight - borderWidth,
        size.width - _pinnedColumnsWidth,
        size.height - _pinnedRowsHeight,
      ),
      Rect.fromLTWH(
        rowHeadersWidth + _pinnedColumnsWidth - borderWidth,
        columnHeadersHeight - borderWidth,
        size.width - _pinnedColumnsWidth,
        _pinnedRowsHeight,
      ),
      Rect.fromLTWH(
        rowHeadersWidth - borderWidth,
        columnHeadersHeight + _pinnedRowsHeight - borderWidth,
        _pinnedColumnsWidth,
        size.height - _pinnedRowsHeight,
      ),
      Rect.fromLTWH(
        rowHeadersWidth - borderWidth,
        columnHeadersHeight - borderWidth,
        _pinnedColumnsWidth,
        _pinnedRowsHeight,
      ),
    ];

    SheetSelectionRenderer<SheetSelection> selectionRenderer = _selection.createRenderer(_viewport);
    SheetSelectionPaint selectionPaint = selectionRenderer.getPaint();

    for (Rect rect in clipRegions) {
      canvas.save();
      canvas.clipRect(rect);
      selectionPaint.paint(_viewport, canvas, size);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant SheetSelectionLayerPainter oldDelegate) {
    return _selection != oldDelegate._selection ||
        _viewport != oldDelegate._viewport ||
        _pinnedColumnsWidth != oldDelegate._pinnedColumnsWidth ||
        _pinnedRowsHeight != oldDelegate._pinnedRowsHeight;
  }

  @override
  bool? hitTest(Offset position) => false;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

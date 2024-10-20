import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SheetMeshLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetMeshLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetMeshLayerState();
}

class _SheetMeshLayerState extends State<SheetMeshLayer> {
  late final _SheetMeshPainter _sheetCellsPainter;

  @override
  void initState() {
    super.initState();
    _sheetCellsPainter = _SheetMeshPainter(
      visibleColumns: widget.sheetController.viewport.visibleContent.columns,
      visibleRows: widget.sheetController.viewport.visibleContent.rows,
    );
    widget.sheetController.viewport.visibleContent.addListener(_updateVisibleCells);
  }

  @override
  void dispose() {
    widget.sheetController.viewport.visibleContent.removeListener(_updateVisibleCells);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _sheetCellsPainter),
    );
  }

  void _updateVisibleCells() {
    _sheetCellsPainter.update(
      widget.sheetController.viewport.visibleContent.columns,
      widget.sheetController.viewport.visibleContent.rows,
    );
  }
}

class _SheetMeshPainter extends _SheetMeshBasePainter {
  _SheetMeshPainter({
    required List<ViewportColumn> visibleColumns,
    required List<ViewportRow> visibleRows,
  })  : _visibleColumns = visibleColumns,
        _visibleRows = visibleRows;

  late List<ViewportColumn> _visibleColumns;
  late List<ViewportRow> _visibleRows;

  void update(List<ViewportColumn> visibleColumns, List<ViewportRow> visibleRows) {
    _visibleColumns = visibleColumns;
    _visibleRows = visibleRows;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if(_visibleColumns.isEmpty || _visibleRows.isEmpty) {
      return;
    }

    ViewportColumn lastColumn = _visibleColumns.last;
    ViewportRow lastRow = _visibleRows.last;

    double maxOffsetRight = min(size.width, lastColumn.rect.right);
    double maxOffsetBottom = min(size.height, lastRow.rect.bottom);

    paintMeshBackground(canvas, Rect.fromLTWH(0, 0, maxOffsetRight, maxOffsetBottom));

    for(ViewportColumn column in _visibleColumns) {
      Rect columnRect = column.rect;
      paintMeshLine(canvas, Offset(columnRect.right, 0), Offset(columnRect.right, maxOffsetBottom));
    }
    
    for(ViewportRow row in _visibleRows) {
      Rect rowRect = row.rect;
      paintMeshLine(canvas, Offset(0, rowRect.bottom), Offset(maxOffsetRight, rowRect.bottom));
    }
  }

  @override
  bool shouldRepaint(covariant _SheetMeshPainter oldDelegate) {
    return oldDelegate._visibleColumns != _visibleColumns || oldDelegate._visibleRows != _visibleRows;
  }
}

abstract class _SheetMeshBasePainter extends ChangeNotifier implements CustomPainter {
  void paintMeshBackground(Canvas canvas, Rect rect) {
    Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);
  }

  void paintMeshLine(Canvas canvas, Offset startOffset, Offset endOffset) {
    Paint borderPaint = Paint()
      ..color = const Color(0xffe1e1e1)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawLine(startOffset, endOffset, borderPaint);
  }
  
  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

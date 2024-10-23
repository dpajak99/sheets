import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class SheetHeadersPainter extends ChangeNotifier implements CustomPainter {
  void paintHeadersBackground(Canvas canvas, Rect rect, SelectionStatus selectionStatus) {
    Color backgroundColor = selectionStatus.selectValue(
      fullySelected: const Color(0xff2456cb),
      selected: const Color(0xffd6e2fb),
      notSelected: const Color(0xffffffff),
    );

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);
  }

  void paintHeadersBorder(Canvas canvas, Rect rect, {bool top = true}) {
    Paint borderPaint = Paint()
      ..color = const Color(0xffc4c7c5)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    if (top) {
      canvas.drawLine(rect.topLeft, rect.topRight, borderPaint);
    }
    canvas.drawLine(rect.topRight, rect.bottomRight, borderPaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, borderPaint);
    canvas.drawLine(rect.topLeft, rect.bottomLeft, borderPaint);
  }

  void paintRowLabel(Canvas canvas, Rect rect, String value, SelectionStatus selectionStatus) {
    TextStyle textStyle = selectionStatus.selectValue(
      fullySelected: defaultHeaderTextStyleSelectedAll.copyWith(height: 1.2),
      selected: defaultHeaderTextStyleSelected.copyWith(height: 1.2),
      notSelected: defaultHeaderTextStyle.copyWith(height: 1.2),
    );

    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(text: value, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: rect.width, maxWidth: rect.width);
    textPainter.paint(canvas, rect.center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void paintColumnLabel(Canvas canvas, Rect rect, String value, SelectionStatus selectionStatus) {
    TextStyle textStyle = selectionStatus.selectValue(
      fullySelected: defaultHeaderTextStyleSelectedAll.copyWith(height: 1),
      selected: defaultHeaderTextStyleSelected.copyWith(height: 1),
      notSelected: defaultHeaderTextStyle.copyWith(height: 1),
    );

    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(text: value, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: rect.width, maxWidth: rect.width);
    textPainter.paint(canvas, rect.center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}

class SheetHorizontalHeadersPainter extends SheetHeadersPainter {
  SheetHorizontalHeadersPainter({
    required List<ViewportColumn> visibleColumns,
    required SheetSelection selection,
  })  : _visibleColumns = visibleColumns,
        _selection = selection;

  late List<ViewportColumn> _visibleColumns;

  set visibleColumns(List<ViewportColumn> value) {
    _visibleColumns = value;
    notifyListeners();
  }

  late SheetSelection _selection;

  set selection(SheetSelection value) {
    _selection = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ViewportColumn column in _visibleColumns) {
      SelectionStatus selectionStatus = _selection.isColumnSelected(column.index);

      paintHeadersBackground(canvas, column.rect, selectionStatus);
      paintHeadersBorder(canvas, column.rect, top: false);
      paintColumnLabel(canvas, column.rect, column.value, selectionStatus);
    }
  }

  @override
  bool shouldRepaint(covariant SheetHorizontalHeadersPainter oldDelegate) {
    return oldDelegate._visibleColumns != _visibleColumns || oldDelegate._selection != _selection;
  }
}

class SheetVerticalHeadersPainter extends SheetHeadersPainter {
  SheetVerticalHeadersPainter({
    required List<ViewportRow> visibleRows,
    required SheetSelection selection,
  })  : _visibleRows = visibleRows,
        _selection = selection;

  late List<ViewportRow> _visibleRows;

  set visibleRows(List<ViewportRow> value) {
    _visibleRows = value;
    notifyListeners();
  }

  late SheetSelection _selection;

  set selection(SheetSelection value) {
    _selection = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (ViewportRow row in _visibleRows) {
      SelectionStatus selectionStatus = _selection.isRowSelected(row.index);

      paintHeadersBackground(canvas, row.rect, selectionStatus);
      paintHeadersBorder(canvas, row.rect);
      paintRowLabel(canvas, row.rect, row.value, selectionStatus);
    }
  }

  @override
  bool shouldRepaint(covariant SheetVerticalHeadersPainter oldDelegate) {
    return oldDelegate._visibleRows != _visibleRows || oldDelegate._selection != _selection;
  }
}

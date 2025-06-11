import 'dart:math';

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

class SheetColumnHeadersPainter extends SheetHeadersPainter {
  late List<ViewportColumn> _visibleColumns;
  late SheetSelection _selection;
  late double _pinnedWidth;
  late int _pinnedCount;

  void rebuild({
    required List<ViewportColumn> visibleColumns,
    required SheetSelection selection,
    required int pinnedCount,
    required double pinnedWidth,
  }) {
    _visibleColumns = visibleColumns;
    _selection = selection;
    _pinnedCount = pinnedCount;
    _pinnedWidth = pinnedWidth;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_visibleColumns.isEmpty) {
      return;
    }
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false
      ..color = const Color(0xffc4c7c5);

    double width = min(size.width, _visibleColumns.last.rect.right - rowHeadersWidth + borderWidth);
    Rect visibleRect = Rect.fromLTWH(rowHeadersWidth, 0, width, size.height);
    canvas.clipRect(visibleRect);
    canvas.drawRect(visibleRect, backgroundPaint);

    List<ViewportColumn> pinned = <ViewportColumn>[];
    List<ViewportColumn> normal = <ViewportColumn>[];

    for (ViewportColumn column in _visibleColumns) {
      if (column.index.value < _pinnedCount) {
        pinned.add(column);
      } else {
        normal.add(column);
      }
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      rowHeadersWidth + _pinnedWidth + pinnedBorderWidth,
      0,
      size.width - _pinnedWidth,
      size.height,
    ));
    for (ViewportColumn column in normal) {
      SelectionStatus selectionStatus = _selection.isColumnSelected(column.index);
      paintHeadersBackground(canvas, column.rect, selectionStatus);
      paintColumnLabel(canvas, column.rect, column.value, selectionStatus);
    }
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(rowHeadersWidth, 0, _pinnedWidth + pinnedBorderWidth, size.height));
    for (ViewportColumn column in pinned) {
      SelectionStatus selectionStatus = _selection.isColumnSelected(column.index);
      paintHeadersBackground(canvas, column.rect, selectionStatus);
      paintColumnLabel(canvas, column.rect, column.value, selectionStatus);
    }
    canvas.restore();

    Paint borderPaint = Paint()
      ..color = const Color(0xffb7b7b7)
      ..style = PaintingStyle.fill;

    if (_pinnedWidth > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          rowHeadersWidth + _pinnedWidth,
          0,
          pinnedBorderWidth,
          size.height,
        ),
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SheetColumnHeadersPainter oldDelegate) {
    return oldDelegate._visibleColumns != _visibleColumns ||
        oldDelegate._selection != _selection ||
        oldDelegate._pinnedWidth != _pinnedWidth ||
        oldDelegate._pinnedCount != _pinnedCount;
  }
}

class SheetRowHeadersPainter extends SheetHeadersPainter {
  late List<ViewportRow> _visibleRows;
  late SheetSelection _selection;
  late double _pinnedHeight;
  late int _pinnedCount;

  void rebuild({
    required List<ViewportRow> visibleRows,
    required SheetSelection selection,
    required int pinnedCount,
    required double pinnedHeight,
  }) {
    _visibleRows = visibleRows;
    _selection = selection;
    _pinnedCount = pinnedCount;
    _pinnedHeight = pinnedHeight;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_visibleRows.isEmpty) {
      return;
    }

    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false
      ..color = const Color(0xffc4c7c5);

    double height = min(size.height, _visibleRows.last.rect.bottom - columnHeadersHeight + borderWidth);
    Rect visibleRect = Rect.fromLTWH(0, columnHeadersHeight, size.width, height);
    canvas.clipRect(visibleRect);
    canvas.drawRect(visibleRect, backgroundPaint);

    List<ViewportRow> pinned = <ViewportRow>[];
    List<ViewportRow> normal = <ViewportRow>[];

    for (ViewportRow row in _visibleRows) {
      if (row.index.value < _pinnedCount) {
        pinned.add(row);
      } else {
        normal.add(row);
      }
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      0,
      columnHeadersHeight + _pinnedHeight + pinnedBorderWidth,
      size.width,
      size.height - _pinnedHeight,
    ));
    for (ViewportRow row in normal) {
      SelectionStatus selectionStatus = _selection.isRowSelected(row.index);
      paintHeadersBackground(canvas, row.rect, selectionStatus);
      paintRowLabel(canvas, row.rect, row.value, selectionStatus);
    }
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, columnHeadersHeight, size.width, _pinnedHeight + pinnedBorderWidth));
    for (ViewportRow row in pinned) {
      SelectionStatus selectionStatus = _selection.isRowSelected(row.index);
      paintHeadersBackground(canvas, row.rect, selectionStatus);
      paintRowLabel(canvas, row.rect, row.value, selectionStatus);
    }
    canvas.restore();

    Paint borderPaint = Paint()
      ..color = const Color(0xffb7b7b7)
      ..style = PaintingStyle.fill;

    if (_pinnedHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          columnHeadersHeight + _pinnedHeight,
          size.width,
          pinnedBorderWidth,
        ),
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SheetRowHeadersPainter oldDelegate) {
    return oldDelegate._visibleRows != _visibleRows ||
        oldDelegate._selection != _selection ||
        oldDelegate._pinnedHeight != _pinnedHeight ||
        oldDelegate._pinnedCount != _pinnedCount;
  }
}

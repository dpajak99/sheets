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

  /// Rebuilds the painter state with a new set of columns and selection.
  void rebuild({
    required List<ViewportColumn> visibleColumns,
    required SheetSelection selection,
  }) {
    _visibleColumns = visibleColumns;
    _selection = selection;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // If there are no columns to draw, exit early.
    if (_visibleColumns.isEmpty) {
      return;
    }

    // Separate pinned columns from scrollable columns.
    List<ViewportColumn> pinnedColumns = _visibleColumns
        .where((ViewportColumn col) => col.isPinned)
        .toList();
    List<ViewportColumn> scrollableColumns = _visibleColumns
        .where((ViewportColumn col) => !col.isPinned)
        .toList();

    // Paint used for background color.
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false
      ..color = const Color(0xffc4c7c5);

    // 1. Compute the bounding box for pinned columns.
    //    Assume pinnedColumns are sorted from left to right.
    double pinnedLeft = rowHeadersWidth;
    double pinnedRight = pinnedColumns.isEmpty
        ? pinnedLeft
        : pinnedColumns.last.rect.right;
    Rect pinnedRect = Rect.fromLTWH(
      pinnedLeft,
      0,
      max(0, pinnedRight - pinnedLeft),
      size.height,
    );

    // 2. Compute the bounding box for scrollable columns,
    //    starting right after the pinned columns.
    double scrollableLeft = pinnedRight;
    double scrollableWidth = max(0, size.width - (scrollableLeft - rowHeadersWidth));
    Rect scrollableRect = Rect.fromLTWH(
      scrollableLeft,
      0,
      scrollableWidth,
      size.height,
    );

    // 3. Paint the pinned section:
    //    - Draw its background.
    //    - clipRect to ensure pinned columns do not paint outside pinnedRect.
    //    - Paint each pinned header.
    canvas.drawRect(pinnedRect, backgroundPaint);
    canvas.save();
    canvas.clipRect(pinnedRect);

    for (ViewportColumn column in pinnedColumns) {
      SelectionStatus selectionStatus = _selection.isColumnSelected(column.index);
      paintHeadersBackground(canvas, column.rect, selectionStatus);
      paintColumnLabel(canvas, column.rect, column.value, selectionStatus);
    }

    canvas.restore();

    // 4. Paint the scrollable section:
    //    - Draw its background.
    //    - clipRect to ensure scrollable columns do not overlap pinnedRect.
    //    - Paint each scrollable header.
    canvas.drawRect(scrollableRect, backgroundPaint);
    canvas.save();
    canvas.clipRect(scrollableRect);

    for (ViewportColumn column in scrollableColumns) {
      SelectionStatus selectionStatus = _selection.isColumnSelected(column.index);
      paintHeadersBackground(canvas, column.rect, selectionStatus);
      paintColumnLabel(canvas, column.rect, column.value, selectionStatus);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SheetColumnHeadersPainter oldDelegate) {
    return oldDelegate._visibleColumns != _visibleColumns
        || oldDelegate._selection != _selection;
  }
}

/// A painter that draws row headers, separating pinned rows at the top
/// from scrollable rows below.
class SheetRowHeadersPainter extends SheetHeadersPainter {
  late List<ViewportRow> _visibleRows;
  late SheetSelection _selection;

  /// Updates the painter with a new set of visible rows and selection state.
  void rebuild({
    required List<ViewportRow> visibleRows,
    required SheetSelection selection,
  }) {
    _visibleRows = visibleRows;
    _selection = selection;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // If there are no rows to paint, exit early.
    if (_visibleRows.isEmpty) {
      return;
    }

    // Separate pinned rows from scrollable rows.
    // You need an 'isPinned' property in your ViewportRow model for this to work.
    List<ViewportRow> pinnedRows = _visibleRows
        .where((ViewportRow row) => row.isPinned)
        .toList();

    List<ViewportRow> scrollableRows = _visibleRows
        .where((ViewportRow row) => !row.isPinned)
        .toList();

    // Paint used for background color.
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false
      ..color = const Color(0xffc4c7c5);

    // 1. Compute the bounding box for pinned rows.
    //    pinnedRows might be sorted from top to bottom; if not, sort by rect.top.
    double pinnedTop = columnHeadersHeight;
    double pinnedBottom = pinnedRows.isEmpty
        ? pinnedTop
        : pinnedRows.last.rect.bottom;
    Rect pinnedRect = Rect.fromLTWH(
      0,
      pinnedTop,
      size.width,
      max(0, pinnedBottom - pinnedTop),
    );

    // 2. Compute the bounding box for scrollable rows,
    //    which begin where pinned rows end.
    double scrollableTop = pinnedBottom;
    Rect scrollableRect = Rect.fromLTWH(
      0,
      scrollableTop,
      size.width,
      max(0, size.height - scrollableTop),
    );

    // 3. Paint pinned rows.
    canvas.save();
    canvas.clipRect(pinnedRect);
    canvas.drawRect(pinnedRect, backgroundPaint);

    for ( ViewportRow row in pinnedRows) {
       SelectionStatus selectionStatus = _selection.isRowSelected(row.index);
      paintHeadersBackground(canvas, row.rect, selectionStatus);
      paintRowLabel(canvas, row.rect, row.value, selectionStatus);
    }

    canvas.restore();

    // 4. Paint scrollable rows.
    canvas.save();
    canvas.clipRect(scrollableRect);
    canvas.drawRect(scrollableRect, backgroundPaint);

    for ( ViewportRow row in scrollableRows) {
       SelectionStatus selectionStatus = _selection.isRowSelected(row.index);
      paintHeadersBackground(canvas, row.rect, selectionStatus);
      paintRowLabel(canvas, row.rect, row.value, selectionStatus);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SheetRowHeadersPainter oldDelegate) {
    return oldDelegate._visibleRows != _visibleRows
        || oldDelegate._selection != _selection;
  }

}

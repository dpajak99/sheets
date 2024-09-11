import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/sheet_constants.dart';

class SheetScrollController {
  Offset _localOffset = Offset.zero;
  Offset get _offset => _localOffset;
  set _offset(Offset offset) {
    _localOffset = offset;
    verticalScrollListener.value = offset.dy;
    horizontalScrollListener.value = offset.dx;
  }

  Size viewportSize = Size.zero;

  Map<int, double> customRowExtents = {};
  Map<int, double> customColumnExtents = {};
  
  late final ValueNotifier<double> verticalScrollListener = ValueNotifier<double>(_offset.dy);
  late final ValueNotifier<double> horizontalScrollListener = ValueNotifier<double>(_offset.dx);

  SheetScrollController();

  void scrollBy(Offset delta) {
    Offset newOffset = Offset(
      min(max(0, _offset.dx + delta.dx), maxHorizontalScrollExtent > 0 ? maxHorizontalScrollExtent : 0),
      min(max(0, _offset.dy + delta.dy), maxVerticalScrollExtent > 0 ? maxVerticalScrollExtent : 0),
    );
    _offset = newOffset;
  }

  (double, RowIndex) get firstVisibleRow {
    int scrolledRows;
    double hiddenHeight;

    (scrolledRows, hiddenHeight) = calculateScrolledRows();

    return (hiddenHeight, RowIndex(scrolledRows));
  }

  double get maxVerticalScrollExtent {
    return contentHeight - viewportSize.height + 50 + columnHeadersHeight;
  }

  double get contentHeight {
    double contentHeight = 0;
    for (int i = 0; i < defaultRowCount; i++) {
      double rowHeight = customRowExtents[i] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }
    return contentHeight;
  }

  double get maxHorizontalScrollExtent {
    return contentWidth - viewportSize.width + rowHeadersWidth;
  }

  double get contentWidth {
    double contentWidth = 0;
    for (int i = 0; i < defaultColumnCount; i++) {
      double columnWidth = customColumnExtents[i] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }
    return contentWidth;
  }

  (double, ColumnIndex) get firstVisibleColumn {
    int scrolledColumns;
    double hiddenWidth;

    (scrolledColumns, hiddenWidth) = calculateScrolledColumns();

    return (hiddenWidth, ColumnIndex(scrolledColumns));
  }

  (int, double) calculateScrolledRows() {
    double scrolledY = _offset.dy;
    double contentHeight = 0;
    int hiddenRows = -1;

    while (contentHeight < scrolledY) {
      hiddenRows++;
      double rowHeight = customRowExtents[hiddenRows] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }

    double rowHeight = customRowExtents[hiddenRows] ?? defaultRowHeight;
    double verticalOverscroll = scrolledY - contentHeight;
    double hiddenHeight = ((-rowHeight) - verticalOverscroll);
    return (hiddenRows, hiddenHeight);
  }

  (int, double) calculateScrolledColumns() {
    double scrolledX = _offset.dx;
    double contentWidth = 0;
    int hiddenColumns = -1;

    while (contentWidth < scrolledX) {
      hiddenColumns++;
      double columnWidth = customColumnExtents[hiddenColumns] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }

    double columnWidth = customColumnExtents[hiddenColumns] ?? defaultColumnWidth;
    double horizontalOverscroll = scrolledX - contentWidth;
    double hiddenWidth = ((-columnWidth) - horizontalOverscroll);
    return (hiddenColumns, hiddenWidth);
  }
}

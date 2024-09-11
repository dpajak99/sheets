import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/sheet_constants.dart';

class SheetScrollController {
  Offset offset = Offset.zero;

  Map<int, double> customRowExtents = {};
  Map<int, double> customColumnExtents = {};

  SheetScrollController();

  void scrollBy(Offset delta) {
    offset = Offset(max(0, offset.dx + delta.dx), max(0, offset.dy + delta.dy));
  }

  (double, RowIndex) get firstVisibleRow {
    int scrolledRows;
    double hiddenHeight;

    (scrolledRows, hiddenHeight) = calculateScrolledRows();

    return (hiddenHeight, RowIndex(scrolledRows));
  }

  (double, ColumnIndex) get firstVisibleColumn {
    int scrolledColumns;
    double hiddenWidth;

    (scrolledColumns, hiddenWidth) = calculateScrolledColumns();

    return (hiddenWidth, ColumnIndex(scrolledColumns));
  }

  (int, double) calculateScrolledRows() {
    double scrolledY = offset.dy;
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
    double scrolledX = offset.dx;
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

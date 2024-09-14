import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/sheet_scroll_physics.dart';
import 'package:sheets/sheet_constants.dart';

class SheetScrollPosition {
  late final ValueNotifier<double> verticalScrollListener = ValueNotifier<double>(offset.dy);
  late final ValueNotifier<double> horizontalScrollListener = ValueNotifier<double>(offset.dx);

  Offset _offset = Offset.zero;
  Offset get offset => _offset;
  set offset(Offset offset) {
    _offset = offset;
    verticalScrollListener.value = offset.dy;
    horizontalScrollListener.value = offset.dx;
  }

  double get scrolledY => offset.dy;

  double get scrolledX => offset.dx;
}

class SheetScrollController {
  final SheetScrollPhysics physics = SmoothScrollPhysics();
  final SheetScrollPosition position = SheetScrollPosition();

  Size viewportSize = Size.zero;

  Map<int, double> customRowExtents = {};
  Map<int, double> customColumnExtents = {};

  SheetScrollController() {
    physics.applyTo(this);
  }

  void scrollBy(Offset delta) {
    position.offset = physics.parseScrolledOffset(position.offset, delta);
  }

  (RowIndex, double) get firstVisibleRow {
    double contentHeight = 0;
    int hiddenRows = 0;

    while (contentHeight < position.scrolledY) {
      hiddenRows++;
      double rowHeight = customRowExtents[hiddenRows] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }

    double rowHeight = customRowExtents[hiddenRows] ?? defaultRowHeight;
    double verticalOverscroll = position.scrolledY - contentHeight;
    if (verticalOverscroll != 0) {
      double hiddenHeight = ((-rowHeight) - verticalOverscroll);
      return (RowIndex(hiddenRows), hiddenHeight);
    } else {
      return (RowIndex(hiddenRows), 0);
    }
  }

  (ColumnIndex, double) get firstVisibleColumn {
    double contentWidth = 0;
    int hiddenColumns = 0;

    while (contentWidth < position.scrolledX) {
      hiddenColumns++;
      double columnWidth = customColumnExtents[hiddenColumns] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }

    double columnWidth = customColumnExtents[hiddenColumns] ?? defaultColumnWidth;
    double horizontalOverscroll = position.scrolledX - contentWidth;

    if (horizontalOverscroll != 0) {
      double hiddenWidth = ((-columnWidth) - horizontalOverscroll);
      return (ColumnIndex(hiddenColumns), hiddenWidth);
    } else {
      return (ColumnIndex(hiddenColumns), 0);
    }
  }

  double get maxVerticalScrollExtent {
    return contentHeight - viewportSize.height + 50 + columnHeadersHeight;
  }

  double get maxHorizontalScrollExtent {
    return contentWidth - viewportSize.width + rowHeadersWidth;
  }

  double get contentHeight {
    double contentHeight = 0;
    for (int i = 0; i < defaultRowCount; i++) {
      double rowHeight = customRowExtents[i] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }
    return contentHeight;
  }

  double get contentWidth {
    double contentWidth = 0;
    for (int i = 0; i < defaultColumnCount; i++) {
      double columnWidth = customColumnExtents[i] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }
    return contentWidth;
  }
}

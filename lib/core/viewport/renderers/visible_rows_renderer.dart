import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/directional_values.dart';

class VisibleRowsRenderer {
  VisibleRowsRenderer({
    required this.viewportRect,
    required this.properties,
    required this.scrollPosition,
  });

  final SheetViewportRect viewportRect;

  final SheetProperties properties;

  final DirectionalValues<SheetScrollPosition> scrollPosition;

  List<ViewportRow> build() {
    double firstVisibleCoordinate = scrollPosition.vertical.offset;
    _FirstVisibleRowInfo firstVisibleRowInfo = _findRowByY(firstVisibleCoordinate);

    double maxContentHeight = viewportRect.height - columnHeadersHeight;
    double currentContentHeight = -firstVisibleRowInfo.hiddenHeight;

    List<ViewportRow> visibleRows = <ViewportRow>[];
    int index = firstVisibleRowInfo.index.value;

    while (currentContentHeight < maxContentHeight && index < properties.rowCount) {
      RowIndex rowIndex = RowIndex(index);
      RowStyle rowStyle = properties.getRowStyle(rowIndex);

      ViewportRow viewportRow = ViewportRow(
        index: rowIndex,
        style: rowStyle,
        rect: Rect.fromLTWH(0, currentContentHeight + columnHeadersHeight, rowHeadersWidth, rowStyle.height),
      );
      visibleRows.add(viewportRow);
      currentContentHeight += viewportRow.style.height;

      index++;
    }

    return visibleRows;
  }

  _FirstVisibleRowInfo _findRowByY(double y) {
    int actualRowIndex = 0;
    double currentHeightStart = 0;

    _FirstVisibleRowInfo? firstVisibleRowInfo;

    while (firstVisibleRowInfo == null) {
      RowIndex rowIndex = RowIndex(actualRowIndex);
      RowStyle rowStyle = properties.getRowStyle(rowIndex);
      double rowHeightEnd = currentHeightStart + rowStyle.height;

      if (y >= currentHeightStart && y < rowHeightEnd) {
        firstVisibleRowInfo = _FirstVisibleRowInfo(
          index: rowIndex,
          startCoordinate: currentHeightStart,
          visibleHeight: rowHeightEnd - y,
          hiddenHeight: y - currentHeightStart,
        );
      } else {
        actualRowIndex++;
        currentHeightStart = rowHeightEnd;
      }
    }

    return firstVisibleRowInfo;
  }
}

class _FirstVisibleRowInfo with EquatableMixin {
  const _FirstVisibleRowInfo({
    required this.index,
    required this.startCoordinate,
    required this.visibleHeight,
    required this.hiddenHeight,
  });

  final RowIndex index;
  final double startCoordinate;
  final double visibleHeight;
  final double hiddenHeight;

  @override
  List<Object?> get props => <Object?>[index, startCoordinate, visibleHeight, hiddenHeight];
}

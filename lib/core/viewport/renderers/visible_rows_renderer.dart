import 'package:equatable/equatable.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleRowsRenderer {
  VisibleRowsRenderer({
    required this.viewportRect,
    required this.data,
    required this.scrollOffset,
  });

  final SheetViewportRect viewportRect;

  final SheetData data;

  final double scrollOffset;

  List<ViewportRow> build() {
    double firstVisibleCoordinate = scrollOffset;
    _FirstVisibleRowInfo firstVisibleRowInfo = _findRowByY(firstVisibleCoordinate);

    double maxContentHeight = viewportRect.height - columnHeadersHeight;
    double currentContentHeight = -firstVisibleRowInfo.hiddenHeight;

    List<ViewportRow> visibleRows = <ViewportRow>[];
    int index = firstVisibleRowInfo.index.value;

    while (currentContentHeight < maxContentHeight && index < data.rowCount) {
      RowIndex rowIndex = RowIndex(index);
      RowStyle rowStyle = data.getRowStyle(rowIndex);

      ViewportRow viewportRow = ViewportRow(
        index: rowIndex,
        style: rowStyle,
        rect: BorderRect.fromLTWH(0, currentContentHeight + columnHeadersHeight + borderWidth, rowHeadersWidth, rowStyle.height),
      );
      visibleRows.add(viewportRow);
      currentContentHeight += viewportRow.style.height + borderWidth;

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
      RowStyle rowStyle = data.getRowStyle(rowIndex);
      double rowHeightEnd = currentHeightStart + rowStyle.height + borderWidth;

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

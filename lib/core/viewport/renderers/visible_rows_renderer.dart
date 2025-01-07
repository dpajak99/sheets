import 'package:equatable/equatable.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class VisibleRowsRenderer {
  VisibleRowsRenderer({
    required this.viewportRect,
    required this.worksheet,
    required this.scrollOffset,
  });

  final SheetViewportRect viewportRect;

  final Worksheet worksheet;

  final double scrollOffset;

  List<ViewportRow> build() {
    double firstVisibleCoordinate = scrollOffset;
    _FirstVisibleRowInfo firstVisibleRowInfo = _findRowByY(firstVisibleCoordinate);

    double maxContentHeight = viewportRect.height - columnHeadersHeight;
    double currentContentHeight = -firstVisibleRowInfo.hiddenHeight;

    List<ViewportRow> visibleRows = <ViewportRow>[];
    int index = firstVisibleRowInfo.index.value;

    while (currentContentHeight < maxContentHeight && index < worksheet.rows) {
      RowIndex rowIndex = RowIndex(index);
      RowConfig rowConfig = worksheet.getRow(rowIndex);

      ViewportRow viewportRow = ViewportRow(
        index: rowIndex,
        config: rowConfig,
        rect: BorderRect.fromLTWH(0, currentContentHeight + columnHeadersHeight + borderWidth, rowHeadersWidth, rowConfig.height),
      );
      visibleRows.add(viewportRow);
      currentContentHeight += viewportRow.config.height + borderWidth;

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
      RowConfig rowConfig = worksheet.getRow(rowIndex);
      double rowHeightEnd = currentHeightStart + rowConfig.height + borderWidth;

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

import 'package:equatable/equatable.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/directional_values.dart';

class VisibleColumnsRenderer {
  VisibleColumnsRenderer({
    required this.viewportRect,
    required this.properties,
    required this.scrollPosition,
  });

  final SheetViewportRect viewportRect;
  final SheetDataManager properties;
  final DirectionalValues<SheetScrollPosition> scrollPosition;

  List<ViewportColumn> build() {
    double firstVisibleCoordinate = scrollPosition.horizontal.offset;
    _FirstVisibleColumnInfo firstVisibleColumnInfo = _findColumnByX(firstVisibleCoordinate);

    double maxContentWidth = viewportRect.width - rowHeadersWidth;
    double currentContentWidth = -firstVisibleColumnInfo.hiddenWidth;

    List<ViewportColumn> visibleColumns = <ViewportColumn>[];
    int index = firstVisibleColumnInfo.index.value;

    while (currentContentWidth < maxContentWidth && index < properties.columnCount) {
      ColumnIndex columnIndex = ColumnIndex(index);
      ColumnStyle columnStyle = properties.getColumnStyle(columnIndex);

      ViewportColumn viewportColumn = ViewportColumn(
        index: columnIndex,
        style: columnStyle,
        rect: BorderRect.fromLTWH(currentContentWidth + rowHeadersWidth, 0, columnStyle.width, columnHeadersHeight),
      );
      visibleColumns.add(viewportColumn);
      currentContentWidth += viewportColumn.style.width + borderWidth;

      index++;
    }

    return visibleColumns;
  }

  _FirstVisibleColumnInfo _findColumnByX(double x) {
    int actualColumnIndex = 0;
    double currentWidthStart = 0;

    _FirstVisibleColumnInfo? firstVisibleColumnInfo;

    while (firstVisibleColumnInfo == null) {
      ColumnIndex columnIndex = ColumnIndex(actualColumnIndex);
      ColumnStyle columnStyle = properties.getColumnStyle(columnIndex);
      double columnWidthEnd = currentWidthStart + columnStyle.width + borderWidth;

      if (x >= currentWidthStart && x < columnWidthEnd) {
        firstVisibleColumnInfo = _FirstVisibleColumnInfo(
          index: columnIndex,
          startCoordinate: currentWidthStart,
          visibleWidth: columnWidthEnd - x,
          hiddenWidth: x - currentWidthStart,
        );
      } else {
        actualColumnIndex++;
        currentWidthStart = columnWidthEnd;
      }
    }

    return firstVisibleColumnInfo;
  }
}

class _FirstVisibleColumnInfo with EquatableMixin {
  const _FirstVisibleColumnInfo({
    required this.index,
    required this.startCoordinate,
    required this.visibleWidth,
    required this.hiddenWidth,
  });

  final ColumnIndex index;
  final double startCoordinate;
  final double visibleWidth;
  final double hiddenWidth;

  @override
  List<Object?> get props => <Object?>[index, startCoordinate, visibleWidth, hiddenWidth];
}

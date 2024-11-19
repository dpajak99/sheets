import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_scroll_physics.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/utils/directional_values.dart';

class SheetScrollController extends ChangeNotifier {
  SheetScrollController({
    SheetScrollPhysics? physics,
  }) {
    position = DirectionalValues<SheetScrollPosition>(
      SheetScrollPosition(),
      SheetScrollPosition(),
    );

    metrics = DirectionalValues<SheetScrollMetrics>(
      SheetScrollMetrics.zero(SheetAxisDirection.vertical),
      SheetScrollMetrics.zero(SheetAxisDirection.horizontal),
    );

    _physics = (physics ?? SmoothScrollPhysics())..applyTo(this);

    position.addListener(notifyListeners);
    metrics.addListener(notifyListeners);
  }

  late final SheetScrollPhysics _physics;
  late final DirectionalValues<SheetScrollPosition> position;
  late final DirectionalValues<SheetScrollMetrics> metrics;

  @override
  void dispose() {
    metrics.dispose();
    position.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void applyProperties(SheetDataManager properties) {
    double contentHeight = 0;
    for (int i = 0; i < properties.rowCount; i++) {
      double rowHeight = properties.getRowHeight(RowIndex(i));
      contentHeight += rowHeight;
    }

    double contentWidth = 0;
    for (int i = 0; i < properties.columnCount; i++) {
      double columnWidth = properties.getColumnWidth(ColumnIndex(i));
      contentWidth += columnWidth;
    }

    metrics.update(
      horizontal: metrics.horizontal.copyWith(contentSize: contentWidth),
      vertical: metrics.vertical.copyWith(contentSize: contentHeight),
    );
  }

  void scrollBy(Offset delta) {
    Offset currentOffset = Offset(position.horizontal.offset, position.vertical.offset);
    Offset newOffset = _physics.parseScrolledOffset(currentOffset, delta);

    position.horizontal.offset = newOffset.dx;
    position.vertical.offset = newOffset.dy;
  }

  void scrollTo(Offset offset) {
    position.horizontal.offset = offset.dx;
    position.vertical.offset = offset.dy;
  }

  void scrollToVertical(double offset) {
    position.vertical.offset = offset < 0 ? 0 : offset;
  }

  void scrollToHorizontal(double offset) {
    position.horizontal.offset = offset < 0 ? 0 : offset;
  }

  void setViewportSize(Size size) {
    metrics.update(
      horizontal: metrics.horizontal.copyWith(viewportDimension: size.width - rowHeadersWidth),
      vertical: metrics.vertical.copyWith(viewportDimension: size.height - columnHeadersHeight),
    );
  }

  Offset get offset => Offset(position.horizontal.offset, position.vertical.offset);
}

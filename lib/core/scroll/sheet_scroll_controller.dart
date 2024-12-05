import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_scroll_physics.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/utils/directional_values.dart';

class SheetScrollController {
  SheetScrollController({
    SheetScrollPhysics? physics,
  }) {
    position = DirectionalValues<SheetScrollPosition>(
      vertical: SheetScrollPosition.zero(),
      horizontal: SheetScrollPosition.zero(),
    );

    metrics = DirectionalValues<SheetScrollMetrics>(
      vertical: SheetScrollMetrics.zero(SheetAxisDirection.vertical),
      horizontal: SheetScrollMetrics.zero(SheetAxisDirection.horizontal),
    );

    _physics = (physics ?? SmoothScrollPhysics())..applyTo(this);
  }

  late final SheetScrollPhysics _physics;
  late DirectionalValues<SheetScrollPosition> position;
  late DirectionalValues<SheetScrollMetrics> metrics;

  void setViewportSize(Size size) {
    metrics = DirectionalValues<SheetScrollMetrics>(
      horizontal: metrics.horizontal.copyWith(viewportDimension: size.width - rowHeadersWidth),
      vertical: metrics.vertical.copyWith(viewportDimension: size.height - columnHeadersHeight),
    );
  }

  void setContentSize(Size size) {
    metrics = DirectionalValues<SheetScrollMetrics>(
      horizontal: metrics.horizontal.copyWith(contentSize: size.width),
      vertical: metrics.vertical.copyWith(contentSize: size.height),
    );
  }

  void scrollBy(Offset delta) {
    Offset currentOffset = Offset(position.horizontal.offset, position.vertical.offset);
    Offset newOffset = _physics.parseScrolledOffset(currentOffset, delta);

    position.horizontal.offset = newOffset.dx;
    position.vertical.offset = newOffset.dy;
  }

  void scrollTo(Offset offset) {
    position.horizontal.offset = offset.dx < 0 ? 0 : offset.dx;
    position.vertical.offset = offset.dy < 0 ? 0 : offset.dy;
  }

  void scrollToVertical(double offset) {
    position.vertical.offset = offset < 0 ? 0 : offset;
  }

  void scrollToHorizontal(double offset) {
    position.horizontal.offset = offset < 0 ? 0 : offset;
  }

  Offset get offset => Offset(position.horizontal.offset, position.vertical.offset);
}

import 'package:flutter/cupertino.dart';
import 'package:sheets/core/scroll/sheet_scroll_physics.dart';
import 'package:sheets/utils/directional_values.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';

class SheetScrollController extends ChangeNotifier {
  SheetScrollController({
    SheetScrollPhysics? physics,
}) {
    position = DirectionalValues<SheetScrollPosition>(
      SheetScrollPosition(),
      SheetScrollPosition(),
    )..addListener(notifyListeners);

    metrics = DirectionalValues<SheetScrollMetrics>(
      SheetScrollMetrics.zero(SheetAxisDirection.vertical),
      SheetScrollMetrics.zero(SheetAxisDirection.horizontal),
    )..addListener(notifyListeners);

    _physics = (physics ?? SmoothScrollPhysics())..applyTo(this);

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

  void scrollBy(Offset delta) {
    Offset currentOffset = Offset(position.horizontal.offset, position.vertical.offset);
    Offset newOffset = _physics.parseScrolledOffset(currentOffset, delta);

    position.horizontal.offset = newOffset.dx;
    position.vertical.offset = newOffset.dy;
  }

  void setViewportSize(Size size) {
    metrics.update(
      horizontal: metrics.horizontal.copyWith(viewportDimension: size.width),
      vertical: metrics.vertical.copyWith(viewportDimension: size.height),
    );
  }
}

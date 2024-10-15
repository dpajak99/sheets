import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/scroll/sheet_scroll_physics.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/utils/directional_values.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';

class SheetScrollController extends ChangeNotifier {
  final SheetScrollPhysics physics = SmoothScrollPhysics();

  final DirectionalValues<SheetScrollPosition> position = DirectionalValues<SheetScrollPosition>(
    SheetScrollPosition(),
    SheetScrollPosition(),
  );

  late final DirectionalValues<SheetScrollMetrics> metrics = DirectionalValues<SheetScrollMetrics>(
    SheetScrollMetrics.zero(SheetAxisDirection.vertical),
    SheetScrollMetrics.zero(SheetAxisDirection.horizontal),
  );

  late final SheetProperties properties;

  SheetScrollController() {
    physics.applyTo(this);
    metrics.addListener(notifyListeners);
    position.addListener(notifyListeners);
  }

  void applyTo(SheetController sheetController) {
    properties = sheetController.sheetProperties;
    properties.addListener(_handlePropertiesUpdated);
    _handlePropertiesUpdated();
  }

  void setViewportSize(Size size) {
    metrics.update(
      horizontal: metrics.horizontal.copyWith(viewportDimension: size.width),
      vertical: metrics.vertical.copyWith(viewportDimension: size.height),
    );
  }

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
    Offset newOffset = physics.parseScrolledOffset(currentOffset, delta);

    position.horizontal.offset = newOffset.dx;
    position.vertical.offset = newOffset.dy;
  }

  void _handlePropertiesUpdated() {
    _customRowExtents = properties.customRowExtents;
    _customColumnExtents = properties.customColumnExtents;
  }

  set _customRowExtents(Map<int, double> customRowExtents) {
    double contentHeight = 0;
    for (int i = 0; i < properties.rowCount; i++) {
      double rowHeight = customRowExtents[i] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }

    metrics.vertical = metrics.vertical.copyWith(contentSize: contentHeight);
  }

  set _customColumnExtents(Map<int, double> customColumnExtents) {
    double contentWidth = 0;
    for (int i = 0; i < properties.columnCount; i++) {
      double columnWidth = customColumnExtents[i] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }

    metrics.horizontal = metrics.horizontal.copyWith(contentSize: contentWidth);
  }
}

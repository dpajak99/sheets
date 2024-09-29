import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/sheet_scroll_physics.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/sheet_scroll_metrics.dart';

class SheetScrollPosition extends ChangeNotifier with EquatableMixin {
  SheetScrollPosition();

  SheetScrollPosition.zero();

  double _offset = 0;

  double get offset => _offset;

  set offset(double offset) {
    if (_offset == offset) return;
    _offset = offset;
    notifyListeners();
  }

  @override
  List<Object?> get props => [_offset];
}

class DirectionalValues<A extends Object> extends ChangeNotifier with EquatableMixin {
  DirectionalValues(this._vertical, this._horizontal) {
    print('Set horizontal: $_horizontal');
    if (_vertical is Listenable) {
      (_vertical as Listenable).addListener(notifyListeners);
      (_horizontal as Listenable).addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    if (_vertical is Listenable) {
      (_vertical as Listenable).removeListener(notifyListeners);
      (_horizontal as Listenable).removeListener(notifyListeners);
    }
    super.dispose();
  }

  A _vertical;

  A get vertical => _vertical;

  set vertical(A vertical) {
    if (_vertical == vertical) return;
    _vertical = vertical;
    notifyListeners();
  }

  A _horizontal;

  A get horizontal {
    return _horizontal;
  }

  set horizontal(A horizontal) {
    if (_horizontal == horizontal) return;
    _horizontal = horizontal;


    notifyListeners();
  }

  void update({required A horizontal, required A vertical}) {
    if (_horizontal == horizontal && _vertical == vertical) return;
    _horizontal = horizontal;
    _vertical = vertical;
    notifyListeners();
  }

  @override
  List<Object?> get props => [_vertical, _horizontal];
}

class SheetScrollController extends ChangeNotifier {
  final SheetScrollPhysics physics = SmoothScrollPhysics();

  final DirectionalValues<SheetScrollPosition> position = DirectionalValues(
    SheetScrollPosition(),
    SheetScrollPosition(),
  );

  late final DirectionalValues<SheetScrollMetrics> metrics = DirectionalValues(
    SheetScrollMetrics.zero(SheetAxisDirection.vertical),
    SheetScrollMetrics.zero(SheetAxisDirection.horizontal),
  );

  SheetScrollController() {
    physics.applyTo(this);
    metrics.addListener(notifyListeners);
    position.addListener(notifyListeners);
  }

  @override
  void dispose() {
    metrics.dispose();
    position.dispose();
    super.dispose();
  }

  void scrollBy(Offset delta) {
    Offset currentOffset = Offset(position.horizontal.offset, position.vertical.offset);
    Offset newOffset = physics.parseScrolledOffset(currentOffset, delta);

    position.horizontal.offset = newOffset.dx;
    position.vertical.offset = newOffset.dy;
  }

  set viewportSize(Size size) {
    metrics.update(
      horizontal: metrics.horizontal.copyWith(viewportDimension: size.width),
      vertical: metrics.vertical.copyWith(viewportDimension: size.height),
    );
  }

  set customRowExtents(Map<int, double> customRowExtents) {
    double contentHeight = 0;
    for (int i = 0; i < defaultRowCount; i++) {
      double rowHeight = customRowExtents[i] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }

    metrics.vertical = metrics.vertical.copyWith(contentSize: contentHeight);
  }

  set customColumnExtents(Map<int, double> customColumnExtents) {
    double contentWidth = 0;
    for (int i = 0; i < defaultColumnCount; i++) {
      double columnWidth = customColumnExtents[i] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }

    metrics.horizontal = metrics.horizontal.copyWith(contentSize: contentWidth);
  }
}

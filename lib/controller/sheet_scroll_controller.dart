import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sheets/controller/index.dart';
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
    print('Set horizontal: $horizontal');
    if (_horizontal == horizontal) return;
    _horizontal = horizontal;


    notifyListeners();
  }

  void update({required A horizontal, required A vertical}) {
    print('Set horizontal 2: $horizontal');
    if (_horizontal == horizontal && _vertical == vertical) return;
    _horizontal = horizontal;
    _vertical = vertical;
    notifyListeners();
  }

  @override
  List<Object?> get props => [_vertical, _horizontal];
}

class SheetScrollController {
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

  Map<int, double> _customRowExtents = <int, double>{};

  set customRowExtents(Map<int, double> customRowExtents) {
    _customRowExtents = customRowExtents;

    double contentHeight = 0;
    for (int i = 0; i < defaultRowCount; i++) {
      double rowHeight = customRowExtents[i] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }

    metrics.vertical = metrics.vertical.copyWith(contentSize: contentHeight);
  }

  Map<int, double> _customColumnExtents = <int, double>{};

  set customColumnExtents(Map<int, double> customColumnExtents) {
    _customColumnExtents = customColumnExtents;

    double contentWidth = 0;
    for (int i = 0; i < defaultColumnCount; i++) {
      double columnWidth = customColumnExtents[i] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }

    metrics.horizontal = metrics.horizontal.copyWith(contentSize: contentWidth);
  }

  (RowIndex, double) get firstVisibleRow {
    double contentHeight = 0;
    int hiddenRows = 0;

    while (contentHeight < position.vertical.offset) {
      hiddenRows++;
      double rowHeight = _customRowExtents[hiddenRows] ?? defaultRowHeight;
      contentHeight += rowHeight;
    }

    double rowHeight = _customRowExtents[hiddenRows] ?? defaultRowHeight;
    double verticalOverscroll = position.vertical.offset - contentHeight;
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

    while (contentWidth < position.horizontal.offset) {
      hiddenColumns++;
      double columnWidth = _customColumnExtents[hiddenColumns] ?? defaultColumnWidth;
      contentWidth += columnWidth;
    }

    double columnWidth = _customColumnExtents[hiddenColumns] ?? defaultColumnWidth;
    double horizontalOverscroll = position.horizontal.offset - contentWidth;

    if (horizontalOverscroll != 0) {
      double hiddenWidth = ((-columnWidth) - horizontalOverscroll);
      return (ColumnIndex(hiddenColumns), hiddenWidth);
    } else {
      return (ColumnIndex(hiddenColumns), 0);
    }
  }
}

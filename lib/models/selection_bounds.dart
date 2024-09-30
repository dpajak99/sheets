import 'package:flutter/material.dart';
import 'package:sheets/models/selection_corners.dart';
import 'package:sheets/models/selection_direction.dart';
import 'package:sheets/models/sheet_item_config.dart';
import 'package:sheets/utils/direction.dart';

class SelectionBounds {
  final SelectionCorners<Rect> _corners;
  final CellConfig startCell;
  final bool _startCellVisible;
  final List<Direction> _hiddenBorders;

  SelectionBounds._({
    required SelectionCorners<Rect> corners,
    required this.startCell,
    required bool startCellVisible,
    required List<Direction> hiddenBorders,
  })  : _corners = corners,
        _startCellVisible = startCellVisible,
        _hiddenBorders = hiddenBorders;

  factory SelectionBounds(
    CellConfig startCell,
    CellConfig endCell,
    SelectionDirection direction, {
    List<Direction>? hiddenBorders,
    bool startCellVisible = true,
    bool lastCellVisible = true,
  }) {
    SelectionCorners<Rect> corners = SelectionCorners<Rect>.fromDirection(
      topLeft: startCell.rect,
      bottomRight: endCell.rect,
      topRight: Rect.fromPoints(
        Offset(endCell.rect.left, startCell.rect.top),
        Offset(endCell.rect.right, startCell.rect.bottom),
      ),
      bottomLeft: Rect.fromPoints(
        Offset(startCell.rect.left, endCell.rect.top),
        Offset(startCell.rect.right, endCell.rect.bottom),
      ),
      direction: direction,
    );

    return SelectionBounds._(
      corners: corners,
      startCell: startCell,
      startCellVisible: startCellVisible,
      hiddenBorders: hiddenBorders ?? [],
    );
  }

  bool get isStartCellVisible => _startCellVisible;

  Rect get mainCellRect => startCell.rect;

  Rect get selectionRect {
    return Rect.fromPoints(_corners.topLeft.topLeft, _corners.bottomRight.bottomRight);
  }

  bool get isLeftBorderVisible => !_hiddenBorders.contains(Direction.left);

  bool get isTopBorderVisible => !_hiddenBorders.contains(Direction.top);

  bool get isRightBorderVisible => !_hiddenBorders.contains(Direction.right);

  bool get isBottomBorderVisible => !_hiddenBorders.contains(Direction.bottom);
}

import 'package:flutter/material.dart';
import 'package:sheets/core/selection/selection_direction.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/direction.dart';
import 'package:sheets/utils/edge_visibility.dart';

class SelectionRect extends BorderRect {
  factory SelectionRect(
    Rect startRect,
    Rect endRect,
    SelectionDirection direction, {
    List<Direction>? hiddenBorders,
  }) {
    return SelectionRect.fromLTRB(
      rect: switch (direction) {
        SelectionDirection.bottomRight => Rect.fromLTRB(startRect.left, startRect.top, endRect.right, endRect.bottom),
        SelectionDirection.bottomLeft => Rect.fromLTRB(endRect.left, startRect.top, startRect.right, endRect.bottom),
        SelectionDirection.topRight => Rect.fromLTRB(startRect.left, endRect.top, endRect.right, startRect.bottom),
        SelectionDirection.topLeft => Rect.fromLTRB(endRect.left, endRect.top, startRect.right, startRect.bottom),
      },
      hiddenBorders: hiddenBorders ?? <Direction>[],
    );
  }

  SelectionRect.fromLTRB({
    required Rect rect,
    required List<Direction> hiddenBorders,
  })  : _hiddenBorders = hiddenBorders,
        super.fromLTRB(rect.left, rect.top, rect.right, rect.bottom);

  final List<Direction> _hiddenBorders;

  bool get isLeftBorderVisible => !_hiddenBorders.contains(Direction.left);

  bool get isTopBorderVisible => !_hiddenBorders.contains(Direction.top);

  bool get isRightBorderVisible => !_hiddenBorders.contains(Direction.right);

  bool get isBottomBorderVisible => !_hiddenBorders.contains(Direction.bottom);

  EdgeVisibility get edgeVisibility => EdgeVisibility(
        top: isTopBorderVisible,
        right: isRightBorderVisible,
        bottom: isBottomBorderVisible,
        left: isLeftBorderVisible,
      );
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class MouseCursorDetails with EquatableMixin {
  MouseCursorDetails({
    required this.localOffset,
    required this.scrollPosition,
    required this.hoveredItem,
  });

  final Offset localOffset;
  final Offset scrollPosition;
  final ViewportItem? hoveredItem;

  @override
  List<Object?> get props => <Object?>[localOffset, scrollPosition, hoveredItem];
}

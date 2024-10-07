import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/sheet_item_config.dart';

class SheetTapDetails with EquatableMixin {
  final DateTime tapTime;
  final Offset mousePosition;
  final SheetItemConfig? hoveredItem;

  SheetTapDetails({
    required this.tapTime,
    required this.mousePosition,
    required this.hoveredItem,
  });

  SheetTapDetails.create(Offset mousePosition, [SheetItemConfig? hoveredItem])
      : this(
          tapTime: DateTime.now(),
          mousePosition: mousePosition,
          hoveredItem: hoveredItem,
        );

  bool isDoubleTap(SheetTapDetails other) {
    return tapTime.difference(other.tapTime) < const Duration(milliseconds: 300) && hoveredItem == other.hoveredItem;
  }

  @override
  List<Object?> get props => [tapTime, mousePosition, hoveredItem];
}

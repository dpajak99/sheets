import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_item_config.dart';

abstract class SheetDragGesture extends SheetGesture {
  final SheetDragDetails endDetails;

  SheetDragGesture(this.endDetails);

  @override
  List<Object?> get props => [endDetails];
}

class SheetDragStartGesture extends SheetDragGesture {
  SheetDragStartGesture(super.endDetails);
}

class SheetDragUpdateGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetDragUpdateGesture(super.endDetails, {required this.startDetails});
  
  @override
  List<Object?> get props => [endDetails, startDetails];
}

class SheetDragEndGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetDragEndGesture(super.endDetails, {required this.startDetails});
  
  @override
  List<Object?> get props => [endDetails, startDetails];
}

class SheetDragDetails with EquatableMixin {
  final Offset mousePosition;
  final SheetItemConfig? hoveredItem;

  SheetDragDetails({
    required this.mousePosition,
    required this.hoveredItem,
  });

  SheetDragDetails.create(Offset mousePosition, [SheetItemConfig? hoveredItem])
      : this(
    mousePosition: mousePosition,
    hoveredItem: hoveredItem,
  );

  @override
  List<Object?> get props => [mousePosition, hoveredItem];
}
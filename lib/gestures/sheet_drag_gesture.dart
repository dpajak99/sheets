import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/viewport/viewport_item.dart';

abstract class SheetDragGesture extends SheetGesture {

  @override
  List<Object?> get props => [];
}

class SheetDragStartGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetDragStartGesture(this.startDetails);

  @override
  void resolve(SheetController controller) {}

  @override
  List<Object?> get props => [startDetails];
}

class SheetDragUpdateGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;
  final SheetDragDetails endDetails;

  SheetDragUpdateGesture(this.endDetails, {required this.startDetails});

  @override
  void resolve(SheetController controller) {
  }

  @override
  List<Object?> get props => [endDetails, startDetails];
}

class SheetDragEndGesture extends SheetDragGesture {

  @override
  void resolve(SheetController controller) {
  }

  @override
  List<Object?> get props => [];
}

class SheetDragDetails with EquatableMixin {
  final Offset mousePosition;
  final ViewportItem? hoveredItem;

  SheetDragDetails({
    required this.mousePosition,
    required this.hoveredItem,
  });

  SheetIndex get hoveredItemIndex => hoveredItem!.index;

  SheetDragDetails.create(Offset mousePosition, [ViewportItem? hoveredItem])
      : this(
          mousePosition: mousePosition,
          hoveredItem: hoveredItem,
        );

  @override
  List<Object?> get props => [mousePosition, hoveredItem];
}


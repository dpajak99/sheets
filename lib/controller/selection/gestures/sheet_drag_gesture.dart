import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/gestures/sheet_gesture.dart';

abstract class SheetDragGesture extends SheetGesture {
  final SheetDragDetails details;

  SheetDragGesture(this.details);

  @override
  List<Object?> get props => [details];
}

class SheetDragStartGesture extends SheetDragGesture {
  SheetDragStartGesture(super.details);
}

class SheetDragUpdateGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetDragUpdateGesture(super.details, {required this.startDetails});
}

class SheetFillUpdateGesture extends SheetDragGesture {

  SheetFillUpdateGesture(super.details);
}

class SheetDragEndGesture extends SheetDragGesture {
  final SheetDragDetails startDetails;

  SheetDragEndGesture(super.details, {required this.startDetails});
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
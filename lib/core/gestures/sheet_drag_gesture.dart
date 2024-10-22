import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/mouse/mouse_cursor_details.dart';

abstract class SheetMouseGesture extends SheetGesture {
  Offset get startOffset;
  Offset get currentOffset;

  @override
  void resolve(SheetController controller) {}

  @override
  List<Object?> get props => <Object?>[];
}

class SheetMouseHoverGesture extends SheetMouseGesture {
  final Offset localOffset;

  SheetMouseHoverGesture(this.localOffset);

  @override
  Offset get startOffset => localOffset;

  @override
  Offset get currentOffset => localOffset;
}

class SheetDragStartGesture extends SheetMouseGesture {
  final MouseCursorDetails startDetails;

  SheetDragStartGesture(this.startDetails);

  @override
  Offset get startOffset => startDetails.localOffset;

  @override
  Offset get currentOffset => startDetails.localOffset;

  @override
  List<Object?> get props => <Object?>[startDetails];
}

class SheetDragUpdateGesture extends SheetMouseGesture {
  final MouseCursorDetails startDetails;
  final MouseCursorDetails updateDetails;

  SheetDragUpdateGesture({ required this.startDetails, required this.updateDetails});

  @override
  Offset get startOffset => startDetails.localOffset;

  @override
  Offset get currentOffset => updateDetails.localOffset;

  @override
  List<Object?> get props => <Object?>[updateDetails, startDetails];
}

class SheetDragEndGesture extends SheetMouseGesture {
  final MouseCursorDetails startDetails;
  final MouseCursorDetails endDetails;
  
  SheetDragEndGesture({ required this.startDetails, required this.endDetails});
  
  @override
  Offset get startOffset => startDetails.localOffset;

  @override
  Offset get currentOffset => endDetails.localOffset;

  @override
  List<Object?> get props => <Object?>[];
}


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/mouse/mouse_cursor_details.dart';
import 'package:sheets/core/sheet_controller.dart';

abstract class SheetMouseGesture with EquatableMixin {
  Offset get startOffset;

  Offset get currentOffset;

  void resolve(SheetController controller) {}

  @override
  List<Object?> get props => <Object?>[];
}

class SheetMouseHoverGesture extends SheetMouseGesture {
  SheetMouseHoverGesture(this.localOffset);

  final Offset localOffset;

  @override
  Offset get startOffset => localOffset;

  @override
  Offset get currentOffset => localOffset;
}

class SheetDragStartGesture extends SheetMouseGesture {
  SheetDragStartGesture(this.startDetails);

  final MouseCursorDetails startDetails;

  @override
  Offset get startOffset => startDetails.localOffset;

  @override
  Offset get currentOffset => startDetails.localOffset;

  @override
  List<Object?> get props => <Object?>[startDetails];
}

class SheetDragUpdateGesture extends SheetMouseGesture {
  SheetDragUpdateGesture({required this.startDetails, required this.updateDetails});

  final MouseCursorDetails startDetails;
  final MouseCursorDetails updateDetails;

  @override
  Offset get startOffset => startDetails.localOffset;

  @override
  Offset get currentOffset => updateDetails.localOffset;

  @override
  List<Object?> get props => <Object?>[updateDetails, startDetails];
}

class SheetDragEndGesture extends SheetMouseGesture {
  SheetDragEndGesture({required this.startDetails, required this.endDetails});

  final MouseCursorDetails startDetails;
  final MouseCursorDetails endDetails;

  @override
  Offset get startOffset => startDetails.localOffset;

  @override
  Offset get currentOffset => endDetails.localOffset;

  @override
  List<Object?> get props => <Object?>[];
}

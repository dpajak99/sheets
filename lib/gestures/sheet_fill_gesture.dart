import 'package:sheets/behaviors/selection_behaviors.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';

abstract class SheetFillGesture extends SheetGesture {}

class SheetFillStartGesture extends SheetFillGesture {
  @override
  void resolve(SheetController controller) {}

  @override
  List<Object?> get props => [];
}

class SheetFillUpdateGesture extends SheetFillGesture {
  final SheetDragDetails endDetails;

  SheetFillUpdateGesture({required this.endDetails});

  @override
  void resolve(SheetController controller) {
    if (endDetails.hoveredItem == null) return;
    SelectionFillBehavior(endDetails.hoveredItem!.index).invoke(controller);
  }

  @override
  List<Object?> get props => [endDetails];
}

class SheetFillEndGesture extends SheetFillGesture {
  @override
  void resolve(SheetController controller) {
    controller.selectionController.completeSelection();
  }

  @override
  List<Object?> get props => [];
}

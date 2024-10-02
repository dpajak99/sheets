import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/recognizers/selection_fill_recognizer.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

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

    SheetSelection sheetSelection = (controller.selection is SheetFillSelection)
        ? (controller.selection as SheetFillSelection).baseSelection
        : controller.selection;
    SelectionFillRecognizer.from(sheetSelection, controller).handle(endDetails.hoveredItem!);
  }

  @override
  List<Object?> get props => [endDetails];
}

class SheetFillEndGesture extends SheetFillGesture {
  @override
  void resolve(SheetController controller) {
    controller.completeSelection();
  }

  @override
  List<Object?> get props => [];
}

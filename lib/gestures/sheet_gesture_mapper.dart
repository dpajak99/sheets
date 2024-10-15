import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/gestures/sheet_selection_gesture.dart';

abstract class SheetGestureMapper {
  SheetGesture convert(SheetGesture gesture);
}

class SheetMouseGestureMapper implements SheetGestureMapper {
  @override
  SheetGesture convert(SheetGesture gesture) {
    return switch (gesture) {
      SheetDragStartGesture gesture => SheetSelectionStartGesture.from(gesture),
      SheetDragUpdateGesture gesture => SheetSelectionUpdateGesture.from(gesture),
      SheetDragEndGesture _ => SheetSelectionEndGesture(),
      _ => gesture,
    };
  }
}

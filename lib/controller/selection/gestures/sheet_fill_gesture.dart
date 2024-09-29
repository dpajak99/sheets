import 'package:sheets/controller/selection/gestures/sheet_drag_gesture.dart';
import 'package:sheets/controller/selection/gestures/sheet_gesture.dart';

abstract class SheetFillGesture extends SheetGesture {}

class SheetFillStartGesture extends SheetFillGesture {
  @override
  List<Object?> get props => [];
}

class SheetFillUpdateGesture extends SheetFillGesture {
  final SheetDragDetails endDetails;

  SheetFillUpdateGesture({required this.endDetails});

  @override
  List<Object?> get props => [endDetails];
}

class SheetFillEndGesture extends SheetFillGesture {
  @override
  List<Object?> get props => [];
}
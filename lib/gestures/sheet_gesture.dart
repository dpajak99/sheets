import 'package:equatable/equatable.dart';
import 'package:sheets/controller/sheet_controller.dart';

abstract class SheetGesture with EquatableMixin {
  void resolve(SheetController controller);
}

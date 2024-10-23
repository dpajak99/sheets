import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_controller.dart';

abstract class SheetGesture with EquatableMixin {
  void resolve(SheetController controller);

  Duration? get lockdownDuration => null;
}

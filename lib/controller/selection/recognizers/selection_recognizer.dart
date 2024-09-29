import 'package:sheets/controller/program_config.dart';

abstract class SelectionRecognizer {
  void handle(SheetItemConfig selectionEnd);

  void complete();
}
import 'package:sheets/core/selection/sheet_selection.dart';

extension SelectionListExtensions on List<SheetSelection> {
  List<SheetSelection> complete() {
    return map((SheetSelection selection) => selection.complete()).toList();
  }
}
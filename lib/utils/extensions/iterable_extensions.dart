import 'package:sheets/selection/sheet_selection.dart';

extension IterableExtensions<E> on Iterable<E> {
  List<E> whereNotNull() {
    return where((element) => element != null).toList();
  }
}

extension SheetSelectionList on List<SheetSelection> {
  List<SheetSelection> complete() {
    return map((selection) => selection.complete()).toList();
  }
}
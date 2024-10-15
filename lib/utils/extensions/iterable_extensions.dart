import 'package:sheets/selection/sheet_selection.dart';

extension IterableExtensions<E> on Iterable<E> {
  List<E> whereNotNull() {
    return where((E element) => element != null).toList();
  }
}

extension SheetSelectionList on List<SheetSelection> {
  List<SheetSelection> complete() {
    return map((SheetSelection selection) => selection.complete()).toList();
  }
}
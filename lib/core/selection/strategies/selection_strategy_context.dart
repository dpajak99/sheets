import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/selection_strategy.dart';
import 'package:sheets/core/sheet_index.dart';

class SelectionBuilder {
  final SheetSelection _previousSelection;
  late SelectionStrategy _selectionStrategy;

  SelectionBuilder(
    SheetSelection previousSelection,
  ) : _previousSelection = previousSelection;

  void setStrategy(SelectionStrategy selectionStrategy) {
    _selectionStrategy = selectionStrategy;
  }

  SheetSelection build(SheetIndex selectedIndex) {
    return _selectionStrategy.execute(_previousSelection, selectedIndex);
  }
}

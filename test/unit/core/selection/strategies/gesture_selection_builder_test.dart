import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';

void main() {
  test('Should [set the selection strategy] and [build a selection] accordingly', () {
    // Arrange
    SheetSelection previousSelection = SheetSelectionFactory.single(CellIndex.raw(1, 1));
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);
    CellIndex selectedIndex = CellIndex.raw(2, 2);

    // Act
    selectionBuilder.setStrategy(MockGestureSelectionStrategy());
    SheetSelection actualSelection = selectionBuilder.build(selectedIndex);

    // Assert
    SheetSelection expectedSelection = SheetSingleSelection(selectedIndex);

    expect(actualSelection, equals(expectedSelection));
  });
}

class MockGestureSelectionStrategy implements GestureSelectionStrategy {
  @override
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex) {
    return SheetSelectionFactory.single(selectedIndex);
  }
}
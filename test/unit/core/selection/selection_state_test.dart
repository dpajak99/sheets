import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';

void main() {
  group('Tests of SelectionState.update()', () {
    test('Should [update selection] when new selection is different', () {
      // Arrange
      SelectionState selectionState = SelectionState.defaultSelection();
      SheetSelection newSelection = SheetSingleSelection(CellIndex.raw(4, 4));

      // Act
      selectionState.update(newSelection);

      // Assert
      expect(selectionState.value, newSelection);
    });

    test('Should [not update selection] when new selection is the same', () {
      // Arrange
      SelectionState selectionState = SelectionState.defaultSelection();
      SheetSelection newSelection = SheetSingleSelection.defaultSelection();

      // Act
      selectionState.update(newSelection);

      // Assert
      expect(selectionState.value, newSelection);
    });
  });

  group('Tests of SelectionState.complete()', () {
    test('Should [complete selection] when selection is not complete', () {
      // Arrange
      SheetSelection previousSelection = SheetSingleSelection(CellIndex.raw(4, 4));
      SelectionState selectionState = SelectionState(previousSelection);

      // Act
      selectionState.complete();

      // Assert
      expect(selectionState.value, previousSelection.copyWith(completed: true));
    });

    test('Should [not complete selection] when selection is already complete', () {
      // Arrange
      SheetSelection previousSelection = SheetSingleSelection(CellIndex.raw(4, 4));
      SelectionState selectionState = SelectionState(previousSelection);

      // Act
      selectionState.complete();

      // Assert
      expect(selectionState.value, previousSelection);
    });
  });

  group('Tests of SelectionState.stringify()', () {
    test('Should [stringify actual selection]', () {
      // Arrange
      SheetSelection selection = SheetSingleSelection(CellIndex.raw(4, 4));
      SelectionState selectionState = SelectionState(selection);

      // Act
      String actualString = selectionState.stringify();

      // Assert
      String expectedString = 'E5';
      expect(actualString, expectedString);
    });
  });
}

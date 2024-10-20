import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';

void main() {
  group('GestureSelectionStrategySingle.execute()', () {
    test('Should [create a SheetSingleSelection] from a given CellIndex', () {
      // Arrange
      SheetSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategySingle();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(2, 2));

      // Assert
      SheetSelection expectedSelection = SheetSingleSelection(CellIndex.raw(2, 2));

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [create a SheetSingleSelection] from a given RowIndex', () {
      // Arrange
      SheetSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategySingle();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, RowIndex(2));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<RowIndex>.single(RowIndex(2), completed: false);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [create a SheetSingleSelection] from a given ColumnIndex', () {
      // Arrange
      SheetSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategySingle();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, ColumnIndex(2));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(2), completed: false);

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('GestureSelectionStrategyAppend.execute()', () {
    test('Should [return previous selection] if selection is identical', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(1, 1));

      // Assert
      expect(actualSelection, equals(previousSelection));
    });

    test('Should [append a CellIndex] to the existing SheetSingleSelection', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(2, 2));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a RowIndex] to the existing SheetSingleSelection', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, RowIndex(2));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetRangeSelection<RowIndex>.single(RowIndex(2), completed: false),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a ColumnIndex] to the existing SheetSingleSelection', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, ColumnIndex(2));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetRangeSelection<ColumnIndex>.single(ColumnIndex(2), completed: false),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a CellIndex] to the existing SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection previousSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
      ]);
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(3, 3));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
        SheetSingleSelection(CellIndex.raw(3, 3)),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a RowIndex] to the existing SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection previousSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
      ]);
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, RowIndex(3));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
        SheetRangeSelection<RowIndex>.single(RowIndex(3), completed: false),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a ColumnIndex] to the existing SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection previousSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
      ]);
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, ColumnIndex(3));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
        SheetRangeSelection<ColumnIndex>.single(ColumnIndex(3), completed: false),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a CellIndex] to the existing SheetRangeSelection', () {
      // Arrange
      SheetRangeSelection<CellIndex> previousSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
      );
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(4, 4));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetRangeSelection<CellIndex>(
          CellIndex.raw(1, 1),
          CellIndex.raw(3, 3),
        ),
        SheetSingleSelection(CellIndex.raw(4, 4)),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a RowIndex] to the existing SheetRangeSelection', () {
      // Arrange
      SheetRangeSelection<RowIndex> previousSelection = SheetRangeSelection<RowIndex>.single(RowIndex(1), completed: false);
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, RowIndex(2));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetRangeSelection<RowIndex>.single(RowIndex(1), completed: false),
        SheetRangeSelection<RowIndex>.single(RowIndex(2), completed: false),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [append a ColumnIndex] to the existing SheetRangeSelection', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> previousSelection =
          SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1), completed: false);
      GestureSelectionStrategy strategy = GestureSelectionStrategyAppend();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, ColumnIndex(2));

      // Assert
      SheetSelection expectedSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1), completed: false),
        SheetRangeSelection<ColumnIndex>.single(ColumnIndex(2), completed: false),
      ]);

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('GestureSelectionStrategyRange.execute()', () {
    test('Should [return SheetRangeSelection] for CellIndex', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyRange();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(3, 3));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] for RowIndex', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyRange();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, RowIndex(3));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 0),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] for ColumnIndex', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      GestureSelectionStrategy strategy = GestureSelectionStrategyRange();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, ColumnIndex(3));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(0, 3),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] for last selection in SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection previousSelection = SheetMultiSelection(selections: <SheetSelection>[
        SheetSingleSelection(CellIndex.raw(1, 1)),
        SheetSingleSelection(CellIndex.raw(2, 2)),
      ]);
      GestureSelectionStrategy strategy = GestureSelectionStrategyRange();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(3, 3));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(2, 2),
        CellIndex.raw(3, 3),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('GestureSelectionStrategyModify.execute()', () {
    test('Should [modify SheetRangeSelection] for CellIndex', () {
      // Arrange
      SheetRangeSelection<CellIndex> previousSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        completed: false,
      );
      GestureSelectionStrategy strategy = GestureSelectionStrategyModify();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(3, 4));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 4),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [modify SheetRangeSelection] for RowIndex', () {
      // Arrange
      SheetRangeSelection<CellIndex> previousSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        completed: false,
      );
      GestureSelectionStrategy strategy = GestureSelectionStrategyModify();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, RowIndex(3));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 0),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [modify SheetRangeSelection] for ColumnIndex', () {
      // Arrange
      SheetRangeSelection<CellIndex> previousSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        completed: false,
      );
      GestureSelectionStrategy strategy = GestureSelectionStrategyModify();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, ColumnIndex(3));

      // Assert
      SheetSelection expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(0, 3),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('GestureSelectionStrategyFill.execute()', () {
    test('Should [return SheetFillSelection] with Direction.top', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(5, 5));
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(1, 5));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(4, 5),
        CellIndex.raw(1, 5),
        baseSelection: SheetSingleSelection(CellIndex.raw(5, 5)),
        fillDirection: Direction.top,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.bottom', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(5, 5));
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(9, 5));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(9, 5),
        CellIndex.raw(6, 5),
        baseSelection: SheetSingleSelection(CellIndex.raw(5, 5)),
        fillDirection: Direction.bottom,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.left', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(5, 5));
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(5, 1));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(5, 4),
        CellIndex.raw(5, 1),
        baseSelection: SheetSingleSelection(CellIndex.raw(5, 5)),
        fillDirection: Direction.left,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.right', () {
      // Arrange
      SheetSingleSelection previousSelection = SheetSingleSelection(CellIndex.raw(5, 5));
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(5, 9));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(5, 9),
        CellIndex.raw(5, 6),
        baseSelection: SheetSingleSelection(CellIndex.raw(5, 5)),
        fillDirection: Direction.right,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.top (previous selection = RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> previousSelection = SheetRangeSelection<RowIndex>.single(RowIndex(5), completed: false);
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(1, 5));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(4, 0),
        CellIndex.raw(1, Int.max),
        baseSelection: SheetRangeSelection<RowIndex>.single(RowIndex(5), completed: false),
        fillDirection: Direction.top,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.bottom (previous selection = RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> previousSelection = SheetRangeSelection<RowIndex>.single(RowIndex(5), completed: false);
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(9, 5));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(9, 0),
        CellIndex.raw(6, Int.max),
        baseSelection: SheetRangeSelection<RowIndex>.single(RowIndex(5), completed: false),
        fillDirection: Direction.bottom,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.left (previous selection = ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> previousSelection =
          SheetRangeSelection<ColumnIndex>.single(ColumnIndex(5), completed: false);
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(5, 1));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(0, 4),
        CellIndex.raw(Int.max, 1),
        baseSelection: SheetRangeSelection<ColumnIndex>.single(ColumnIndex(5), completed: false),
        fillDirection: Direction.left,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetFillSelection] with Direction.right (previous selection = ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> previousSelection =
          SheetRangeSelection<ColumnIndex>.single(ColumnIndex(5), completed: false);
      GestureSelectionStrategy strategy = GestureSelectionStrategyFill();

      // Act
      SheetSelection actualSelection = strategy.execute(previousSelection, CellIndex.raw(5, 9));

      // Assert
      SheetSelection expectedSelection = SheetFillSelection(
        CellIndex.raw(0, 9),
        CellIndex.raw(Int.max, 6),
        baseSelection: SheetRangeSelection<ColumnIndex>.single(ColumnIndex(5), completed: false),
        fillDirection: Direction.right,
      );

      expect(actualSelection, equals(expectedSelection));
    });
  });
}

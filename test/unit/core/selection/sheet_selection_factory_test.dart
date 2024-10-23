import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of SheetSelectionFactory.single()', () {
    test('Should [return SheetSingleSelection] for CellIndex', () {
      // Act
      SheetSelection actualSelection = SheetSelectionFactory.single(CellIndex.raw(1, 1));

      // Assert
      SheetSelection expectedSheetSelection = SheetSingleSelection(CellIndex.raw(1, 1));

      expect(actualSelection, expectedSheetSelection);
    });

    test('Should [return SheetRangeSelection] for RowIndex', () {
      // Act
      SheetSelection actualSelection = SheetSelectionFactory.single(RowIndex(1));

      // Assert
      SheetSelection expectedSheetSelection = SheetRangeSelection<RowIndex>.single(RowIndex(1), completed: false);

      expect(actualSelection, expectedSheetSelection);
    });

    test('Should [return SheetRangeSelection] for ColumnIndex', () {
      // Act
      SheetSelection actualSelection = SheetSelectionFactory.single(ColumnIndex(1));

      // Assert
      SheetSelection expectedSheetSelection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1), completed: false);

      expect(actualSelection, expectedSheetSelection);
    });

    group('Tests of SheetSelectionFactory.range()', () {
      test('Should [return SheetRangeSelection] for [start CellIndex] and [end CellIndex] and [indexes EQUAL]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(start: CellIndex.raw(1, 1), end: CellIndex.raw(1, 1));

        // Assert
        SheetSelection expectedSheetSelection = SheetSingleSelection(CellIndex.raw(1, 1));

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start CellIndex] and [end CellIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: CellIndex.raw(1, 1),
          end: CellIndex.raw(2, 2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<CellIndex>(
          CellIndex.raw(1, 1),
          CellIndex.raw(2, 2),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start CellIndex] and [end RowIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: CellIndex.raw(1, 1),
          end: RowIndex(2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<CellIndex>(
          CellIndex.raw(1, 1),
          CellIndex.raw(2, 0),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start CellIndex] and [end ColumnIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: CellIndex.raw(1, 1),
          end: ColumnIndex(2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<CellIndex>(
          CellIndex.raw(1, 1),
          CellIndex.raw(0, 2),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start RowIndex] and [end CellIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: RowIndex(1),
          end: CellIndex.raw(2, 2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<RowIndex>(
          RowIndex(1),
          RowIndex(2),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start RowIndex] and [end RowIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: RowIndex(1),
          end: RowIndex(2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<RowIndex>(
          RowIndex(1),
          RowIndex(2),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start RowIndex] and [end ColumnIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: RowIndex(1),
          end: ColumnIndex(2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<RowIndex>(
          RowIndex(1),
          RowIndex(0),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start ColumnIndex] and [end CellIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: ColumnIndex(1),
          end: CellIndex.raw(2, 2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<ColumnIndex>(
          ColumnIndex(1),
          ColumnIndex(2),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start ColumnIndex] and [end RowIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: ColumnIndex(1),
          end: RowIndex(2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<ColumnIndex>(
          ColumnIndex(1),
          ColumnIndex(0),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });

      test('Should [return SheetRangeSelection] for [start ColumnIndex] and [end ColumnIndex]', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.range(
          start: ColumnIndex(1),
          end: ColumnIndex(2),
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<ColumnIndex>(
          ColumnIndex(1),
          ColumnIndex(2),
          completed: false,
        );

        expect(actualSelection, expectedSheetSelection);
      });
    });

    group('Tests of SheetSelectionFactory.multi()', () {
      test('Should [return SheetMultiSelection] with given selections', () {
        // Arrange
        List<SheetSelection> selections = <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<RowIndex>.single(RowIndex(1)),
          SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1)),
        ];

        // Act
        SheetSelection actualSelection = SheetSelectionFactory.multi(selections: selections);

        // Assert
        SheetSelection expectedSheetSelection = SheetMultiSelection(selections: selections);

        expect(actualSelection, expectedSheetSelection);
      });
    });

    group('Tests of SheetSelectionFactory.fill()', () {
      test('Should [return SheetFillSelection] with given parameters', () {
        // Arrange
        CellIndex start = CellIndex.raw(1, 1);
        CellIndex end = CellIndex.raw(2, 2);
        SheetSelection baseSelection = SheetSingleSelection(CellIndex.raw(1, 1));
        Direction fillDirection = Direction.right;

        // Act
        SheetSelection actualSelection = SheetSelectionFactory.fill(
          start,
          end,
          baseSelection: baseSelection,
          fillDirection: fillDirection,
        );

        // Assert
        SheetSelection expectedSheetSelection = SheetFillSelection(
          start,
          end,
          baseSelection: baseSelection,
          fillDirection: fillDirection,
        );

        expect(actualSelection, expectedSheetSelection);
      });
    });

    group('Tests of SheetSelectionFactory.all()', () {
      test('Should [return SheetRangeSelection] for all cells', () {
        // Act
        SheetSelection actualSelection = SheetSelectionFactory.all();

        // Assert
        SheetSelection expectedSheetSelection = SheetRangeSelection<CellIndex>(CellIndex.zero, CellIndex.max);

        expect(actualSelection, expectedSheetSelection);
      });
    });
  });
}

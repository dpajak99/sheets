import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_extensions.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';

// ignore_for_file: avoid_redundant_argument_values
void main() {
  group('Tests of SelectionListExtensions', () {
    group('Tests of SelectionListExtensions.complete()', () {
      test('Should [return List<SheetExtension>] with all SheetSelections completed', () {
        // Arrange
        List<SheetSelection> actualSelections = <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1), completed: false),
          SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(0, 2), completed: false),
          SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(2), completed: false),
          SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(2), completed: false),
          SheetMultiSelection(selections: <SheetSelection>[
            SheetSingleSelection(CellIndex.raw(1, 1), completed: false),
            SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(0, 2), completed: false),
            SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(2), completed: false),
            SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(2), completed: false),
          ]),
        ];

        // Act
        List<SheetSelection> actualCompletedSelections = actualSelections.complete();

        // Assert
        List<SheetSelection> expectedCompletedSelections = <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1), completed: true),
          SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(0, 2), completed: true),
          SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(2), completed: true),
          SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(2), completed: true),
          SheetMultiSelection(selections: <SheetSelection>[
            SheetSingleSelection(CellIndex.raw(1, 1), completed: true),
            SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(0, 2), completed: true),
            SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(2), completed: true),
            SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(2), completed: true),
          ]),
        ];

        expect(actualCompletedSelections, expectedCompletedSelections);
      });
    });
  });
}

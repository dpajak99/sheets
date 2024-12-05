import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';

void main() {
  group('SheetMultiSelection.isCompleted', () {
    test('Should [return TRUE] for SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );

      // Act
      bool actualIsCompleted = selection.isCompleted;

      // Assert
      bool expectedIsCompleted = true;

      expect(actualIsCompleted, equals(expectedIsCompleted));
    });
  });

  group('SheetMultiSelection.rowSelected', () {
    test('Should [return FALSE] for SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<RowIndex>.single(RowIndex(1))
        ],
      );

      // Act
      bool actualRowSelected = selection.rowSelected;

      // Assert
      bool expectedRowSelected = true;

      expect(actualRowSelected, equals(expectedRowSelected));
    });
  });

  group('SheetMultiSelection.columnSelected', () {
    test('Should [return FALSE] for SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1))
        ],
      );

      // Act
      bool actualColumnSelected = selection.columnSelected;

      // Assert
      bool expectedColumnSelected = true;

      expect(actualColumnSelected, equals(expectedColumnSelected));
    });
  });

  group('SheetMultiSelection.mainCell', () {
    test('Should [return CellIndex] representing the main cell of the last selection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );

      // Act
      CellIndex actualMainCell = selection.mainCell;

      // Assert
      CellIndex expectedMainCell = CellIndex.raw(2, 2);

      expect(actualMainCell, equals(expectedMainCell));
    });
  });

  group('SheetMultiSelection.cellCorners', () {
    test('Should [return NULL] for SheetMultiSelection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );

      // Act
      SelectionCellCorners? actualCorners = selection.cellCorners;

      // Assert
      expect(actualCorners, isNull);
    });
  });

  group('SheetMultiSelection.contains()', () {
    test('Should [return TRUE] if any selection contains cell', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      CellIndex cellIndex = CellIndex.raw(2, 2);

      // Act
      bool actualContains = selection.contains(cellIndex);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] if any selection contains row', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      bool actualContainsRow = selection.contains(rowIndex);

      // Assert
      bool expectedContainsRow = true;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return TRUE] if any selection contains column', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      bool actualContainsColumn = selection.contains(columnIndex);

      // Assert
      bool expectedContainsColumn = true;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });

    test('Should [return FALSE] if none selection contains cell', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      CellIndex cellIndex = CellIndex.raw(4, 4);

      // Act
      bool actualContains = selection.contains(cellIndex);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] if none selection contains row', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      RowIndex rowIndex = RowIndex(4);

      // Act
      bool actualContainsRow = selection.contains(rowIndex);

      // Assert
      bool expectedContainsRow = false;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return FALSE] if none selection contains column', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      bool actualContainsColumn = selection.contains(columnIndex);

      // Assert
      bool expectedContainsColumn = false;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });
  });

  group('SheetMultiSelection.containsCell()', () {
    test('Should [return TRUE] if any selection contains cell', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      CellIndex cellIndex = CellIndex.raw(2, 2);

      // Act
      bool actualContains = selection.containsCell(cellIndex);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] if none selection contains cell', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      CellIndex cellIndex = CellIndex.raw(4, 4);

      // Act
      bool actualContains = selection.containsCell(cellIndex);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });
  });

  group('SheetMultiSelection.containsRow()', () {
    test('Should [return TRUE] if any selection contains row', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      bool actualContainsRow = selection.containsRow(rowIndex);

      // Assert
      bool expectedContainsRow = true;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return FALSE] if none selection contains row', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      RowIndex rowIndex = RowIndex(4);

      // Act
      bool actualContainsRow = selection.containsRow(rowIndex);

      // Assert
      bool expectedContainsRow = false;

      expect(actualContainsRow, equals(expectedContainsRow));
    });
  });

  group('SheetMultiSelection.containsColumn()', () {
    test('Should [return TRUE] if any selection contains column', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      bool actualContainsColumn = selection.containsColumn(columnIndex);

      // Assert
      bool expectedContainsColumn = true;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });

    test('Should [return FALSE] if none selection contains column', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      bool actualContainsColumn = selection.containsColumn(columnIndex);

      // Assert
      bool expectedContainsColumn = false;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });
  });

  group('SheetMultiSelection.containsSelection()', () {
    test('Should [return TRUE] if any selection contains nested selection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      SheetSingleSelection nestedSelection = SheetSingleSelection(CellIndex.raw(2, 2));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for none selection contains nested selection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      SheetSingleSelection nonNestedSelection = SheetSingleSelection(CellIndex.raw(4, 4));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });
  });

  group('SheetMultiSelection.isRowSelected()', () {
    test('Should [return SelectionStatus] for all selections (FULLY SELECTED row)', () {
      // Arrange
      RowIndex rowIndex = RowIndex(5);
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
          SheetRangeSelection<RowIndex>.single(rowIndex),
        ],
      );

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for all selection (SELECTED row)', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for all selection (NOT-SELECTED row)', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      RowIndex rowIndex = RowIndex(10);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });
  });

  group('SheetMultiSelection.isColumnSelected()', () {
    test('Should [return SelectionStatus] for all selections (FULLY SELECTED column)', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(5);
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
          SheetRangeSelection<ColumnIndex>.single(columnIndex),
        ],
      );

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for all selections (SELECTED column)', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for all selections (NOT-SELECTED column)', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      ColumnIndex columnIndex = ColumnIndex(10);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });
  });

  group('SheetMultiSelection.complete()', () {
    test('Should [return selection] if selections has only one element', () {
      // Arrange
      SheetSingleSelection singleSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      SheetMultiSelection selection = SheetMultiSelection(selections: <SheetSelection>[singleSelection]);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetSelection expectedSelection = singleSelection.copyWith(completed: true);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetMultiSelection] with added selection if [selections NOT OVERLAP]', () {
      // Arrange
      SheetRangeSelection<CellIndex> rangeSelection = SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3));
      SheetSingleSelection singleSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      SheetMultiSelection selection = SheetMultiSelection(selections: <SheetSelection>[singleSelection, rangeSelection]);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetMultiSelection expectedSelection = SheetMultiSelection(
        selections: <SheetSelection>[
          singleSelection.copyWith(completed: true),
          rangeSelection.copyWith(completed: true),
        ],
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetMultiSelection] with first subtracted selection if [selections NOT OVERLAP]', () {
      // Arrange
      SheetRangeSelection<CellIndex> rangeSelection = SheetRangeSelection<CellIndex>(CellIndex.raw(0, 0), CellIndex.raw(3, 3));
      SheetSingleSelection singleSelection = SheetSingleSelection(CellIndex.raw(1, 1));
      SheetMultiSelection selection = SheetMultiSelection(selections: <SheetSelection>[rangeSelection, singleSelection]);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetMultiSelection expectedSelection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetRangeSelection<CellIndex>(CellIndex.raw(0, 0), CellIndex.raw(0, 3)),
          SheetSingleSelection(CellIndex.raw(1, 0)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(3, 3)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(1, 2), CellIndex.raw(1, 3)),
        ],
      );

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('SheetMultiSelection.subtract()', () {
    test('Should [return List<SheetSelection>] representing all selections subtracted', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(selections: <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 0), CellIndex.raw(3, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 2), CellIndex.raw(1, 3)),
        SheetSingleSelection(CellIndex.raw(1, 1)),
      ]);

      // Act
      List<SheetSelection> actualSelections = selection.subtract(SheetSingleSelection(CellIndex.raw(1, 1)));
      // Assert
      List<SheetSelection> expectedSelections = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 0), CellIndex.raw(0, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(1, 0)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(3, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 2), CellIndex.raw(1, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 2), CellIndex.raw(1, 0)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 2), CellIndex.raw(1, 3)),
      ];

      expect(actualSelections, equals(expectedSelections));
    });
  });

  group('SheetMultiSelection.stringifySelection()', () {
    test('Should [return String] representing last selection', () {
      // Arrange
      SheetMultiSelection selection = SheetMultiSelection(
        selections: <SheetSelection>[
          SheetSingleSelection(CellIndex.raw(1, 1)),
          SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(3, 3)),
        ],
      );
      // Act
      String actualString = selection.stringifySelection();

      // Assert
      String expectedString = 'C3:D4';

      expect(actualString, equals(expectedString));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_direction.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('SheetFillSelection.isCompleted', () {
    test('Should [return FALSE] for SheetFillSelection', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(2, 2),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );

      // Act
      bool actualIsCompleted = selection.isCompleted;

      // Assert
      bool expectedIsCompleted = false;

      expect(actualIsCompleted, equals(expectedIsCompleted));
    });
  });

  group('SheetFillSelection.rowSelected', () {
    test('Should [return FALSE] for SheetFillSelection', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(2, 1),
        CellIndex.raw(5, 5),
        baseSelection: SheetRangeSelection<RowIndex>.single(RowIndex(1)),
        fillDirection: Direction.bottom,
      );

      // Act
      bool actualRowSelected = selection.rowSelected;

      // Assert
      bool expectedRowSelected = false;

      expect(actualRowSelected, equals(expectedRowSelected));
    });
  });

  group('SheetFillSelection.columnSelected', () {
    test('Should [return FALSE] for SheetFillSelection', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(2, 1),
        CellIndex.raw(5, 5),
        baseSelection: SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1)),
        fillDirection: Direction.bottom,
      );

      // Act
      bool actualColumnSelected = selection.columnSelected;

      // Assert
      bool expectedColumnSelected = false;

      expect(actualColumnSelected, equals(expectedColumnSelected));
    });
  });

  group('SheetFillSelection.mainCell', () {
    test('Should [return CellIndex] representing the main cell (CellIndex range)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 2);
      CellIndex endIndex = CellIndex.raw(1, 4);

      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );

      // Act
      CellIndex actualMainCell = selection.mainCell;

      // Assert
      CellIndex expectedMainCell = startIndex;

      expect(actualMainCell, equals(expectedMainCell));
    });
  });

  group('SheetFillSelection.cellCorners', () {
    test('Should [return SelectionCellCorners] for range selection (BOTTOM-RIGHT direction)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex endIndex = CellIndex.raw(3, 3);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionCellCorners actualCorners = selection.cellCorners;

      // Assert
      SelectionCellCorners expectedCorners = SelectionCellCorners(startIndex, CellIndex.raw(1, 3), CellIndex.raw(3, 1), endIndex);

      expect(actualCorners, equals(expectedCorners));
    });

    test('Should [return SelectionCellCorners] for range selection (TOP-RIGHT direction)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(3, 1);
      CellIndex endIndex = CellIndex.raw(1, 3);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionCellCorners actualCorners = selection.cellCorners;

      // Assert
      SelectionCellCorners expectedCorners = SelectionCellCorners(CellIndex.raw(1, 1), endIndex, startIndex, CellIndex.raw(3, 3));

      expect(actualCorners, equals(expectedCorners));
    });

    test('Should [return SelectionCellCorners] for range selection (BOTTOM-LEFT direction)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 3);
      CellIndex endIndex = CellIndex.raw(3, 1);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionCellCorners actualCorners = selection.cellCorners;

      // Assert
      SelectionCellCorners expectedCorners = SelectionCellCorners(CellIndex.raw(1, 1), startIndex, endIndex, CellIndex.raw(3, 3));

      expect(actualCorners, equals(expectedCorners));
    });

    test('Should [return SelectionCellCorners] for range selection (TOP-LEFT direction)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(3, 3);
      CellIndex endIndex = CellIndex.raw(1, 1);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionCellCorners actualCorners = selection.cellCorners;

      // Assert
      SelectionCellCorners expectedCorners = SelectionCellCorners(endIndex, CellIndex.raw(1, 3), CellIndex.raw(3, 1), startIndex);

      expect(actualCorners, equals(expectedCorners));
    });
  });

  group('SheetFillSelection.contains()', () {
    test('Should [return TRUE] if [cell WITHIN range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      CellIndex cellIndex = CellIndex.raw(2, 2);

      // Act
      bool actualContains = selection.contains(cellIndex);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] if [row WITHIN range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      bool actualContainsRow = selection.contains(rowIndex);

      // Assert
      bool expectedContainsRow = true;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return TRUE] if [column WITHIN range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      bool actualContainsColumn = selection.contains(columnIndex);

      // Assert
      bool expectedContainsColumn = true;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });

    test('Should [return FALSE] if [cell OUTSIDE range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      CellIndex cellIndex = CellIndex.raw(4, 4);

      // Act
      bool actualContains = selection.contains(cellIndex);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] if [row OUTSIDE range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(4);

      // Act
      bool actualContainsRow = selection.contains(rowIndex);

      // Assert
      bool expectedContainsRow = false;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return FALSE] if [column OUTSIDE range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      bool actualContainsColumn = selection.contains(columnIndex);

      // Assert
      bool expectedContainsColumn = false;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });
  });

  group('SheetFillSelection.containsCell()', () {
    test('Should [return TRUE] if [cell WITHIN range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      CellIndex cellIndex = CellIndex.raw(2, 2);

      // Act
      bool actualContainsCell = selection.containsCell(cellIndex);

      // Assert
      bool expectedContainsCell = true;

      expect(actualContainsCell, equals(expectedContainsCell));
    });

    test('Should [return FALSE] if [cell OUTSIDE range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      CellIndex cellIndex = CellIndex.raw(4, 4);

      // Act
      bool actualContainsCell = selection.containsCell(cellIndex);

      // Assert
      bool expectedContainsCell = false;

      expect(actualContainsCell, equals(expectedContainsCell));
    });
  });

  group('SheetFillSelection.containsRow()', () {
    test('Should [return TRUE] if [row WITHIN range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      bool actualContainsRow = selection.containsRow(rowIndex);

      // Assert
      bool expectedContainsRow = true;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return FALSE] if [row OUTSIDE range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(4);

      // Act
      bool actualContainsRow = selection.containsRow(rowIndex);

      // Assert
      bool expectedContainsRow = false;

      expect(actualContainsRow, equals(expectedContainsRow));
    });
  });

  group('SheetFillSelection.containsColumn()', () {
    test('Should [return TRUE] if [column WITHIN range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      bool actualContainsColumn = selection.containsColumn(columnIndex);

      // Assert
      bool expectedContainsColumn = true;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });

    test('Should [return FALSE] if [column OUTSIDE range]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      bool actualContainsColumn = selection.containsColumn(columnIndex);

      // Assert
      bool expectedContainsColumn = false;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });
  });

  group('SheetFillSelection.containsSelection()', () {
    test('Should [return TRUE] for [NESTED SheetSingleSelection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      SheetSingleSelection nestedSelection = SheetSingleSelection(CellIndex.raw(2, 2));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] for [NESTED SheetRangeSelection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      SheetRangeSelection<CellIndex> nestedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(2, 2),
        CellIndex.raw(2, 2),
      );

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetSingleSelection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      SheetSingleSelection nonNestedSelection = SheetSingleSelection(CellIndex.raw(4, 4));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetRangeSelection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      SheetRangeSelection<CellIndex> nonNestedSelection =
          SheetRangeSelection<CellIndex>(CellIndex.raw(4, 4), CellIndex.raw(4, 4));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });
  });

  group('SheetFillSelection.isRowSelected()', () {
    test('Should [return SelectionStatus] for [FULLY SELECTED row]', () {
      // Arrange
      RowIndex rowIndex = RowIndex(2);
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<RowIndex>.single(rowIndex),
        fillDirection: Direction.right,
      );

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED row] (CellIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED row] (ColumnIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED row] (CellIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED row] (RowIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<RowIndex>.single(RowIndex(1)),
        fillDirection: Direction.right,
      );
      RowIndex rowIndex = RowIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });
  });

  group('SheetFillSelection.isColumnSelected()', () {
    test('Should [return SelectionStatus] for [FULLY SELECTED column]', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(2);
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<ColumnIndex>.single(columnIndex),
        fillDirection: Direction.right,
      );

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED column] (CellIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED column] (RowIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<RowIndex>.single(RowIndex(1)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED column] (CellIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED column] (ColumnIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1)),
        fillDirection: Direction.right,
      );
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });
  });

  group('SheetFillSelection.modifyEnd()', () {
    test('Should [return SheetFillSelection] with modified end index', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex newEndIndex = CellIndex.raw(4, 4);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        CellIndex.raw(2, 2),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      SheetSelection actualSelection = selection.modifyEnd(newEndIndex);

      // Assert
      SheetFillSelection expectedSelection = selection;

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('SheetFillSelection.complete()', () {
    test('Should [return SheetRangeSelection] with [completed == TRUE] (fillDirection == Direction.right)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 5);
      CellIndex endIndex = CellIndex.raw(3, 5);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 5),
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with [completed == TRUE] (fillDirection == Direction.top)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(5, 1);
      CellIndex endIndex = CellIndex.raw(5, 3);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.top,
      );

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(5, 1),
        CellIndex.raw(3, 3),
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with [completed == TRUE] (fillDirection == Direction.bottom)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex endIndex = CellIndex.raw(1, 3);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.bottom,
      );

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 3),
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with [completed == TRUE] (fillDirection == Direction.left)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex endIndex = CellIndex.raw(3, 1);
      SheetFillSelection selection = SheetFillSelection(
        startIndex,
        endIndex,
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.left,
      );

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
      );

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('SheetFillSelection.subtract()', () {
    test('Should [return List<SheetSelection>] with [this] as the only element', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 1),
        baseSelection: SheetSingleSelection(CellIndex.raw(1, 1)),
        fillDirection: Direction.right,
      );
      SheetSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(1, 1));

      // Act
      List<SheetSelection> actualSelections = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelections = <SheetSelection>[selection];

      expect(actualSelections, equals(expectedSelections));
    });
  });

  group('SheetFillSelection.stringifySelection()', () {
    test('Should [return String] representing SheetFillSelection (CellIndex range)', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      String actualString = selection.stringifySelection();

      // Assert
      String expectedString = 'B2:D4';

      expect(actualString, equals(expectedString));
    });
  });

  group('SheetFillSelection.direction', () {
    test('Should [return SelectionDirection.topRight] for [TOP-RIGHT selection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(3, 1),
        CellIndex.raw(1, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.topRight;

      expect(actualDirection, equals(expectedDirection));
    });

    test('Should [return SelectionDirection.topLeft] for [TOP-LEFT selection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(3, 3),
        CellIndex.raw(1, 1),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.topLeft;

      expect(actualDirection, equals(expectedDirection));
    });

    test('Should [return SelectionDirection.bottomRight] for [BOTTOM-RIGHT selection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 1),
        CellIndex.raw(3, 3),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.bottomRight;

      expect(actualDirection, equals(expectedDirection));
    });

    test('Should [return SelectionDirection.bottomLeft] for [BOTTOM-LEFT selection]', () {
      // Arrange
      SheetFillSelection selection = SheetFillSelection(
        CellIndex.raw(1, 3),
        CellIndex.raw(3, 1),
        baseSelection: SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3)),
        fillDirection: Direction.right,
      );

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.bottomLeft;

      expect(actualDirection, equals(expectedDirection));
    });
  });
}

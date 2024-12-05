import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_direction.dart';
import 'package:sheets/core/selection/selection_status.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';

void main() {
  group('SheetRangeSelection.isCompleted', () {
    test('Should [return TRUE] for [COMPLETED selection]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(2, 2),
      );

      // Act
      bool actualIsCompleted = selection.isCompleted;

      // Assert
      bool expectedIsCompleted = true;

      expect(actualIsCompleted, equals(expectedIsCompleted));
    });

    test('Should [return FALSE] for [INCOMPLETE selection]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(2, 2),
        completed: false,
      );

      // Act
      bool actualIsCompleted = selection.isCompleted;

      // Assert
      bool expectedIsCompleted = false;

      expect(actualIsCompleted, equals(expectedIsCompleted));
    });
  });

  group('SheetRangeSelection.rowSelected', () {
    test('Should [return TRUE] for [SELECTED row range]', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));

      // Act
      bool actualRowSelected = selection.rowSelected;

      // Assert
      bool expectedRowSelected = true;

      expect(actualRowSelected, equals(expectedRowSelected));
    });

    test('Should [return FALSE] for [SELECTED column range]', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));

      // Act
      bool actualRowSelected = selection.rowSelected;

      // Assert
      bool expectedRowSelected = false;

      expect(actualRowSelected, equals(expectedRowSelected));
    });

    test('Should [return FALSE] for [SELECTED cell range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));

      // Act
      bool actualRowSelected = selection.rowSelected;

      // Assert
      bool expectedRowSelected = false;

      expect(actualRowSelected, equals(expectedRowSelected));
    });
  });

  group('SheetRangeSelection.columnSelected', () {
    test('Should [return TRUE] for [SELECTED column range]', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));

      // Act
      bool actualColumnSelected = selection.columnSelected;

      // Assert
      bool expectedColumnSelected = true;

      expect(actualColumnSelected, equals(expectedColumnSelected));
    });

    test('Should [return FALSE] for [SELECTED row range]', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));

      // Act
      bool actualColumnSelected = selection.columnSelected;

      // Assert
      bool expectedColumnSelected = false;

      expect(actualColumnSelected, equals(expectedColumnSelected));
    });

    test('Should [return FALSE] for [SELECTED cell range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));

      // Act
      bool actualColumnSelected = selection.columnSelected;

      // Assert
      bool expectedColumnSelected = false;

      expect(actualColumnSelected, equals(expectedColumnSelected));
    });
  });

  group('SheetRangeSelection.mainCell', () {
    test('Should [return CellIndex] representing the main cell (CellIndex range)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex endIndex = CellIndex.raw(2, 2);
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, endIndex);

      // Act
      CellIndex actualMainCell = selection.mainCell;

      // Assert
      CellIndex expectedMainCell = startIndex;

      expect(actualMainCell, equals(expectedMainCell));
    });

    test('Should [return CellIndex] representing the main cell (RowIndex range)', () {
      // Arrange
      RowIndex rowIndex = RowIndex(1);
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(rowIndex);

      // Act
      CellIndex actualMainCell = selection.mainCell;

      // Assert
      CellIndex expectedMainCell = CellIndex.raw(1, 0);

      expect(actualMainCell, equals(expectedMainCell));
    });

    test('Should [return CellIndex] representing the main cell (ColumnIndex range)', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(1);
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(columnIndex);

      // Act
      CellIndex actualMainCell = selection.mainCell;

      // Assert
      CellIndex expectedMainCell = CellIndex.raw(0, 1);

      expect(actualMainCell, equals(expectedMainCell));
    });
  });

  group('SheetRangeSelection.cellCorners', () {
    test('Should [return SelectionCellCorners] for range selection (BOTTOM-RIGHT direction)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex endIndex = CellIndex.raw(3, 3);
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, endIndex);

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
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, endIndex);

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
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, endIndex);

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
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, endIndex);

      // Act
      SelectionCellCorners actualCorners = selection.cellCorners;

      // Assert
      SelectionCellCorners expectedCorners = SelectionCellCorners(endIndex, CellIndex.raw(1, 3), CellIndex.raw(3, 1), startIndex);

      expect(actualCorners, equals(expectedCorners));
    });
  });

  group('SheetRangeSelection.contains()', () {
    test('Should [return TRUE] if [cell WITHIN range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      CellIndex cellIndex = CellIndex.raw(2, 2);

      // Act
      bool actualContains = selection.contains(cellIndex);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] if [row WITHIN range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      RowIndex rowIndex = RowIndex(2);

      // Act
      bool actualContainsRow = selection.contains(rowIndex);

      // Assert
      bool expectedContainsRow = true;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return TRUE] if [column WITHIN range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      bool actualContainsColumn = selection.contains(columnIndex);

      // Assert
      bool expectedContainsColumn = true;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });

    test('Should [return FALSE] if [cell OUTSIDE range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      CellIndex cellIndex = CellIndex.raw(4, 4);

      // Act
      bool actualContains = selection.contains(cellIndex);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] if [row OUTSIDE range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      RowIndex rowIndex = RowIndex(4);

      // Act
      bool actualContainsRow = selection.contains(rowIndex);

      // Assert
      bool expectedContainsRow = false;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return FALSE] if [column OUTSIDE range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      bool actualContainsColumn = selection.contains(columnIndex);

      // Assert
      bool expectedContainsColumn = false;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });
  });

  group('SheetRangeSelection.containsCell()', () {
    test('Should [return TRUE] if [cell WITHIN range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      CellIndex cellIndex = CellIndex.raw(2, 2);

      // Act
      bool actualContainsCell = selection.containsCell(cellIndex);

      // Assert
      bool expectedContainsCell = true;

      expect(actualContainsCell, equals(expectedContainsCell));
    });

    test('Should [return FALSE] if [cell OUTSIDE range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      CellIndex cellIndex = CellIndex.raw(4, 4);

      // Act
      bool actualContainsCell = selection.containsCell(cellIndex);

      // Assert
      bool expectedContainsCell = false;

      expect(actualContainsCell, equals(expectedContainsCell));
    });
  });

  group('SheetRangeSelection.containsRow()', () {
    test('Should [return TRUE] if [row WITHIN range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      RowIndex rowIndex = RowIndex(2);

      // Act
      bool actualContainsRow = selection.containsRow(rowIndex);

      // Assert
      bool expectedContainsRow = true;

      expect(actualContainsRow, equals(expectedContainsRow));
    });

    test('Should [return FALSE] if [row OUTSIDE range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      RowIndex rowIndex = RowIndex(4);

      // Act
      bool actualContainsRow = selection.containsRow(rowIndex);

      // Assert
      bool expectedContainsRow = false;

      expect(actualContainsRow, equals(expectedContainsRow));
    });
  });

  group('SheetRangeSelection.containsColumn()', () {
    test('Should [return TRUE] if [column WITHIN range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      bool actualContainsColumn = selection.containsColumn(columnIndex);

      // Assert
      bool expectedContainsColumn = true;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });

    test('Should [return FALSE] if [column OUTSIDE range]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      bool actualContainsColumn = selection.containsColumn(columnIndex);

      // Assert
      bool expectedContainsColumn = false;

      expect(actualContainsColumn, equals(expectedContainsColumn));
    });
  });

  group('SheetRangeSelection.containsSelection()', () {
    test('Should [return TRUE] for [NESTED SheetSingleSelection] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      SheetSingleSelection nestedSelection = SheetSingleSelection(CellIndex.raw(2, 2));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] for [NESTED SheetSingleSelection] (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));
      SheetSingleSelection nestedSelection = SheetSingleSelection(CellIndex.raw(1, 3));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] for [NESTED SheetSingleSelection] (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));
      SheetSingleSelection nestedSelection = SheetSingleSelection(CellIndex.raw(3, 1));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] for [NESTED SheetRangeSelection] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      SheetRangeSelection<CellIndex> nestedSelection = SheetRangeSelection<CellIndex>(CellIndex.raw(2, 2), CellIndex.raw(2, 2));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] for [NESTED SheetRangeSelection] (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));
      SheetRangeSelection<RowIndex> nestedSelection = SheetRangeSelection<RowIndex>.single(RowIndex(1));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return TRUE] for [NESTED SheetRangeSelection] (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));
      SheetRangeSelection<ColumnIndex> nestedSelection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));

      // Act
      bool actualContains = selection.containsSelection(nestedSelection);

      // Assert
      bool expectedContains = true;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetSingleSelection] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      SheetSingleSelection nonNestedSelection = SheetSingleSelection(CellIndex.raw(4, 4));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetSingleSelection] (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));
      SheetSingleSelection nonNestedSelection = SheetSingleSelection(CellIndex.raw(2, 3));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetSingleSelection] (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));
      SheetSingleSelection nonNestedSelection = SheetSingleSelection(CellIndex.raw(3, 3));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetRangeSelection] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      SheetRangeSelection<CellIndex> nonNestedSelection =
          SheetRangeSelection<CellIndex>(CellIndex.raw(4, 4), CellIndex.raw(4, 4));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetRangeSelection] (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));
      SheetRangeSelection<RowIndex> nonNestedSelection = SheetRangeSelection<RowIndex>.single(RowIndex(2));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });

    test('Should [return FALSE] for [NON-NESTED SheetRangeSelection] (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));
      SheetRangeSelection<ColumnIndex> nonNestedSelection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(2));

      // Act
      bool actualContains = selection.containsSelection(nonNestedSelection);

      // Assert
      bool expectedContains = false;

      expect(actualContains, equals(expectedContains));
    });
  });

  group('SheetRangeSelection.isRowSelected()', () {
    test('Should [return SelectionStatus] if [EVERYTHING selected]', () {
      // Arrange
      RowIndex rowIndex = RowIndex(2);
      SheetSelection selection = SheetSelectionFactory.all();

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [FULLY SELECTED row]', () {
      // Arrange
      RowIndex rowIndex = RowIndex(2);
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(rowIndex);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED row] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      RowIndex rowIndex = RowIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED row] (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));
      RowIndex rowIndex = RowIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED row] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      RowIndex rowIndex = RowIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED row] (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));
      RowIndex rowIndex = RowIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isRowSelected(rowIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });
  });

  group('SheetRangeSelection.isColumnSelected()', () {
    test('Should [return SelectionStatus] if [EVERYTHING selected]', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(2);
      SheetSelection selection = SheetSelectionFactory.all();

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [FULLY SELECTED column]', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(2);
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(columnIndex);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, true);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED column] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [SELECTED column] (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));
      ColumnIndex columnIndex = ColumnIndex(2);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(true, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED column] (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });

    test('Should [return SelectionStatus] for [NON-SELECTED column] (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));
      ColumnIndex columnIndex = ColumnIndex(4);

      // Act
      SelectionStatus actualStatus = selection.isColumnSelected(columnIndex);

      // Assert
      SelectionStatus expectedStatus = SelectionStatus(false, false);

      expect(actualStatus, equals(expectedStatus));
    });
  });

  group('SheetRangeSelection.modifyEnd()', () {
    test('Should [return SheetRangeSelection] with modified end index (CellIndex range)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex newEndIndex = CellIndex.raw(4, 4);
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, CellIndex.raw(2, 2));

      // Act
      SheetSelection actualSelection = selection.modifyEnd(newEndIndex);

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection =
          SheetRangeSelection<CellIndex>(startIndex, newEndIndex, completed: false);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with modified end index (RowIndex range)', () {
      // Arrange
      RowIndex rowIndex = RowIndex(1);
      RowIndex newRowIndex = RowIndex(4);
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(rowIndex);

      // Act
      SheetSelection actualSelection = selection.modifyEnd(newRowIndex);

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 0),
        CellIndex.raw(4, 0),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with modified end index (ColumnIndex range)', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(1);
      ColumnIndex newColumnIndex = ColumnIndex(4);
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(columnIndex);

      // Act
      SheetSelection actualSelection = selection.modifyEnd(newColumnIndex);

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(0, 1),
        CellIndex.raw(0, 4),
        completed: false,
      );

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('SheetRangeSelection.complete()', () {
    test('Should [return SheetRangeSelection] with [completed == TRUE] (CellIndex range)', () {
      // Arrange
      CellIndex startIndex = CellIndex.raw(1, 1);
      CellIndex endIndex = CellIndex.raw(3, 3);
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(startIndex, endIndex, completed: false);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<CellIndex> expectedSelection = SheetRangeSelection<CellIndex>(startIndex, endIndex);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with [completed == TRUE] (RowIndex range)', () {
      // Arrange
      RowIndex rowIndex = RowIndex(1);
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(rowIndex, completed: false);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<RowIndex> expectedSelection = SheetRangeSelection<RowIndex>.single(rowIndex);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetRangeSelection] with [completed == TRUE] (ColumnIndex range)', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(1);
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(columnIndex, completed: false);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetRangeSelection<ColumnIndex> expectedSelection = SheetRangeSelection<ColumnIndex>.single(columnIndex);

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return SheetSingleSelection] with [completed == TRUE] if range contains only one cell', () {
      // Arrange
      CellIndex cellIndex = CellIndex.raw(1, 1);
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(cellIndex, cellIndex, completed: false);

      // Act
      SheetSelection actualSelection = selection.complete();

      // Assert
      SheetSingleSelection expectedSelection = SheetSingleSelection(cellIndex);

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('SheetRangeSelection.subtract()', () {
    test('Should [return List<SheetSelection>] if TOP-LEFT corner subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(5, 5),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(6, 1), CellIndex.raw(10, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 6), CellIndex.raw(5, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP-RIGHT corner subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 6),
        CellIndex.raw(5, 10),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(5, 5)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(6, 1), CellIndex.raw(10, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM-LEFT corner subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(6, 1),
        CellIndex.raw(10, 5),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(5, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(6, 6), CellIndex.raw(10, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM-RIGHT corner subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(6, 6),
        CellIndex.raw(10, 10),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(5, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(6, 1), CellIndex.raw(10, 5)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 3),
        CellIndex.raw(7, 7),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(2, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 1), CellIndex.raw(7, 2)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(8, 1), CellIndex.raw(10, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 8), CellIndex.raw(7, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-LEFT subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 1),
        CellIndex.raw(7, 1),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(2, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(8, 1), CellIndex.raw(10, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 2), CellIndex.raw(7, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-RIGHT subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 10),
        CellIndex.raw(7, 10),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(2, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 1), CellIndex.raw(7, 9)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(8, 1), CellIndex.raw(10, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-TOP subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 3),
        CellIndex.raw(1, 7),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(1, 2)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 1), CellIndex.raw(10, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 8), CellIndex.raw(1, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-BOTTOM subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(10, 3),
        CellIndex.raw(10, 7),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(9, 10)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(10, 1), CellIndex.raw(10, 2)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(10, 8), CellIndex.raw(10, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 10),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 1), CellIndex.raw(10, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(10, 1),
        CellIndex.raw(10, 10),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(9, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if LEFT subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 1),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 2), CellIndex.raw(10, 10)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if RIGHT subtracted (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 1),
        CellIndex.raw(10, 10),
      );
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 10),
        CellIndex.raw(10, 10),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(10, 9)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP-LEFT corner subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 0),
        CellIndex.raw(1, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(3, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 4), CellIndex.raw(1, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP-RIGHT corner subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 3),
        CellIndex.raw(1, Int.max),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(1, 2)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(3, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM-LEFT corner subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 0),
        CellIndex.raw(3, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(2, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 4), CellIndex.raw(3, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM-RIGHT corner subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 3),
        CellIndex.raw(3, Int.max),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(2, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 0), CellIndex.raw(3, 2)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(2, 2),
        CellIndex.raw(2, 2),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(1, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(2, 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 0), CellIndex.raw(3, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 3), CellIndex.raw(2, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-TOP subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(1, 2));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(1, 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(3, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 3), CellIndex.raw(1, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-BOTTOM subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(3, 2));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(2, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 0), CellIndex.raw(3, 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 3), CellIndex.raw(3, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-LEFT subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(2, 0));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(1, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 0), CellIndex.raw(3, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 1), CellIndex.raw(2, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-RIGHT subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(2, Int.max));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(1, Int.max)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(2, Int.max - 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 0), CellIndex.raw(3, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 0),
        CellIndex.raw(1, Int.max),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 0), CellIndex.raw(3, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 0),
        CellIndex.raw(3, Int.max),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(2, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if LEFT subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, 0),
        CellIndex.raw(3, 0),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, Int.max)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if RIGHT subtracted (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>(RowIndex(1), RowIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(1, Int.max),
        CellIndex.raw(3, Int.max),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 0), CellIndex.raw(3, Int.max - 1)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP-LEFT corner subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(0, 1),
        CellIndex.raw(3, 1),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(4, 1), CellIndex.raw(Int.max, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 2), CellIndex.raw(3, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP-RIGHT corner subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 1),
        CellIndex.raw(Int.max, 1),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(2, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 2), CellIndex.raw(Int.max, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM-LEFT corner subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(0, 3),
        CellIndex.raw(3, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(3, 2)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(4, 1), CellIndex.raw(Int.max, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM-RIGHT corner subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(3, 3),
        CellIndex.raw(Int.max, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(2, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 1), CellIndex.raw(Int.max, 2)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(2, 2),
        CellIndex.raw(2, 2),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(1, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 1), CellIndex.raw(2, 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(3, 1), CellIndex.raw(Int.max, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(2, 3), CellIndex.raw(2, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-TOP subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(0, 2));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(0, 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(Int.max, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 3), CellIndex.raw(0, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-BOTTOM subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(Int.max, 2));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(Int.max - 1, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(Int.max, 1), CellIndex.raw(Int.max, 1)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(Int.max, 3), CellIndex.raw(Int.max, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-LEFT subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(10, 1));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(9, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(11, 1), CellIndex.raw(Int.max, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(10, 2), CellIndex.raw(10, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if CENTER-RIGHT subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetSingleSelection subtractedSelection = SheetSingleSelection(CellIndex.raw(10, 3));

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(9, 3)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(10, 1), CellIndex.raw(10, 2)),
        SheetRangeSelection<CellIndex>(CellIndex.raw(11, 1), CellIndex.raw(Int.max, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if TOP subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(0, 1),
        CellIndex.raw(0, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(Int.max, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if BOTTOM subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(Int.max, 1),
        CellIndex.raw(Int.max, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(Int.max - 1, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if LEFT subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(0, 1),
        CellIndex.raw(Int.max, 1),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 2), CellIndex.raw(Int.max, 3)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });

    test('Should [return List<SheetSelection>] if RIGHT subtracted (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>(ColumnIndex(1), ColumnIndex(3));
      SheetRangeSelection<CellIndex> subtractedSelection = SheetRangeSelection<CellIndex>(
        CellIndex.raw(0, 3),
        CellIndex.raw(Int.max, 3),
      );

      // Act
      List<SheetSelection> actualSelection = selection.subtract(subtractedSelection);

      // Assert
      List<SheetSelection> expectedSelection = <SheetSelection>[
        SheetRangeSelection<CellIndex>(CellIndex.raw(0, 1), CellIndex.raw(Int.max, 2)),
      ];

      expect(actualSelection, equals(expectedSelection));
    });
  });

  group('SheetRangeSelection.stringifySelection()', () {
    test('Should [return String] representing SheetRangeSelection (CellIndex range)', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));

      // Act
      String actualString = selection.stringifySelection();

      // Assert
      String expectedString = 'B2:D4';

      expect(actualString, equals(expectedString));
    });

    test('Should [return String] representing SheetRangeSelection (RowIndex range)', () {
      // Arrange
      SheetRangeSelection<RowIndex> selection = SheetRangeSelection<RowIndex>.single(RowIndex(1));

      // Act
      String actualString = selection.stringifySelection();

      // Assert
      String expectedString = '2:2';

      expect(actualString, equals(expectedString));
    });

    test('Should [return String] representing SheetRangeSelection (ColumnIndex range)', () {
      // Arrange
      SheetRangeSelection<ColumnIndex> selection = SheetRangeSelection<ColumnIndex>.single(ColumnIndex(1));

      // Act
      String actualString = selection.stringifySelection();

      // Assert
      String expectedString = 'B:B';

      expect(actualString, equals(expectedString));
    });
  });

  group('SheetRangeSelection.direction', () {
    test('Should [return SelectionDirection.topRight] for [TOP-RIGHT selection]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(3, 1), CellIndex.raw(1, 3));

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.topRight;

      expect(actualDirection, equals(expectedDirection));
    });

    test('Should [return SelectionDirection.topLeft] for [TOP-LEFT selection]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(3, 3), CellIndex.raw(1, 1));

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.topLeft;

      expect(actualDirection, equals(expectedDirection));
    });

    test('Should [return SelectionDirection.bottomRight] for [BOTTOM-RIGHT selection]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 1), CellIndex.raw(3, 3));

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.bottomRight;

      expect(actualDirection, equals(expectedDirection));
    });

    test('Should [return SelectionDirection.bottomLeft] for [BOTTOM-LEFT selection]', () {
      // Arrange
      SheetRangeSelection<CellIndex> selection = SheetRangeSelection<CellIndex>(CellIndex.raw(1, 3), CellIndex.raw(3, 1));

      // Act
      SelectionDirection actualDirection = selection.direction;

      // Assert
      SelectionDirection expectedDirection = SelectionDirection.bottomLeft;

      expect(actualDirection, equals(expectedDirection));
    });
  });
}

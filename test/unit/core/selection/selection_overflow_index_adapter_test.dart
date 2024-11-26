import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/sheet_index.dart';

void main() {
  group('SelectionOverflowIndexAdapter.adaptToCellIndex', () {
    test('Should [return the same CellIndex] when CellIndex is provided', () {
      // Arrange
      SheetIndex selectedIndex = CellIndex.raw(2, 3);
      RowIndex firstVisibleRow = RowIndex(1);
      ColumnIndex firstVisibleColumn = ColumnIndex(1);

      // Act
      SheetIndex actualIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(selectedIndex, firstVisibleRow, firstVisibleColumn);

      // Assert
      expect(actualIndex, equals(selectedIndex));
    });

    test('Should [return adapted CellIndex] when ColumnIndex is provided', () {
      // Arrange
      ColumnIndex columnIndex = ColumnIndex(3);
      RowIndex firstVisibleRow = RowIndex(2);
      ColumnIndex firstVisibleColumn = ColumnIndex(1);

      // Act
      SheetIndex actualIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(columnIndex, firstVisibleRow, firstVisibleColumn);

      // Assert
      CellIndex expectedIndex = CellIndex(row: firstVisibleRow, column: columnIndex).move(dx: 0, dy: -1);
      expect(actualIndex, equals(expectedIndex));
    });

    test('Should [return adapted CellIndex] when RowIndex is provided', () {
      // Arrange
      RowIndex rowIndex = RowIndex(4);
      RowIndex firstVisibleRow = RowIndex(2);
      ColumnIndex firstVisibleColumn = ColumnIndex(3);

      // Act
      SheetIndex actualIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(rowIndex, firstVisibleRow, firstVisibleColumn);

      // Assert
      CellIndex expectedIndex = CellIndex(row: rowIndex, column: firstVisibleColumn).move(dx: -1, dy: 0);
      expect(actualIndex, equals(expectedIndex));
    });
  });
}

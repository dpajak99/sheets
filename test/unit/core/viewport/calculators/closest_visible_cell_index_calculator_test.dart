import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_cell_index_calculator.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of ClosestVisibleCellIndexCalculator', () {
    group('Tests of ClosestVisibleCellIndexCalculator.findFor()', () {
      test('Should [return fully visible cell] when [cell is within visible rows and columns]', () {
        // Arrange
        List<ViewportRow> visibleRows = [
          ViewportRow(index: RowIndex(2), rect: Rect.zero, style: RowStyle.defaults()),
          ViewportRow(index: RowIndex(3), rect: Rect.zero, style: RowStyle.defaults()),
          ViewportRow(index: RowIndex(4), rect: Rect.zero, style: RowStyle.defaults()),
        ];
        List<ViewportColumn> visibleColumns = [
          ViewportColumn(index: ColumnIndex(2), rect: Rect.zero, style: ColumnStyle.defaults()),
          ViewportColumn(index: ColumnIndex(3), rect: Rect.zero, style: ColumnStyle.defaults()),
          ViewportColumn(index: ColumnIndex(4), rect: Rect.zero, style: ColumnStyle.defaults()),
        ];
        ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(
          visibleRows: visibleRows,
          visibleColumns: visibleColumns,
        );
        CellIndex cellIndex = CellIndex(row: RowIndex(3), column: ColumnIndex(3));

        // Act
        ClosestVisible<CellIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<CellIndex> expectedClosestVisible = ClosestVisible<CellIndex>.fullyVisible(
          CellIndex(row: RowIndex(3), column: ColumnIndex(3)),
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible cell from top-left] when [cell is before visible rows and columns]', () {
        // Arrange
        List<ViewportRow> visibleRows = [
          ViewportRow(index: RowIndex(5), rect: Rect.zero, style: RowStyle.defaults()),
        ];
        List<ViewportColumn> visibleColumns = [
          ViewportColumn(index: ColumnIndex(5), rect: Rect.zero, style: ColumnStyle.defaults()),
        ];
        ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(
          visibleRows: visibleRows,
          visibleColumns: visibleColumns,
        );
        CellIndex cellIndex = CellIndex(row: RowIndex(3), column: ColumnIndex(3));

        // Act
        ClosestVisible<CellIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<CellIndex> expectedClosestVisible = ClosestVisible<CellIndex>.partiallyVisible(
          value: CellIndex(row: RowIndex(5), column: ColumnIndex(5)),
          hiddenBorders: <Direction>[Direction.top, Direction.left],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible cell from bottom-right] when [cell is after visible rows and columns]', () {
        // Arrange
        List<ViewportRow> visibleRows = [
          ViewportRow(index: RowIndex(2), rect: Rect.zero, style: RowStyle.defaults()),
        ];
        List<ViewportColumn> visibleColumns = [
          ViewportColumn(index: ColumnIndex(2), rect: Rect.zero, style: ColumnStyle.defaults()),
        ];
        ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(
          visibleRows: visibleRows,
          visibleColumns: visibleColumns,
        );
        CellIndex cellIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(5));

        // Act
        ClosestVisible<CellIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<CellIndex> expectedClosestVisible = ClosestVisible<CellIndex>.partiallyVisible(
          value: CellIndex(row: RowIndex(2), column: ColumnIndex(2)),
          hiddenBorders: <Direction>[Direction.bottom, Direction.right],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible cell from top-right] when [cell row before and column after visible ones]', () {
        // Arrange
        List<ViewportRow> visibleRows = [
          ViewportRow(index: RowIndex(5), rect: Rect.zero, style: RowStyle.defaults()),
        ];
        List<ViewportColumn> visibleColumns = [
          ViewportColumn(index: ColumnIndex(2), rect: Rect.zero, style: ColumnStyle.defaults()),
        ];
        ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(
          visibleRows: visibleRows,
          visibleColumns: visibleColumns,
        );
        CellIndex cellIndex = CellIndex(row: RowIndex(3), column: ColumnIndex(5));

        // Act
        ClosestVisible<CellIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<CellIndex> expectedClosestVisible = ClosestVisible<CellIndex>.partiallyVisible(
          value: CellIndex(row: RowIndex(5), column: ColumnIndex(2)),
          hiddenBorders: <Direction>[Direction.top, Direction.right],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible cell from bottom-left] when [cell row after and column before visible ones]', () {
        // Arrange
        List<ViewportRow> visibleRows = [
          ViewportRow(index: RowIndex(2), rect: Rect.zero, style: RowStyle.defaults()),
        ];
        List<ViewportColumn> visibleColumns = [
          ViewportColumn(index: ColumnIndex(5), rect: Rect.zero, style: ColumnStyle.defaults()),
        ];
        ClosestVisibleCellIndexCalculator calculator = ClosestVisibleCellIndexCalculator(
          visibleRows: visibleRows,
          visibleColumns: visibleColumns,
        );
        CellIndex cellIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(3));

        // Act
        ClosestVisible<CellIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<CellIndex> expectedClosestVisible = ClosestVisible<CellIndex>.partiallyVisible(
          value: CellIndex(row: RowIndex(2), column: ColumnIndex(5)),
          hiddenBorders: <Direction>[Direction.bottom, Direction.left],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });
    });
  });
}
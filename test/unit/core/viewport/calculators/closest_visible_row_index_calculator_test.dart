import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/calculators/closest_visible_row_index_calculator.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of ClosestVisibleRowIndexCalculator', () {
    group('Tests of ClosestVisibleRowIndexCalculator.findFor()', () {
      test('Should [return fully visible] when [cell row is within visible rows]', () {
        // Arrange
        List<ViewportRow> visibleRows = <ViewportRow>[
          ViewportRow(index: RowIndex(2), rect: BorderRect.zero, config: const RowConfig()),
          ViewportRow(index: RowIndex(3), rect: BorderRect.zero, config: const RowConfig()),
          ViewportRow(index: RowIndex(4), rect: BorderRect.zero, config: const RowConfig()),
        ];
        ClosestVisibleRowIndexCalculator calculator = ClosestVisibleRowIndexCalculator(visibleRows);
        CellIndex cellIndex = CellIndex(row: RowIndex(3), column: ColumnIndex(0));

        // Act
        ClosestVisible<RowIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<RowIndex> expectedClosestVisible = ClosestVisible<RowIndex>.fullyVisible(
          RowIndex(3),
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible from top] when [cell row is before visible rows]', () {
        // Arrange
        List<ViewportRow> visibleRows = <ViewportRow>[
          ViewportRow(index: RowIndex(5), rect: BorderRect.zero, config: const RowConfig()),
          ViewportRow(index: RowIndex(6), rect: BorderRect.zero, config: const RowConfig()),
        ];
        ClosestVisibleRowIndexCalculator calculator = ClosestVisibleRowIndexCalculator(visibleRows);
        CellIndex cellIndex = CellIndex(row: RowIndex(4), column: ColumnIndex(0));

        // Act
        ClosestVisible<RowIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<RowIndex> expectedClosestVisible = ClosestVisible<RowIndex>.partiallyVisible(
          value: RowIndex(5),
          hiddenBorders: <Direction>[Direction.top],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible from bottom] when [cell row is after visible rows]', () {
        // Arrange
        List<ViewportRow> visibleRows = <ViewportRow>[
          ViewportRow(index: RowIndex(2), rect: BorderRect.zero, config: const RowConfig()),
          ViewportRow(index: RowIndex(3), rect: BorderRect.zero, config: const RowConfig()),
        ];
        ClosestVisibleRowIndexCalculator calculator = ClosestVisibleRowIndexCalculator(visibleRows);
        CellIndex cellIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(0));

        // Act
        ClosestVisible<RowIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<RowIndex> expectedClosestVisible = ClosestVisible<RowIndex>.partiallyVisible(
          value: RowIndex(3),
          hiddenBorders: <Direction>[Direction.bottom],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [handle single visible row] correctly', () {
        // Arrange
        List<ViewportRow> visibleRows = <ViewportRow>[
          ViewportRow(index: RowIndex(10), rect: BorderRect.zero, config: const RowConfig()),
        ];
        ClosestVisibleRowIndexCalculator calculator = ClosestVisibleRowIndexCalculator(visibleRows);
        CellIndex cellIndex = CellIndex(row: RowIndex(10), column: ColumnIndex(0));

        // Act
        ClosestVisible<RowIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<RowIndex> expectedClosestVisible = ClosestVisible<RowIndex>.fullyVisible(RowIndex(10));

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });

      test('Should [return partially visible from top] when [cell row is before first visible row]', () {
        // Arrange
        List<ViewportRow> visibleRows = <ViewportRow>[
          ViewportRow(index: RowIndex(5), rect: BorderRect.zero, config: const RowConfig()),
        ];
        ClosestVisibleRowIndexCalculator calculator = ClosestVisibleRowIndexCalculator(visibleRows);
        CellIndex cellIndex = CellIndex(row: RowIndex(3), column: ColumnIndex(0));

        // Act
        ClosestVisible<RowIndex> actualClosestVisible = calculator.findFor(cellIndex);

        // Assert
        ClosestVisible<RowIndex> expectedClosestVisible = ClosestVisible<RowIndex>.partiallyVisible(
          value: RowIndex(5),
          hiddenBorders: <Direction>[Direction.top],
        );

        expect(actualClosestVisible, equals(expectedClosestVisible));
      });
    });
  });
}

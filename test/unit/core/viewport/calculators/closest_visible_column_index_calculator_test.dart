// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sheets/core/sheet_index.dart';
// import 'package:sheets/core/sheet_properties.dart';
// import 'package:sheets/core/viewport/calculators/closest_visible_column_index_calculator.dart';
// import 'package:sheets/core/viewport/viewport_item.dart';
// import 'package:sheets/utils/closest_visible.dart';
// import 'package:sheets/utils/direction.dart';
//
// void main() {
//   group('Tests of ClosestVisibleColumnIndexCalculator', () {
//     group('Tests of ClosestVisibleColumnIndexCalculator.findFor()', () {
//       test('Should [return fully visible] when [cell column is within visible columns]', () {
//         // Arrange
//         List<ViewportColumn> visibleColumns = <ViewportColumn>[
//           ViewportColumn(index: ColumnIndex(2), rect: Rect.zero, style: ColumnStyle.defaults()),
//           ViewportColumn(index: ColumnIndex(3), rect: Rect.zero, style: ColumnStyle.defaults()),
//           ViewportColumn(index: ColumnIndex(4), rect: Rect.zero, style: ColumnStyle.defaults()),
//         ];
//         ClosestVisibleColumnIndexCalculator calculator = ClosestVisibleColumnIndexCalculator(visibleColumns);
//         CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(3));
//
//         // Act
//         ClosestVisible<ColumnIndex> actualClosestVisible = calculator.findFor(cellIndex);
//
//         // Assert
//         ClosestVisible<ColumnIndex> expectedClosestVisible = ClosestVisible<ColumnIndex>.fullyVisible(
//           ColumnIndex(3),
//         );
//
//         expect(actualClosestVisible, equals(expectedClosestVisible));
//       });
//
//       test('Should [return partially visible from left] when [cell column is before visible columns]', () {
//         // Arrange
//         List<ViewportColumn> visibleColumns = <ViewportColumn>[
//           ViewportColumn(index: ColumnIndex(5), rect: Rect.zero, style: ColumnStyle.defaults()),
//           ViewportColumn(index: ColumnIndex(6), rect: Rect.zero, style: ColumnStyle.defaults()),
//         ];
//         ClosestVisibleColumnIndexCalculator calculator = ClosestVisibleColumnIndexCalculator(visibleColumns);
//         CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(4));
//
//         // Act
//         ClosestVisible<ColumnIndex> actualClosestVisible = calculator.findFor(cellIndex);
//
//         // Assert
//         ClosestVisible<ColumnIndex> expectedClosestVisible = ClosestVisible<ColumnIndex>.partiallyVisible(
//           value: ColumnIndex(5),
//           hiddenBorders: <Direction>[Direction.left],
//         );
//
//         expect(actualClosestVisible, equals(expectedClosestVisible));
//       });
//
//       test('Should [return partially visible from right] when [cell column is after visible columns]', () {
//         // Arrange
//         List<ViewportColumn> visibleColumns = <ViewportColumn>[
//           ViewportColumn(index: ColumnIndex(2), rect: Rect.zero, style: ColumnStyle.defaults()),
//           ViewportColumn(index: ColumnIndex(3), rect: Rect.zero, style: ColumnStyle.defaults()),
//         ];
//         ClosestVisibleColumnIndexCalculator calculator = ClosestVisibleColumnIndexCalculator(visibleColumns);
//         CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(5));
//
//         // Act
//         ClosestVisible<ColumnIndex> actualClosestVisible = calculator.findFor(cellIndex);
//
//         // Assert
//         ClosestVisible<ColumnIndex> expectedClosestVisible = ClosestVisible<ColumnIndex>.partiallyVisible(
//           value: ColumnIndex(3),
//           hiddenBorders: <Direction>[Direction.right],
//         );
//
//         expect(actualClosestVisible, equals(expectedClosestVisible));
//       });
//
//       test('Should [handle single visible column] correctly', () {
//         // Arrange
//         List<ViewportColumn> visibleColumns = <ViewportColumn>[
//           ViewportColumn(index: ColumnIndex(10), rect: Rect.zero, style: ColumnStyle.defaults()),
//         ];
//         ClosestVisibleColumnIndexCalculator calculator = ClosestVisibleColumnIndexCalculator(visibleColumns);
//         CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(10));
//
//         // Act
//         ClosestVisible<ColumnIndex> actualClosestVisible = calculator.findFor(cellIndex);
//
//         // Assert
//         ClosestVisible<ColumnIndex> expectedClosestVisible = ClosestVisible<ColumnIndex>.fullyVisible(ColumnIndex(10));
//
//         expect(actualClosestVisible, equals(expectedClosestVisible));
//       });
//
//       test('Should [return partially visible from left] when [cell column is before first visible column]', () {
//         // Arrange
//         List<ViewportColumn> visibleColumns = <ViewportColumn>[
//           ViewportColumn(index: ColumnIndex(5), rect: Rect.zero, style: ColumnStyle.defaults()),
//         ];
//         ClosestVisibleColumnIndexCalculator calculator = ClosestVisibleColumnIndexCalculator(visibleColumns);
//         CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(3));
//
//         // Act
//         ClosestVisible<ColumnIndex> actualClosestVisible = calculator.findFor(cellIndex);
//
//         // Assert
//         ClosestVisible<ColumnIndex> expectedClosestVisible = ClosestVisible<ColumnIndex>.partiallyVisible(
//           value: ColumnIndex(5),
//           hiddenBorders: <Direction>[Direction.left],
//         );
//
//         expect(actualClosestVisible, equals(expectedClosestVisible));
//       });
//     });
//   });
// }

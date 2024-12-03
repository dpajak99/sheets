// import 'package:flutter_test/flutter_test.dart';
// import 'package:sheets/core/cell_properties.dart';
// import 'package:sheets/core/sheet_index.dart';
// import 'package:sheets/utils/extensions/cell_properties_extensions.dart';
//
// void main() {
//   group('Tests of IndexedCellPropertiesExtensions', () {
//     group('Tests of groupByColumns()', () {
//       test('Should [group cells by columns]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(1, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(0, 1), properties: CellProperties()),
//         ];
//
//         // Act
//         Map<ColumnIndex, List<IndexedCellProperties>> grouped = cells.groupByColumns();
//
//         // Assert
//         expect(grouped.length, 2);
//         expect(grouped[ColumnIndex(0)]?.length, 2);
//         expect(grouped[ColumnIndex(1)]?.length, 1);
//       });
//
//       test('Should [return empty map] when [no cells are provided]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[];
//
//         // Act
//         Map<ColumnIndex, List<IndexedCellProperties>> grouped = cells.groupByColumns();
//
//         // Assert
//         expect(grouped.isEmpty, isTrue);
//       });
//     });
//
//     group('Tests of whereColumn()', () {
//       test('Should [filter cells by column]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(1, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(0, 1), properties: CellProperties()),
//         ];
//
//         // Act
//         List<IndexedCellProperties> columnCells = cells.whereColumn(ColumnIndex(0));
//
//         // Assert
//         expect(columnCells.length, 2);
//         expect(columnCells.every((IndexedCellProperties cell) => cell.index.column == ColumnIndex(0)), isTrue);
//       });
//
//       test('Should [return empty list] when [no cells match the column]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//         ];
//
//         // Act
//         List<IndexedCellProperties> columnCells = cells.whereColumn(ColumnIndex(1));
//
//         // Assert
//         expect(columnCells.isEmpty, isTrue);
//       });
//     });
//
//     group('Tests of groupByRows()', () {
//       test('Should [group cells by rows]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(0, 1), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(1, 0), properties: CellProperties()),
//         ];
//
//         // Act
//         Map<RowIndex, List<IndexedCellProperties>> grouped = cells.groupByRows();
//
//         // Assert
//         expect(grouped.length, 2);
//         expect(grouped[RowIndex(0)]?.length, 2);
//         expect(grouped[RowIndex(1)]?.length, 1);
//       });
//
//       test('Should [return empty map] when [no cells are provided]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[];
//
//         // Act
//         Map<RowIndex, List<IndexedCellProperties>> grouped = cells.groupByRows();
//
//         // Assert
//         expect(grouped.isEmpty, isTrue);
//       });
//     });
//
//     group('Tests of whereRow()', () {
//       test('Should [filter cells by row]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(0, 1), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(1, 0), properties: CellProperties()),
//         ];
//
//         // Act
//         List<IndexedCellProperties> rowCells = cells.whereRow(RowIndex(0));
//
//         // Assert
//         expect(rowCells.length, 2);
//         expect(rowCells.every((IndexedCellProperties cell) => cell.index.row == RowIndex(0)), isTrue);
//       });
//
//       test('Should [return empty list] when [no cells match the row]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//         ];
//
//         // Act
//         List<IndexedCellProperties> rowCells = cells.whereRow(RowIndex(1));
//
//         // Assert
//         expect(rowCells.isEmpty, isTrue);
//       });
//     });
//
//     group('Tests of maybeReverse()', () {
//       test('Should [reverse cells] when [value is true]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(1, 0), properties: CellProperties()),
//         ];
//
//         // Act
//         List<IndexedCellProperties> reversedCells = cells.maybeReverse(true);
//
//         // Assert
//         expect(reversedCells, isNot(equals(cells)));
//         expect(reversedCells.first.index, CellIndex.raw(1, 0));
//       });
//
//       test('Should [not reverse cells] when [value is false]', () {
//         // Arrange
//         List<IndexedCellProperties> cells = <IndexedCellProperties>[
//           IndexedCellProperties(index: CellIndex.raw(0, 0), properties: CellProperties()),
//           IndexedCellProperties(index: CellIndex.raw(1, 0), properties: CellProperties()),
//         ];
//
//         // Act
//         List<IndexedCellProperties> reversedCells = cells.maybeReverse(false);
//
//         // Assert
//         expect(reversedCells, equals(cells));
//       });
//     });
//   });
// }

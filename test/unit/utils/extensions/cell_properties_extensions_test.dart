import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

void main() {
  group('Tests of CellPropertiesExtensions', () {
    group('Tests of groupByColumns()', () {
      test('Should [group cells by columns]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
          CellProperties(index: CellIndex.raw(1, 0)),
          CellProperties(index: CellIndex.raw(0, 1)),
        ];

        // Act
        Map<ColumnIndex, List<CellProperties>> grouped = cells.groupByColumns();

        // Assert
        expect(grouped.length, 2);
        expect(grouped[ColumnIndex(0)]?.length, 2);
        expect(grouped[ColumnIndex(1)]?.length, 1);
      });

      test('Should [return empty map] when [no cells are provided]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[];

        // Act
        Map<ColumnIndex, List<CellProperties>> grouped = cells.groupByColumns();

        // Assert
        expect(grouped.isEmpty, isTrue);
      });
    });

    group('Tests of whereColumn()', () {
      test('Should [filter cells by column]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
          CellProperties(index: CellIndex.raw(1, 0)),
          CellProperties(index: CellIndex.raw(0, 1)),
        ];

        // Act
        List<CellProperties> columnCells = cells.whereColumn(ColumnIndex(0));

        // Assert
        expect(columnCells.length, 2);
        expect(columnCells.every((CellProperties cell) => cell.index.column == ColumnIndex(0)), isTrue);
      });

      test('Should [return empty list] when [no cells match the column]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
        ];

        // Act
        List<CellProperties> columnCells = cells.whereColumn(ColumnIndex(1));

        // Assert
        expect(columnCells.isEmpty, isTrue);
      });
    });

    group('Tests of groupByRows()', () {
      test('Should [group cells by rows]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
          CellProperties(index: CellIndex.raw(0, 1)),
          CellProperties(index: CellIndex.raw(1, 0)),
        ];

        // Act
        Map<RowIndex, List<CellProperties>> grouped = cells.groupByRows();

        // Assert
        expect(grouped.length, 2);
        expect(grouped[RowIndex(0)]?.length, 2);
        expect(grouped[RowIndex(1)]?.length, 1);
      });

      test('Should [return empty map] when [no cells are provided]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[];

        // Act
        Map<RowIndex, List<CellProperties>> grouped = cells.groupByRows();

        // Assert
        expect(grouped.isEmpty, isTrue);
      });
    });

    group('Tests of whereRow()', () {
      test('Should [filter cells by row]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
          CellProperties(index: CellIndex.raw(0, 1)),
          CellProperties(index: CellIndex.raw(1, 0)),
        ];

        // Act
        List<CellProperties> rowCells = cells.whereRow(RowIndex(0));

        // Assert
        expect(rowCells.length, 2);
        expect(rowCells.every((CellProperties cell) => cell.index.row == RowIndex(0)), isTrue);
      });

      test('Should [return empty list] when [no cells match the row]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
        ];

        // Act
        List<CellProperties> rowCells = cells.whereRow(RowIndex(1));

        // Assert
        expect(rowCells.isEmpty, isTrue);
      });
    });

    group('Tests of maybeReverse()', () {
      test('Should [reverse cells] when [value is true]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
          CellProperties(index: CellIndex.raw(1, 0)),
        ];

        // Act
        List<CellProperties> reversedCells = cells.maybeReverse(true);

        // Assert
        expect(reversedCells, isNot(equals(cells)));
        expect(reversedCells.first.index, CellIndex.raw(1, 0));
      });

      test('Should [not reverse cells] when [value is false]', () {
        // Arrange
        List<CellProperties> cells = <CellProperties>[
          CellProperties(index: CellIndex.raw(0, 0)),
          CellProperties(index: CellIndex.raw(1, 0)),
        ];

        // Act
        List<CellProperties> reversedCells = cells.maybeReverse(false);

        // Assert
        expect(reversedCells, equals(cells));
      });
    });
  });
}

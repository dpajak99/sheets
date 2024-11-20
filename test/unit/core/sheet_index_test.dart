import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';

void main() {
  group('Tests of CellIndex', () {
    group('Tests of CellIndex constructors', () {
      test('Should [create CellIndex] when [using default constructor]', () {
        // Arrange
        RowIndex row = RowIndex(5);
        ColumnIndex column = ColumnIndex(3);

        // Act
        CellIndex cellIndex = CellIndex(row: row, column: column);

        // Assert
        expect(cellIndex.row, equals(row));
        expect(cellIndex.column, equals(column));
      });

      test('Should [create CellIndex] when [using raw constructor]', () {
        // Arrange
        int row = 5;
        int column = 3;

        // Act
        CellIndex cellIndex = CellIndex.raw(row, column);

        // Assert
        expect(cellIndex.row.value, equals(row));
        expect(cellIndex.column.value, equals(column));
      });

      test('Should [create CellIndex from ColumnIndex at min row] when [using fromColumnMin]', () {
        // Arrange
        ColumnIndex column = ColumnIndex(2);

        // Act
        CellIndex cellIndex = CellIndex.fromColumnMin(column);

        // Assert
        expect(cellIndex.row, equals(RowIndex.zero));
        expect(cellIndex.column, equals(column));
      });

      test('Should [create CellIndex from ColumnIndex at max row] when [using fromColumnMax]', () {
        // Arrange
        ColumnIndex column = ColumnIndex(2);

        // Act
        CellIndex cellIndex = CellIndex.fromColumnMax(column);

        // Assert
        expect(cellIndex.row, equals(RowIndex.max));
        expect(cellIndex.column, equals(column));
      });

      test('Should [create CellIndex from RowIndex at min column] when [using fromRowMin]', () {
        // Arrange
        RowIndex row = RowIndex(5);

        // Act
        CellIndex cellIndex = CellIndex.fromRowMin(row);

        // Assert
        expect(cellIndex.row, equals(row));
        expect(cellIndex.column, equals(ColumnIndex.zero));
      });

      test('Should [create CellIndex from RowIndex at max column] when [using fromRowMax]', () {
        // Arrange
        RowIndex row = RowIndex(5);

        // Act
        CellIndex cellIndex = CellIndex.fromRowMax(row);

        // Assert
        expect(cellIndex.row, equals(row));
        expect(cellIndex.column, equals(ColumnIndex.max));
      });
    });

    group('Tests of CellIndex.toRealIndex()', () {
      test('Should [return real index] when [CellIndex has max row and column]', () {
        // Arrange
        SheetDataManager properties = SheetDataManager(data: SheetData(rowCount: 10, columnCount: 15));

        CellIndex cellIndex = CellIndex(row: RowIndex.max, column: ColumnIndex.max);

        // Act
        CellIndex realIndex = cellIndex.toRealIndex(columnCount: 15, rowCount: 10);

        // Assert
        expect(realIndex.row.value, equals(properties.rowCount - 1));
        expect(realIndex.column.value, equals(properties.columnCount - 1));
      });

      test('Should [return same index] when [CellIndex is within bounds]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(7));

        // Act
        CellIndex realIndex = cellIndex.toRealIndex(columnCount: 15, rowCount: 10);

        // Assert
        expect(realIndex.row.value, equals(5));
        expect(realIndex.column.value, equals(7));
      });
    });

    group('Tests of CellIndex.getSheetCoordinates()', () {
      test('Should [return correct Rect] when [calculating sheet coordinates]', () {
        // Arrange
        SheetDataManager properties = SheetDataManager(data: SheetData(rowCount: 3, columnCount: 3));

        CellIndex cellIndex = CellIndex(row: RowIndex(1), column: ColumnIndex(1));

        // Expected values:
        // x = sum of column widths before column 1: 100.0
        // y = sum of row heights before row 1: 21.0
        // width = properties.getColumnWidth(column 1): 100.0
        // height = properties.getRowHeight(row 1): 21.0

        Rect expectedRect = const Rect.fromLTWH(100, 21, 100, 21);

        // Act
        Rect actualRect = cellIndex.getSheetCoordinates(properties);

        // Assert
        expect(actualRect, equals(expectedRect));
      });
    });

    group('Tests of CellIndex.move()', () {
      test('Should [return new CellIndex] when [moved by offsets]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(5));
        int rowOffset = 2;
        int columnOffset = -3;

        // Act
        CellIndex movedIndex = cellIndex.move(dx: columnOffset, dy: rowOffset);

        // Assert
        expect(movedIndex.row.value, equals(7));
        expect(movedIndex.column.value, equals(2));
      });

      test('Should [clamp to zero] when [resulting index is negative]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(1), column: ColumnIndex(1));
        int rowOffset = -5;
        int columnOffset = -5;

        // Act
        CellIndex movedIndex = cellIndex.move(dx: columnOffset, dy: rowOffset);

        // Assert
        expect(movedIndex.row.value, equals(0));
        expect(movedIndex.column.value, equals(0));
      });
    });

    group('Tests of CellIndex.clamp()', () {
      test('Should [clamp to max index] when [current index exceeds max]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(10), column: ColumnIndex(10));
        CellIndex maxIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(5));

        // Act
        CellIndex clampedIndex = cellIndex.clamp(maxIndex);

        // Assert
        expect(clampedIndex.row.value, equals(5));
        expect(clampedIndex.column.value, equals(5));
      });

      test('Should [remain the same] when [current index is within max]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(3), column: ColumnIndex(4));
        CellIndex maxIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(5));

        // Act
        CellIndex clampedIndex = cellIndex.clamp(maxIndex);

        // Assert
        expect(clampedIndex, equals(cellIndex));
      });
    });

    group('Tests of CellIndex.stringifyPosition()', () {
      test('Should [return correct string representation] of position', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(0));

        // Act
        String positionString = cellIndex.stringifyPosition();

        // Assert
        expect(positionString, equals('A1')); // Column A, Row 1
      });

      test('Should [handle multi-letter columns]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(4), column: ColumnIndex(27));

        // Act
        String positionString = cellIndex.stringifyPosition();

        // Assert
        expect(positionString, equals('AB5')); // Column AB, Row 5
      });
    });

    group('Tests of CellIndex.toString()', () {
      test('Should [return same as stringifyPosition()]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(0), column: ColumnIndex(0));

        // Act
        String toStringResult = cellIndex.toString();
        String expectedString = cellIndex.stringifyPosition();

        // Assert
        expect(toStringResult, equals(expectedString));
      });
    });

    group('Tests of CellIndex.toCellIndex()', () {
      test('Should [return self] when [called on CellIndex]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(2), column: ColumnIndex(3));

        // Act
        CellIndex result = cellIndex.toCellIndex();

        // Assert
        expect(result, equals(cellIndex));
      });
    });

    group('Tests of CellIndex Equatable implementation', () {
      test('Should [be equal] when [row and column are equal]', () {
        // Arrange
        CellIndex cellIndex1 = CellIndex(row: RowIndex(5), column: ColumnIndex(5));
        CellIndex cellIndex2 = CellIndex(row: RowIndex(5), column: ColumnIndex(5));

        // Act & Assert
        expect(cellIndex1, equals(cellIndex2));
      });

      test('Should [not be equal] when [row or column differ]', () {
        // Arrange
        CellIndex cellIndex1 = CellIndex(row: RowIndex(5), column: ColumnIndex(5));
        CellIndex cellIndex2 = CellIndex(row: RowIndex(5), column: ColumnIndex(6));
        CellIndex cellIndex3 = CellIndex(row: RowIndex(6), column: ColumnIndex(5));

        // Act & Assert
        expect(cellIndex1, isNot(equals(cellIndex2)));
        expect(cellIndex1, isNot(equals(cellIndex3)));
      });
    });
  });

  group('Tests of RowIndex', () {
    group('Tests of RowIndex constructor', () {
      test('Should [create RowIndex] with given value', () {
        // Arrange
        int value = 5;

        // Act
        RowIndex rowIndex = RowIndex(value);

        // Assert
        expect(rowIndex.value, equals(value));
      });
    });

    group('Tests of RowIndex.toRealIndex()', () {
      test('Should [return real index] when [RowIndex is max]', () {
        // Arrange
        SheetDataManager properties = SheetDataManager(data: SheetData(rowCount: 10, columnCount: 15));

        RowIndex rowIndex = RowIndex.max;

        // Act
        RowIndex realIndex = rowIndex.toRealIndex(rowCount: 10);

        // Assert
        expect(realIndex.value, equals(properties.rowCount - 1));
      });

      test('Should [return same index] when [RowIndex is within bounds]', () {
        // Arrange
        RowIndex rowIndex = RowIndex(7);

        // Act
        RowIndex realIndex = rowIndex.toRealIndex(rowCount: 10);

        // Assert
        expect(realIndex.value, equals(7));
      });
    });

    group('Tests of RowIndex.getSheetCoordinates()', () {
      test('Should [return correct Rect] when [calculating sheet coordinates]', () {
        // Arrange
        SheetDataManager properties = SheetDataManager(
          data: SheetData(
            rowCount: 3,
            columnCount: 3,
            customRowStyles: <RowIndex, RowStyle>{
              RowIndex(0): RowStyle(height: 20),
              RowIndex(1): RowStyle(height: 30),
              RowIndex(2): RowStyle(height: 25),
            },
          ),
        );

        RowIndex rowIndex = RowIndex(1);

        // Expected values:
        // y = sum of row heights before row 1: 20.0
        // height = properties.getRowHeight(row 1): 30.0
        // x = 0
        // width = rowHeadersWidth

        Rect expectedRect = Rect.fromLTWH(0, 20, rowHeadersWidth, 30);

        // Act
        Rect actualRect = rowIndex.getSheetCoordinates(properties);

        // Assert
        expect(actualRect, equals(expectedRect));
      });
    });

    group('Tests of RowIndex.move()', () {
      test('Should [return new RowIndex] when [moved by number]', () {
        // Arrange
        RowIndex rowIndex = RowIndex(5);
        int number = 3;

        // Act
        RowIndex movedIndex = rowIndex.move(number);

        // Assert
        expect(movedIndex.value, equals(8));
      });
    });

    group('Tests of RowIndex.stringifyPosition()', () {
      test('Should [return correct string representation] of row', () {
        // Arrange
        RowIndex rowIndex = RowIndex(0);

        // Act
        String positionString = rowIndex.stringifyPosition();

        // Assert
        expect(positionString, equals('1'));
      });
    });

    group('Tests of RowIndex.clamp()', () {
      test('Should [clamp to max index] when [value exceeds max]', () {
        // Arrange
        RowIndex rowIndex = RowIndex(10);
        RowIndex maxIndex = RowIndex(5);

        // Act
        RowIndex clampedIndex = rowIndex.clamp(maxIndex);

        // Assert
        expect(clampedIndex.value, equals(5));
      });

      test('Should [remain the same] when [value is within max]', () {
        // Arrange
        RowIndex rowIndex = RowIndex(3);
        RowIndex maxIndex = RowIndex(5);

        // Act
        RowIndex clampedIndex = rowIndex.clamp(maxIndex);

        // Assert
        expect(clampedIndex, equals(rowIndex));
      });
    });

    group('Tests of RowIndex.compareTo()', () {
      test('Should [return 0] when [values are equal]', () {
        // Arrange
        RowIndex index1 = RowIndex(5);
        RowIndex index2 = RowIndex(5);

        // Act
        int comparison = index1.compareTo(index2);

        // Assert
        expect(comparison, equals(0));
      });

      test('Should [return negative] when [this value is less than other]', () {
        // Arrange
        RowIndex index1 = RowIndex(3);
        RowIndex index2 = RowIndex(5);

        // Act
        int comparison = index1.compareTo(index2);

        // Assert
        expect(comparison, lessThan(0));
      });

      test('Should [return positive] when [this value is greater than other]', () {
        // Arrange
        RowIndex index1 = RowIndex(7);
        RowIndex index2 = RowIndex(5);

        // Act
        int comparison = index1.compareTo(index2);

        // Assert
        expect(comparison, greaterThan(0));
      });
    });

    group('Tests of RowIndex Equatable implementation', () {
      test('Should [be equal] when [values are equal]', () {
        // Arrange
        RowIndex index1 = RowIndex(5);
        RowIndex index2 = RowIndex(5);

        // Act & Assert
        expect(index1, equals(index2));
      });

      test('Should [not be equal] when [values differ]', () {
        // Arrange
        RowIndex index1 = RowIndex(5);
        RowIndex index2 = RowIndex(6);

        // Act & Assert
        expect(index1, isNot(equals(index2)));
      });
    });
  });

  group('Tests of ColumnIndex', () {
    group('Tests of ColumnIndex constructor', () {
      test('Should [create ColumnIndex] with given value', () {
        // Arrange
        int value = 5;

        // Act
        ColumnIndex columnIndex = ColumnIndex(value);

        // Assert
        expect(columnIndex.value, equals(value));
      });
    });

    group('Tests of ColumnIndex.toRealIndex()', () {
      test('Should [return real index] when [ColumnIndex is max]', () {
        // Arrange
        SheetDataManager properties = SheetDataManager(data: SheetData(rowCount: 10, columnCount: 15));

        ColumnIndex columnIndex = ColumnIndex.max;

        // Act
        ColumnIndex realIndex = columnIndex.toRealIndex(columnCount: 15);

        // Assert
        expect(realIndex.value, equals(properties.columnCount - 1));
      });

      test('Should [return same index] when [ColumnIndex is within bounds]', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(7);

        // Act
        ColumnIndex realIndex = columnIndex.toRealIndex(columnCount: 15);

        // Assert
        expect(realIndex.value, equals(7));
      });
    });

    group('Tests of ColumnIndex.getSheetCoordinates()', () {
      test('Should [return correct Rect] when [calculating sheet coordinates]', () {
        // Arrange
        SheetDataManager properties = SheetDataManager(
          data: SheetData(
            rowCount: 3,
            columnCount: 3,
            customColumnStyles: <ColumnIndex, ColumnStyle>{
              ColumnIndex(0): ColumnStyle(width: 50),
              ColumnIndex(1): ColumnStyle(width: 60),
              ColumnIndex(2): ColumnStyle(width: 55),
            },
          ),
        );

        ColumnIndex columnIndex = ColumnIndex(1);

        // Expected values:
        // x = sum of column widths before column 1: 50.0
        // width = properties.getColumnWidth(column 1): 60.0
        // y = 0
        // height = columnHeadersHeight

        Rect expectedRect = Rect.fromLTWH(50, 0, 60, columnHeadersHeight);

        // Act
        Rect actualRect = columnIndex.getSheetCoordinates(properties);

        // Assert
        expect(actualRect, equals(expectedRect));
      });
    });

    group('Tests of ColumnIndex.operator -', () {
      test('Should [subtract number from ColumnIndex value]', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(5);
        int number = 2;

        // Act
        ColumnIndex resultIndex = columnIndex - number;

        // Assert
        expect(resultIndex.value, equals(3));
      });
    });

    group('Tests of ColumnIndex.move()', () {
      test('Should [return new ColumnIndex] when [moved by number]', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(5);
        int number = 3;

        // Act
        ColumnIndex movedIndex = columnIndex.move(number);

        // Assert
        expect(movedIndex.value, equals(8));
      });
    });

    group('Tests of ColumnIndex.stringifyPosition()', () {
      test('Should [return correct string representation] of column', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(0);

        // Act
        String positionString = columnIndex.stringifyPosition();

        // Assert
        expect(positionString, equals('A'));
      });

      test('Should [handle multi-letter columns]', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(27);

        // Act
        String positionString = columnIndex.stringifyPosition();

        // Assert
        expect(positionString, equals('AB'));
      });
    });

    group('Tests of ColumnIndex.clamp()', () {
      test('Should [clamp to max index] when [value exceeds max]', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(10);
        ColumnIndex maxIndex = ColumnIndex(5);

        // Act
        ColumnIndex clampedIndex = columnIndex.clamp(maxIndex);

        // Assert
        expect(clampedIndex.value, equals(5));
      });

      test('Should [remain the same] when [value is within max]', () {
        // Arrange
        ColumnIndex columnIndex = ColumnIndex(3);
        ColumnIndex maxIndex = ColumnIndex(5);

        // Act
        ColumnIndex clampedIndex = columnIndex.clamp(maxIndex);

        // Assert
        expect(clampedIndex, equals(columnIndex));
      });
    });

    group('Tests of ColumnIndex.compareTo()', () {
      test('Should [return 0] when [values are equal]', () {
        // Arrange
        ColumnIndex index1 = ColumnIndex(5);
        ColumnIndex index2 = ColumnIndex(5);

        // Act
        int comparison = index1.compareTo(index2);

        // Assert
        expect(comparison, equals(0));
      });

      test('Should [return negative] when [this value is less than other]', () {
        // Arrange
        ColumnIndex index1 = ColumnIndex(3);
        ColumnIndex index2 = ColumnIndex(5);

        // Act
        int comparison = index1.compareTo(index2);

        // Assert
        expect(comparison, lessThan(0));
      });

      test('Should [return positive] when [this value is greater than other]', () {
        // Arrange
        ColumnIndex index1 = ColumnIndex(7);
        ColumnIndex index2 = ColumnIndex(5);

        // Act
        int comparison = index1.compareTo(index2);

        // Assert
        expect(comparison, greaterThan(0));
      });
    });

    group('Tests of ColumnIndex Equatable implementation', () {
      test('Should [be equal] when [values are equal]', () {
        // Arrange
        ColumnIndex index1 = ColumnIndex(5);
        ColumnIndex index2 = ColumnIndex(5);

        // Act & Assert
        expect(index1, equals(index2));
      });

      test('Should [not be equal] when [values differ]', () {
        // Arrange
        ColumnIndex index1 = ColumnIndex(5);
        ColumnIndex index2 = ColumnIndex(6);

        // Act & Assert
        expect(index1, isNot(equals(index2)));
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of ClosestVisible<T>', () {
    group('Tests of ClosestVisible.fullyVisible()', () {
      test('Should [create a fully visible ClosestVisible] when [value is provided]', () {
        // Arrange
        int value = 42;

        // Act
        ClosestVisible<int> closestVisible = ClosestVisible<int>.fullyVisible(value);

        // Assert
        expect(closestVisible.value, equals(value));
        expect(closestVisible.hiddenBorders, isEmpty);
      });

      test('Should [work with complex types] when [value is an object]', () {
        // Arrange
        CellIndex cellIndex = CellIndex(row: RowIndex(5), column: ColumnIndex(3));

        // Act
        ClosestVisible<CellIndex> closestVisible = ClosestVisible<CellIndex>.fullyVisible(cellIndex);

        // Assert
        expect(closestVisible.value, equals(cellIndex));
        expect(closestVisible.hiddenBorders, isEmpty);
      });
    });

    group('Tests of ClosestVisible.partiallyVisible()', () {
      test('Should [create a partially visible ClosestVisible] when [hiddenBorders and value are provided]', () {
        // Arrange
        int value = 42;
        List<Direction> hiddenBorders = <Direction>[Direction.top, Direction.left];

        // Act
        ClosestVisible<int> closestVisible = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: hiddenBorders,
          value: value,
        );

        // Assert
        expect(closestVisible.value, equals(value));
        expect(closestVisible.hiddenBorders, equals(hiddenBorders));
      });

      test('Should [allow empty hiddenBorders] when [creating partially visible ClosestVisible]', () {
        // Arrange
        int value = 42;
        List<Direction> hiddenBorders = <Direction>[];

        // Act
        ClosestVisible<int> closestVisible = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: hiddenBorders,
          value: value,
        );

        // Assert
        expect(closestVisible.value, equals(value));
        expect(closestVisible.hiddenBorders, isEmpty);
      });
    });

    group('Tests of ClosestVisible.combineCellIndex()', () {
      test('Should [combine hiddenBorders and create ClosestVisible<CellIndex>] when [rowIndex and columnIndex are provided]',
          () {
        // Arrange
        RowIndex rowIndexValue = RowIndex(5);
        ColumnIndex columnIndexValue = ColumnIndex(3);

        ClosestVisible<RowIndex> rowIndexClosest = ClosestVisible<RowIndex>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: rowIndexValue,
        );

        ClosestVisible<ColumnIndex> columnIndexClosest = ClosestVisible<ColumnIndex>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.left],
          value: columnIndexValue,
        );

        // Act
        ClosestVisible<CellIndex> cellIndexClosest = ClosestVisible.combineCellIndex(rowIndexClosest, columnIndexClosest);

        // Assert
        expect(cellIndexClosest.value.row, equals(rowIndexValue));
        expect(cellIndexClosest.value.column, equals(columnIndexValue));
        expect(cellIndexClosest.hiddenBorders, containsAll(<Direction>[Direction.top, Direction.left]));
      });

      test('Should [create fully visible ClosestVisible<CellIndex>] when [both rowIndex and columnIndex are fully visible]', () {
        // Arrange
        RowIndex rowIndexValue = RowIndex(5);
        ColumnIndex columnIndexValue = ColumnIndex(3);

        ClosestVisible<RowIndex> rowIndexClosest = ClosestVisible<RowIndex>.fullyVisible(rowIndexValue);
        ClosestVisible<ColumnIndex> columnIndexClosest = ClosestVisible<ColumnIndex>.fullyVisible(columnIndexValue);

        // Act
        ClosestVisible<CellIndex> cellIndexClosest = ClosestVisible.combineCellIndex(rowIndexClosest, columnIndexClosest);

        // Assert
        expect(cellIndexClosest.value.row, equals(rowIndexValue));
        expect(cellIndexClosest.value.column, equals(columnIndexValue));
        expect(cellIndexClosest.hiddenBorders, isEmpty);
      });

      test('Should [combine hiddenBorders correctly] when [hiddenBorders are empty in one of the indices]', () {
        // Arrange
        RowIndex rowIndexValue = RowIndex(5);
        ColumnIndex columnIndexValue = ColumnIndex(3);

        ClosestVisible<RowIndex> rowIndexClosest = ClosestVisible<RowIndex>.fullyVisible(rowIndexValue);
        ClosestVisible<ColumnIndex> columnIndexClosest = ClosestVisible<ColumnIndex>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.right],
          value: columnIndexValue,
        );

        // Act
        ClosestVisible<CellIndex> cellIndexClosest = ClosestVisible.combineCellIndex(rowIndexClosest, columnIndexClosest);

        // Assert
        expect(cellIndexClosest.value.row, equals(rowIndexValue));
        expect(cellIndexClosest.value.column, equals(columnIndexValue));
        expect(cellIndexClosest.hiddenBorders, contains(Direction.right));
        expect(cellIndexClosest.hiddenBorders.length, equals(1));
      });
    });

    group('Tests of Equatable implementation', () {
      test('Should [be equal] when [hiddenBorders and value are equal]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 42,
        );
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 42,
        );

        // Act & Assert
        expect(closestVisible1, equals(closestVisible2));
      });

      test('Should [not be equal] when [hiddenBorders differ]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 42,
        );
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.left],
          value: 42,
        );

        // Act & Assert
        expect(closestVisible1, isNot(equals(closestVisible2)));
      });

      test('Should [not be equal] when [values differ]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 42,
        );
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 43,
        );

        // Act & Assert
        expect(closestVisible1, isNot(equals(closestVisible2)));
      });

      test('Should [not be equal] when [both hiddenBorders and values differ]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 42,
        );
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.left],
          value: 43,
        );

        // Act & Assert
        expect(closestVisible1, isNot(equals(closestVisible2)));
      });

      test('Should [be equal] when [both are fully visible with same value]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.fullyVisible(42);
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.fullyVisible(42);

        // Act & Assert
        expect(closestVisible1, equals(closestVisible2));
      });

      test('Should [not be equal] when [one is fully visible and one is partially visible]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.fullyVisible(42);
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[Direction.top],
          value: 42,
        );

        // Act & Assert
        expect(closestVisible1, isNot(equals(closestVisible2)));
      });

      test('Should [be equal] when [hiddenBorders are empty and values are equal]', () {
        // Arrange
        ClosestVisible<int> closestVisible1 = ClosestVisible<int>.partiallyVisible(
          hiddenBorders: <Direction>[],
          value: 42,
        );
        ClosestVisible<int> closestVisible2 = ClosestVisible<int>.fullyVisible(42);

        // Act & Assert
        expect(closestVisible1, equals(closestVisible2));
      });
    });
  });
}

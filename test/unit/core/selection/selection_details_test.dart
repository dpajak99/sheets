import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_details.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';

void main() {
  group('Tests of SelectionStartDetails', () {
    group('Tests of SelectionEndDetails.cell getter', () {
      test('Should [return given CellIndex] when index is CellIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(CellIndex.raw(1, 1));

        // Assert
        expect(actualDetails.cell, equals(CellIndex.raw(1, 1)));
      });

      test('Should [return CellIndex (min)] when index is ColumnIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(ColumnIndex(1));

        // Assert
        expect(actualDetails.cell, equals(CellIndex.raw(0, 1)));
      });

      test('Should [return CellIndex (min)] when index is RowIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(RowIndex(1));

        // Assert
        expect(actualDetails.cell, equals(CellIndex.raw(1, 0)));
      });
    });

    group('Tests of SelectionEndDetails.column getter', () {
      test('Should [return ColumnIndex] when index is CellIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(CellIndex.raw(1, 1));

        // Assert
        expect(actualDetails.column, equals(ColumnIndex(1)));
      });

      test('Should [return given ColumnIndex] when index is ColumnIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(ColumnIndex(1));

        // Assert
        expect(actualDetails.column, equals(ColumnIndex(1)));
      });

      test('Should [return ColumnIndex.zero] when index is RowIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(RowIndex(1));

        // Assert
        expect(actualDetails.column, equals(ColumnIndex.zero));
      });
    });

    group('Tests of SelectionEndDetails.row getter', () {
      test('Should [return RowIndex] when index is CellIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(CellIndex.raw(1, 1));

        // Assert
        expect(actualDetails.row, equals(RowIndex(1)));
      });

      test('Should [return RowIndex.zero] when index is ColumnIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(ColumnIndex(1));

        // Assert
        expect(actualDetails.row, equals(RowIndex.zero));
      });

      test('Should [return given RowIndex] when index is RowIndex', () {
        // Act
        SelectionStartDetails actualDetails = SelectionStartDetails(RowIndex(1));

        // Assert
        expect(actualDetails.row, equals(RowIndex(1)));
      });
    });
  });

  group('Tests of SelectionEndDetails', () {
    group('Tests of SelectionEndDetails.cell getter', () {
      test('Should [return given CellIndex] when index is CellIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(CellIndex.raw(1, 1));

        // Assert
        expect(actualDetails.cell, equals(CellIndex.raw(1, 1)));
      });

      test('Should [return CellIndex (max)] when index is ColumnIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(ColumnIndex(1));

        // Assert
        expect(actualDetails.cell, equals(CellIndex.raw(Int.max, 1)));
      });

      test('Should [return CellIndex (max)] when index is RowIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(RowIndex(1));

        // Assert
        expect(actualDetails.cell, equals(CellIndex.raw(1, Int.max)));
      });
    });

    group('Tests of SelectionEndDetails.column getter', () {
      test('Should [return ColumnIndex] when index is CellIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(CellIndex.raw(1, 1));

        // Assert
        expect(actualDetails.column, equals(ColumnIndex(1)));
      });

      test('Should [return given ColumnIndex] when index is ColumnIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(ColumnIndex(1));

        // Assert
        expect(actualDetails.column, equals(ColumnIndex(1)));
      });

      test('Should [return ColumnIndex.max] when index is RowIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(RowIndex(1));

        // Assert
        expect(actualDetails.column, equals(ColumnIndex.max));
      });
    });

    group('Tests of SelectionEndDetails.row getter', () {
      test('Should [return RowIndex] when index is CellIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(CellIndex.raw(1, 1));

        // Assert
        expect(actualDetails.row, equals(RowIndex(1)));
      });

      test('Should [return RowIndex.max] when index is ColumnIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(ColumnIndex(1));

        // Assert
        expect(actualDetails.row, equals(RowIndex.max));
      });

      test('Should [return given RowIndex] when index is RowIndex', () {
        // Act
        SelectionEndDetails actualDetails = SelectionEndDetails(RowIndex(1));

        // Assert
        expect(actualDetails.row, equals(RowIndex(1)));
      });
    });
  });
}

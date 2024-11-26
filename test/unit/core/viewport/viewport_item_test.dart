import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

void main() {
  group('Tests of ViewportCell', () {
    group('Tests of ViewportCell constructor', () {
      test('Should [create ViewportCell] with given parameters', () {
        // Arrange
        CellIndex index = CellIndex(row: RowIndex(5), column: ColumnIndex(3));
        RowStyle rowStyle = RowStyle.defaults();
        ColumnStyle columnStyle = ColumnStyle.defaults();
        ViewportRow viewportRow = ViewportRow(
          rect: const BorderRect.fromLTWH(0, 100, 100, 20),
          index: index.row,
          style: rowStyle,
        );
        ViewportColumn viewportColumn = ViewportColumn(
          rect: const BorderRect.fromLTWH(50, 0, 50, 100),
          index: index.column,
          style: columnStyle,
        );
        String value = 'Test Value';

        // Act
        ViewportCell viewportCell = ViewportCell(
          row: viewportRow,
          column: viewportColumn,
          properties: CellProperties(value: SheetRichText.single(text: value), style: CellStyle()),
        );

        // Assert
        BorderRect expectedRect = const BorderRect.fromLTRB(50, 100, 100, 120);

        expect(viewportCell.rect, equals(expectedRect));
        expect(viewportCell.index, equals(index));
      });
    });

    group('Tests of ViewportCell.getSheetRect()', () {
      test('Should [return adjusted Rect] when [scrollOffset is applied]', () {
        // Arrange
        CellIndex index = CellIndex(row: RowIndex(5), column: ColumnIndex(3));
        RowStyle rowStyle = RowStyle.defaults();
        ColumnStyle columnStyle = ColumnStyle.defaults();
        ViewportRow viewportRow = ViewportRow(
          rect: const BorderRect.fromLTWH(0, 100, 100, 20),
          index: index.row,
          style: rowStyle,
        );
        ViewportColumn viewportColumn = ViewportColumn(
          rect: const BorderRect.fromLTWH(50, 0, 50, 100),
          index: index.column,
          style: columnStyle,
        );
        String value = 'Test Value';

        // Act
        ViewportCell viewportCell = ViewportCell(
          row: viewportRow,
          column: viewportColumn,
          properties: CellProperties(value: SheetRichText.single(text: value), style: CellStyle()),
        );

        // Act
        Rect sheetRect = viewportCell.getSheetRect(const Offset(10, 15));

        // Assert
        Rect expectedRect = Rect.fromLTWH(
          viewportColumn.rect.left + 10,
          viewportRow.rect.top + 15,
          viewportColumn.rect.width,
          viewportRow.rect.height,
        );

        expect(sheetRect, equals(expectedRect));
      });
    });
  });

  group('Tests of ViewportRow', () {
    group('Tests of ViewportRow constructor', () {
      test('Should [create ViewportRow] with given parameters', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 100, 20);
        RowIndex index = RowIndex(5);
        RowStyle style = RowStyle.defaults();

        // Act
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, style: style);

        // Assert
        expect(viewportRow.rect, equals(rect));
        expect(viewportRow.index, equals(index));
        expect(viewportRow.style, equals(style));
      });
    });

    group('Tests of ViewportRow.value getter', () {
      test('Should [return string representation] of row index plus one', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 100, 20);
        RowIndex index = RowIndex(5);
        RowStyle style = RowStyle.defaults();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, style: style);

        // Act
        String value = viewportRow.value;

        // Assert
        expect(value, equals('6')); // index.value + 1
      });
    });

    group('Tests of ViewportRow.index getter', () {
      test('Should [return the stored RowIndex]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 100, 20);
        RowIndex index = RowIndex(3);
        RowStyle style = RowStyle.defaults();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, style: style);

        // Act
        RowIndex retrievedIndex = viewportRow.index;

        // Assert
        expect(retrievedIndex, equals(index));
      });
    });

    group('Tests of ViewportRow.style getter', () {
      test('Should [return the stored RowStyle]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 100, 20);
        RowIndex index = RowIndex(3);
        RowStyle style = RowStyle.defaults();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, style: style);

        // Act
        RowStyle retrievedStyle = viewportRow.style;

        // Assert
        expect(retrievedStyle, equals(style));
      });
    });

    group('Tests of ViewportRow.getSheetRect()', () {
      test('Should [return adjusted Rect] when [scrollOffset is applied]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(50, 100, 100, 20);
        RowIndex index = RowIndex(5);
        RowStyle style = RowStyle.defaults();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, style: style);
        Offset scrollOffset = const Offset(-10, -20);

        // Act
        Rect sheetRect = viewportRow.getSheetRect(scrollOffset);

        // Assert
        Rect expectedRect = const Rect.fromLTWH(40, 80, 100, 20);
        expect(sheetRect, equals(expectedRect));
      });
    });
  });

  group('Tests of ViewportColumn', () {
    group('Tests of ViewportColumn constructor', () {
      test('Should [create ViewportColumn] with given parameters', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnIndex index = ColumnIndex(5);
        ColumnStyle style = ColumnStyle.defaults();

        // Act
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, style: style);

        // Assert
        expect(viewportColumn.rect, equals(rect));
        expect(viewportColumn.index, equals(index));
        expect(viewportColumn.style, equals(style));
      });
    });

    group('Tests of ViewportColumn.value getter', () {
      test('Should [return Excel-style column label] for given index', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnStyle style = ColumnStyle.defaults();

        // Test for index 0 (should be 'A')
        ColumnIndex indexA = ColumnIndex(0);
        ViewportColumn viewportColumnA = ViewportColumn(rect: rect, index: indexA, style: style);
        expect(viewportColumnA.value, equals('A'));

        // Test for index 25 (should be 'Z')
        ColumnIndex indexZ = ColumnIndex(25);
        ViewportColumn viewportColumnZ = ViewportColumn(rect: rect, index: indexZ, style: style);
        expect(viewportColumnZ.value, equals('Z'));

        // Test for index 26 (should be 'AA')
        ColumnIndex indexAA = ColumnIndex(26);
        ViewportColumn viewportColumnAA = ViewportColumn(rect: rect, index: indexAA, style: style);
        expect(viewportColumnAA.value, equals('AA'));

        // Test for index 27 (should be 'AB')
        ColumnIndex indexAB = ColumnIndex(27);
        ViewportColumn viewportColumnAB = ViewportColumn(rect: rect, index: indexAB, style: style);
        expect(viewportColumnAB.value, equals('AB'));
      });
    });

    group('Tests of ViewportColumn.numberToExcelColumn()', () {
      test('Should [return correct Excel-style column label] for given number', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnIndex index = ColumnIndex(0);
        ColumnStyle style = ColumnStyle.defaults();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, style: style);

        // Act & Assert
        expect(viewportColumn.numberToExcelColumn(1), equals('A'));
        expect(viewportColumn.numberToExcelColumn(26), equals('Z'));
        expect(viewportColumn.numberToExcelColumn(27), equals('AA'));
        expect(viewportColumn.numberToExcelColumn(52), equals('AZ'));
        expect(viewportColumn.numberToExcelColumn(53), equals('BA'));
      });
    });

    group('Tests of ViewportColumn.index getter', () {
      test('Should [return the stored ColumnIndex]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnIndex index = ColumnIndex(3);
        ColumnStyle style = ColumnStyle.defaults();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, style: style);

        // Act
        ColumnIndex retrievedIndex = viewportColumn.index;

        // Assert
        expect(retrievedIndex, equals(index));
      });
    });

    group('Tests of ViewportColumn.style getter', () {
      test('Should [return the stored ColumnStyle]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnIndex index = ColumnIndex(3);
        ColumnStyle style = ColumnStyle.defaults();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, style: style);

        // Act
        ColumnStyle retrievedStyle = viewportColumn.style;

        // Assert
        expect(retrievedStyle, equals(style));
      });
    });

    group('Tests of ViewportColumn.getSheetRect()', () {
      test('Should [return adjusted Rect] when [scrollOffset is applied]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(50, 100, 50, 20);
        ColumnIndex index = ColumnIndex(5);
        ColumnStyle style = ColumnStyle.defaults();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, style: style);
        Offset scrollOffset = const Offset(-10, -20);

        // Act
        Rect sheetRect = viewportColumn.getSheetRect(scrollOffset);

        // Assert
        Rect expectedRect = const Rect.fromLTWH(40, 80, 50, 20);
        expect(sheetRect, equals(expectedRect));
      });
    });
  });
}

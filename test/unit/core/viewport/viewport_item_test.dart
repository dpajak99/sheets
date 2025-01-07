import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

void main() {
  group('Tests of ViewportCell', () {
    group('Tests of ViewportCell constructor', () {
      test('Should [create ViewportCell] with given parameters', () {
        // Arrange
        CellIndex index = CellIndex(row: RowIndex(5), column: ColumnIndex(3));
        RowConfig rowConfig = const RowConfig();
        ColumnConfig columnConfig = const ColumnConfig();
        ViewportRow viewportRow = ViewportRow(
          rect: const BorderRect.fromLTWH(0, 100, 100, 20),
          index: index.row,
          config: rowConfig,
        );
        ViewportColumn viewportColumn = ViewportColumn(
          rect: const BorderRect.fromLTWH(50, 0, 50, 100),
          index: index.column,
          config: columnConfig,
        );
        String value = 'Test Value';

        // Act
        ViewportCell viewportCell = ViewportCell(
          row: viewportRow,
          column: viewportColumn,
          properties: CellProperties(
            index: index,
            value: SheetRichText.single(text: value),
            style: CellStyle(),
          ),
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
        RowConfig rowConfig = const RowConfig();
        ColumnConfig columnConfig = const ColumnConfig();
        ViewportRow viewportRow = ViewportRow(
          rect: const BorderRect.fromLTWH(0, 100, 100, 20),
          index: index.row,
          config: rowConfig,
        );
        ViewportColumn viewportColumn = ViewportColumn(
          rect: const BorderRect.fromLTWH(50, 0, 50, 100),
          index: index.column,
          config: columnConfig,
        );
        String value = 'Test Value';

        // Act
        ViewportCell viewportCell = ViewportCell(
          row: viewportRow,
          column: viewportColumn,
          properties: CellProperties(
            index: index,
            value: SheetRichText.single(text: value),
            style: CellStyle(),
          ),
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
        RowConfig config = const RowConfig();

        // Act
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, config: config);

        // Assert
        expect(viewportRow.rect, equals(rect));
        expect(viewportRow.index, equals(index));
        expect(viewportRow.config, equals(config));
      });
    });

    group('Tests of ViewportRow.value getter', () {
      test('Should [return string representation] of row index plus one', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 100, 20);
        RowIndex index = RowIndex(5);
        RowConfig config = const RowConfig();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, config: config);

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
        RowConfig config = const RowConfig();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, config: config);

        // Act
        RowIndex retrievedIndex = viewportRow.index;

        // Assert
        expect(retrievedIndex, equals(index));
      });
    });

    group('Tests of ViewportRow.rowConfig getter', () {
      test('Should [return the stored RowConfig]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 100, 20);
        RowIndex index = RowIndex(3);
        RowConfig config = const RowConfig();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, config: config);

        // Act
        RowConfig retrievedStyle = viewportRow.config;

        // Assert
        expect(retrievedStyle, equals(config));
      });
    });

    group('Tests of ViewportRow.getSheetRect()', () {
      test('Should [return adjusted Rect] when [scrollOffset is applied]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(50, 100, 100, 20);
        RowIndex index = RowIndex(5);
        RowConfig config = const RowConfig();
        ViewportRow viewportRow = ViewportRow(rect: rect, index: index, config: config);
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
        ColumnConfig config = const ColumnConfig();

        // Act
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, config: config);

        // Assert
        expect(viewportColumn.rect, equals(rect));
        expect(viewportColumn.index, equals(index));
        expect(viewportColumn.style, equals(config));
      });
    });

    group('Tests of ViewportColumn.value getter', () {
      test('Should [return Excel-rowConfig column label] for given index', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnConfig config = const ColumnConfig();

        // Test for index 0 (should be 'A')
        ColumnIndex indexA = ColumnIndex(0);
        ViewportColumn viewportColumnA = ViewportColumn(rect: rect, index: indexA, config: config);
        expect(viewportColumnA.value, equals('A'));

        // Test for index 25 (should be 'Z')
        ColumnIndex indexZ = ColumnIndex(25);
        ViewportColumn viewportColumnZ = ViewportColumn(rect: rect, index: indexZ, config: config);
        expect(viewportColumnZ.value, equals('Z'));

        // Test for index 26 (should be 'AA')
        ColumnIndex indexAA = ColumnIndex(26);
        ViewportColumn viewportColumnAA = ViewportColumn(rect: rect, index: indexAA, config: config);
        expect(viewportColumnAA.value, equals('AA'));

        // Test for index 27 (should be 'AB')
        ColumnIndex indexAB = ColumnIndex(27);
        ViewportColumn viewportColumnAB = ViewportColumn(rect: rect, index: indexAB, config: config);
        expect(viewportColumnAB.value, equals('AB'));
      });
    });

    group('Tests of ViewportColumn.numberToExcelColumn()', () {
      test('Should [return correct Excel-rowConfig column label] for given number', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnIndex index = ColumnIndex(0);
        ColumnConfig config = const ColumnConfig();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, config: config);

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
        ColumnConfig config = const ColumnConfig();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, config: config);

        // Act
        ColumnIndex retrievedIndex = viewportColumn.index;

        // Assert
        expect(retrievedIndex, equals(index));
      });
    });

    group('Tests of ViewportColumn.rowConfig getter', () {
      test('Should [return the stored ColumnConfig]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(0, 0, 50, 20);
        ColumnIndex index = ColumnIndex(3);
        ColumnConfig config = const ColumnConfig();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, config: config);

        // Act
        ColumnConfig retrievedStyle = viewportColumn.style;

        // Assert
        expect(retrievedStyle, equals(config));
      });
    });

    group('Tests of ViewportColumn.getSheetRect()', () {
      test('Should [return adjusted Rect] when [scrollOffset is applied]', () {
        // Arrange
        BorderRect rect = const BorderRect.fromLTWH(50, 100, 50, 20);
        ColumnIndex index = ColumnIndex(5);
        ColumnConfig config = const ColumnConfig();
        ViewportColumn viewportColumn = ViewportColumn(rect: rect, index: index, config: config);
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

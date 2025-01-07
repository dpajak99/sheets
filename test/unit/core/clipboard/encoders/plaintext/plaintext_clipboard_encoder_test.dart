import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_encoder.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('PlaintextClipboardEncoder', () {
    test('Encodes single cell', () {
      // Arrange
      CellProperties cell = CellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        value: SheetRichText.single(text: 'Single Cell'),
      );

      // Act
      String result = PlaintextClipboardEncoder.encode(<CellProperties>[cell]);

      // Assert
      expect(result, 'Single Cell');
    });

    test('Encodes multiple cells in a single row', () {
      // Arrange
      List<CellProperties> cells = <CellProperties>[
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          value: SheetRichText.single(text: 'Cell1'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
          value: SheetRichText.single(text: 'Cell2'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(2)),
          value: SheetRichText.single(text: 'Cell3'),
        ),
      ];

      // Act
      String result = PlaintextClipboardEncoder.encode(cells);

      // Assert
      expect(result, 'Cell1\tCell2\tCell3');
    });

    test('Encodes multiple rows', () {
      // Arrange
      List<CellProperties> cells = <CellProperties>[
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          value: SheetRichText.single(text: 'Row1Col1'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
          value: SheetRichText.single(text: 'Row1Col2'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
          value: SheetRichText.single(text: 'Row2Col1'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(1), column: ColumnIndex(1)),
          value: SheetRichText.single(text: 'Row2Col2'),
        ),
      ];

      // Act
      String result = PlaintextClipboardEncoder.encode(cells);

      // Assert
      expect(result, 'Row1Col1\tRow1Col2\nRow2Col1\tRow2Col2');
    });

    test('Handles empty cells', () {
      // Arrange
      List<CellProperties> cells = <CellProperties>[
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          value: SheetRichText.single(text: ''),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
          value: SheetRichText.single(text: 'Cell2'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
          value: SheetRichText.single(text: 'Cell3'),
        ),
        CellProperties(
          index: CellIndex(row: RowIndex(1), column: ColumnIndex(1)),
          value: SheetRichText.single(text: ''),
        ),
      ];

      // Act
      String result = PlaintextClipboardEncoder.encode(cells);

      // Assert
      expect(result, '\tCell2\nCell3');
    });

    test('Handles empty input list', () {
      // Arrange
      List<CellProperties> cells = <CellProperties>[];

      // Act
      String result = PlaintextClipboardEncoder.encode(cells);

      // Assert
      expect(result, '');
    });
  });
}

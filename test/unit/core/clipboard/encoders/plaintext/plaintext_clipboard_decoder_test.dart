import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('PlaintextClipboardDecoder', () {
    test('Decodes single cell data', () {
      // Arrange
      String rawData = 'Single Cell';

      // Act
      List<PastedCellProperties> actualResult = PlaintextClipboardDecoder.decode(rawData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
          text: SheetRichText.single(text: 'Single Cell'),
          rowOffset: 0,
          colOffset: 0,
        ),
      ];

      expect(actualResult, expectedResult);
    });

    test('Decodes multiple cells in a single row', () {
      // Arrange
      String rawData = 'Cell1\tCell2\tCell3';

      // Act
      List<PastedCellProperties> actualResult = PlaintextClipboardDecoder.decode(rawData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
          text: SheetRichText.single(text: 'Cell1'),
          rowOffset: 0,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Cell2'),
          rowOffset: 0,
          colOffset: 1,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Cell3'),
          rowOffset: 0,
          colOffset: 2,
        ),
      ];

      expect(actualResult, expectedResult);
    });

    test('Decodes multiple rows of data', () {
      // Arrange
      String rawData = 'Row1Col1\tRow1Col2\nRow2Col1\tRow2Col2';

      // Act
      List<PastedCellProperties> actualResult = PlaintextClipboardDecoder.decode(rawData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row1Col1'),
          rowOffset: 0,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row1Col2'),
          rowOffset: 0,
          colOffset: 1,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row2Col1'),
          rowOffset: 1,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row2Col2'),
          rowOffset: 1,
          colOffset: 1,
        ),
      ];

      expect(actualResult, expectedResult);
    });

    test('Handles empty cells', () {
      // Arrange
      String rawData = '\tCell2\nCell3\t';

      // Act
      List<PastedCellProperties> actualResult = PlaintextClipboardDecoder.decode(rawData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
          text: SheetRichText.single(text: ''),
          rowOffset: 0,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Cell2'),
          rowOffset: 0,
          colOffset: 1,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Cell3'),
          rowOffset: 1,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: ''),
          rowOffset: 1,
          colOffset: 1,
        ),
      ];

      expect(actualResult, expectedResult);
    });

    test('Handles data with trailing newlines', () {
      // Arrange
      String rawData = 'Row1Col1\tRow1Col2\nRow2Col1\tRow2Col2\n';

      // Act
      List<PastedCellProperties> actualResult = PlaintextClipboardDecoder.decode(rawData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row1Col1'),
          rowOffset: 0,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row1Col2'),
          rowOffset: 0,
          colOffset: 1,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row2Col1'),
          rowOffset: 1,
          colOffset: 0,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: 'Row2Col2'),
          rowOffset: 1,
          colOffset: 1,
        ),
        PastedCellProperties(
          text: SheetRichText.single(text: ''),
          rowOffset: 2,
          colOffset: 0,
        ),
      ];

      expect(actualResult, expectedResult);
    });

    test('Handles empty input string', () {
      // Arrange
      String rawData = '';

      // Act
      List<PastedCellProperties> actualResult = PlaintextClipboardDecoder.decode(rawData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
          text: SheetRichText.single(text: ''),
          rowOffset: 0,
          colOffset: 0,
        ),
      ];

      expect(actualResult, expectedResult);
    });
  });
}

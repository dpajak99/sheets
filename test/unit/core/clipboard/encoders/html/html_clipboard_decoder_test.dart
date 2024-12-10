import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('HtmlClipboardDecoder', () {
    test('Decodes HTML with a table to PastedCellProperties', () {
      // Arrange
      const String htmlData = '''
        <google-sheets-html-origin>
          <table>
            <tr>
              <td style="color: #ff0000;">Cell 1</td>
              <td>Cell 2</td>
            </tr>
            <tr>
              <td>Cell 3</td>
              <td style="background-color: #00ff00;">Cell 4</td>
            </tr>
          </table>
        </google-sheets-html-origin>
      ''';

      // Act
      List<PastedCellProperties> actualResult = HtmlClipboardDecoder.decode(htmlData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
            rowOffset: 0,
            colOffset: 0,
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Cell 1',
                style: TextStyle(color: Color(0xFFFF0000)),
              ),
            )),
        PastedCellProperties(
            rowOffset: 0,
            colOffset: 1,
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Cell 2',
              ),
            )),
        PastedCellProperties(
            rowOffset: 1,
            colOffset: 0,
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Cell 3',
              ),
            )),
        PastedCellProperties(
            rowOffset: 1,
            colOffset: 1,
            style: CellStyle(backgroundColor: const Color(0xFF00FF00)),
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Cell 4',
              ),
            )),
      ];

      expect(actualResult, expectedResult);
    });

    test('Handles merged cells with rowspan and colspan', () {
      // Arrange
      const String htmlData = '''
        <google-sheets-html-origin>
          <table>
            <tr>
              <td rowspan="2">Merged Cell</td>
              <td>Cell 2</td>
            </tr>
            <tr>
              <td>Cell 3</td>
            </tr>
          </table>
        </google-sheets-html-origin>
      ''';

      // Act
      List<PastedCellProperties> actualResult = HtmlClipboardDecoder.decode(htmlData);

      // Assert
      List<PastedCellProperties> expectedResult = <PastedCellProperties>[
        PastedCellProperties(
            rowOffset: 0,
            colOffset: 0,
            rowSpan: 2,
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Merged Cell',
              ),
            )),
        PastedCellProperties(
            rowOffset: 0,
            colOffset: 1,
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Cell 2',
              ),
            )),
        PastedCellProperties(
            rowOffset: 1,
            colOffset: 1,
            text: SheetRichText.fromTextSpan(
              const TextSpan(
                text: 'Cell 3',
              ),
            )),
      ];

      expect(actualResult, expectedResult);
    });

    test('Throws FormatException when required elements are missing', () {
      // Arrange
      const String invalidHtml1 = '<table></table>';
      const String invalidHtml2 = '<google-sheets-html-origin></google-sheets-html-origin>';

      // Act & Assert
      expect(() => HtmlClipboardDecoder.decode(invalidHtml1), throwsFormatException);
      expect(() => HtmlClipboardDecoder.decode(invalidHtml2), throwsFormatException);
    });

    test('Decodes empty table', () {
      // Arrange
      const String htmlData = '''
        <google-sheets-html-origin>
          <table></table>
        </google-sheets-html-origin>
      ''';

      // Act
      List<PastedCellProperties> result = HtmlClipboardDecoder.decode(htmlData);

      // Assert
      expect(result, isEmpty);
    });
  });
}

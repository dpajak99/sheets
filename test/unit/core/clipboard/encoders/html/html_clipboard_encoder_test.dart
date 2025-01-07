import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_encoder.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('HtmlClipboardEncoder', () {
    test('Encodes single cell properties into HTML', () {
      // Arrange
      CellProperties cellProperties = CellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Test Cell')]),
        style: CellStyle(
          backgroundColor: Colors.yellow,
          border: Border.all(),
        ),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<CellProperties>[cellProperties]);

      // Assert
      String expectedHtml =
          '<google-sheets-html-origin><table><tr><td style="text-align:left;border:1.0px solid #000000;background-color:#ffeb3b;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Test Cell</td></tr></table></google-sheets-html-origin>';

      expect(actualHtml, expectedHtml);
    });

    test('Encodes multiple rows and columns', () {
      // Arrange
      CellProperties cell1 = CellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Cell 1')]),
        style: CellStyle(),
      );

      CellProperties cell2 = CellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
        value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Cell 2')]),
        style: CellStyle(),
      );

      CellProperties cell3 = CellProperties(
        index: CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
        value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Cell 3')]),
        style: CellStyle(),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<CellProperties>[cell1, cell2, cell3]);

      // Assert
      String expectedHtml =
          '<google-sheets-html-origin><table><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Cell 1</td><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Cell 2</td></tr><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Cell 3</td></tr></table></google-sheets-html-origin>';

      expect(actualHtml, expectedHtml);
    });

    test('Handles merged cells correctly', () {
      // Arrange
      CellProperties mergedCell = CellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Merged Cell')]),
        style: CellStyle(),
        mergeStatus: MergedCell(
          start: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
          end: CellIndex(row: RowIndex(1), column: ColumnIndex(1)),
        ), // 2x2 merge
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<CellProperties>[mergedCell]);

      // Assert
      String expectedHtml =
          '<google-sheets-html-origin><table><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none" colspan="2" rowspan="2">Merged Cell</td></tr><tr></tr></table></google-sheets-html-origin>';
      expect(actualHtml, expectedHtml);
    });

    test('Encodes empty cells gracefully', () {
      // Arrange
      CellProperties emptyCell = CellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        value: SheetRichText(spans: <SheetTextSpan>[]),
        style: CellStyle(),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<CellProperties>[emptyCell]);

      // Assert
      String expectedHtml =
          '<google-sheets-html-origin><table><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none"></td></tr></table></google-sheets-html-origin>';

      expect(actualHtml, expectedHtml);
    });
  });
}

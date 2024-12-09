import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_encoder.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('HtmlClipboardEncoder', () {
    test('Encodes single cell properties into HTML', () {
      // Arrange
      IndexedCellProperties cellProperties = IndexedCellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        properties: CellProperties(
          value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Test Cell')]),
          style: CellStyle(
            backgroundColor: Colors.yellow,
            border: Border.all(),
          ),
          mergeStatus: NoCellMerge(),
        ),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<IndexedCellProperties>[cellProperties]);

      // Assert
      String expectedHtml = '<google-sheets-html-origin><table><tr><td style="text-align:left;border:1.0px solid #000000;background-color:#ffeb3b;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Test Cell</td></tr></table></google-sheets-html-origin>';

      expect(actualHtml, expectedHtml);
    });

    test('Encodes multiple rows and columns', () {
      // Arrange
      IndexedCellProperties cell1 = IndexedCellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        properties: CellProperties(
          value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Cell 1')]),
          style: CellStyle(),
          mergeStatus: NoCellMerge(),
        ),
      );

      IndexedCellProperties cell2 = IndexedCellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(1)),
        properties: CellProperties(
          value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Cell 2')]),
          style: CellStyle(),
          mergeStatus: NoCellMerge(),
        ),
      );

      IndexedCellProperties cell3 = IndexedCellProperties(
        index: CellIndex(row: RowIndex(1), column: ColumnIndex(0)),
        properties: CellProperties(
          value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Cell 3')]),
          style: CellStyle(),
          mergeStatus: NoCellMerge(),
        ),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<IndexedCellProperties>[cell1, cell2, cell3]);

      // Assert
      String expectedHtml = '<google-sheets-html-origin><table><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Cell 1</td><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Cell 2</td></tr><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none">Cell 3</td></tr></table></google-sheets-html-origin>';

      expect(actualHtml, expectedHtml);
    });

    test('Handles merged cells correctly', () {
      // Arrange
      IndexedCellProperties mergedCell = IndexedCellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        properties: CellProperties(
          value: SheetRichText(spans: <SheetTextSpan>[SheetTextSpan(text: 'Merged Cell')]),
          style: CellStyle(),
          mergeStatus: MergedCell(
            start: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
            end: CellIndex(row: RowIndex(1), column: ColumnIndex(1)),
          ), // 2x2 merge
        ),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<IndexedCellProperties>[mergedCell]);

      // Assert
      String expectedHtml = '<google-sheets-html-origin><table><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none" colspan="2" rowspan="2">Merged Cell</td></tr><tr></tr></table></google-sheets-html-origin>';
      expect(actualHtml, expectedHtml);
    });

    test('Encodes empty cells gracefully', () {
      // Arrange
      IndexedCellProperties emptyCell = IndexedCellProperties(
        index: CellIndex(row: RowIndex(0), column: ColumnIndex(0)),
        properties: CellProperties(
          value: SheetRichText(spans: <SheetTextSpan>[]),
          style: CellStyle(),
          mergeStatus: NoCellMerge(),
        ),
      );

      // Act
      String actualHtml = HtmlClipboardEncoder.encode(<IndexedCellProperties>[emptyCell]);

      // Assert
      String expectedHtml = '<google-sheets-html-origin><table><tr><td style="text-align:left;background-color:#ffffff;color:#000000;font-weight:normal;font-size:10.0pt;font-family:Arial;font-style:normal;text-decoration:none"></td></tr></table></google-sheets-html-origin>';

      expect(actualHtml, expectedHtml);
    });
  });
}

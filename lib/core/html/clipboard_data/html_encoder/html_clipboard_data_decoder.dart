import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/html/css/css_decoder.dart';
import 'package:sheets/core/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/html/elements/html_span.dart';
import 'package:sheets/core/html/elements/html_table.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/map_extensions.dart';

class HtmlClipboardDataDecoder {
  HtmlClipboardDataDecoder(this.data, this.selectionAnchor);

  final SheetData data;
  final CellIndex selectionAnchor;

  List<IndexedCellProperties> decode(String htmlData) {
    HtmlGoogleSheetsHtmlOrigin parsedDocument = _parseDocument(htmlData);

    // Convert parsed HTML back into cell properties and apply to the sheet.
    List<IndexedCellProperties> pastedCells = _applyHtmlDocumentToSheet(parsedDocument);
    return pastedCells;
  }

  /// Apply parsed HTML document content back into the sheet's data model.
  List<IndexedCellProperties> _applyHtmlDocumentToSheet(HtmlGoogleSheetsHtmlOrigin document) {
    HtmlTable table = document.table;
    CellIndex startCell = selectionAnchor;

    List<IndexedCellProperties> pastedCells = <IndexedCellProperties>[];
    int currentRowOffset = 0;
    Map<int, List<int>> rowMergedColumns = <int, List<int>>{};
    for (HtmlTableRow row in table.rows) {
      int currentColOffset = 0;
      for (HtmlTableCell cell in row.cells) {
        int rowOffset = currentRowOffset;
        while (rowMergedColumns.containsKey(rowOffset) && rowMergedColumns[rowOffset]!.contains(currentColOffset)) {
          rowOffset++;
        }

        CellIndex targetIndex = CellIndex(
          row: startCell.row + rowOffset,
          column: startCell.column + currentColOffset,
        );
        pastedCells.add(
          IndexedCellProperties(
            index: targetIndex,
            properties: _extractCellPropertiesFromHtmlCell(targetIndex, cell),
          ),
        );
        int colSpan = cell.colSpan ?? 1;
        int rowSpan = cell.rowSpan ?? 1;
        if (rowSpan > 1) {
          for (int i = currentRowOffset; i < currentRowOffset + rowSpan; i++) {
            rowMergedColumns.putIfAbsent(i, () => <int>[]);
            for (int j = currentColOffset; j < currentColOffset + colSpan; j++) {
              rowMergedColumns[i]?.add(j);
            }
          }
        }
        currentColOffset += colSpan;
      }
      currentRowOffset++;
    }
    return pastedCells;
  }

  /// Extract cell properties from an HtmlTableCell when pasting.
  CellProperties _extractCellPropertiesFromHtmlCell(CellIndex targetIndex, HtmlTableCell cell) {
    // Here we do the inverse of _buildHtmlTableCell, extracting styles and text.
    // For simplicity, we assume a single span per cell.
    HtmlSpan firstSpan = cell.spans.isNotEmpty ? cell.spans.first : HtmlSpan(text: '');

    CellMergeStatus mergeStatus = NoCellMerge();
    int colSpan = cell.colSpan ?? 1;
    int rowSpan = cell.rowSpan ?? 1;
    if (colSpan > 1 || rowSpan > 1) {
      mergeStatus = MergedCell(
        start: targetIndex,
        end: CellIndex(
          row: targetIndex.row + rowSpan - 1,
          column: targetIndex.column + colSpan - 1,
        ),
      );
      data.applyMergeStatus(mergeStatus);
    }

    return CellProperties(
      value: SheetRichText(spans: <SheetTextSpan>[
        SheetTextSpan(
          text: firstSpan.text,
          style: SheetTextSpanStyle(
            color: firstSpan.style?.color,
            fontWeight: firstSpan.style?.fontWeight,
            fontSize: firstSpan.style?.fontSize,
            fontFamily: firstSpan.style?.fontFamily,
            fontStyle: firstSpan.style?.fontStyle,
            decoration: firstSpan.style?.textDecoration,
          ),
        ),
      ]),
      style: CellStyle(
        horizontalAlign: cell.style?.textAlign,
        border: cell.style?.border,
        backgroundColor: cell.style?.backgroundColor,
      ),
      mergeStatus: mergeStatus,
    );
  }

  /// Parse a full HTML document containing `<google-sheets-html-origin>` and `<table>` into a [HtmlGoogleSheetsHtmlOrigin].
  HtmlGoogleSheetsHtmlOrigin _parseDocument(String html) {
    // Parse the entire HTML into a DOM.
    dom.Document document = html_parser.parse(html);

    // Find the outer <google-sheets-html-origin> element.
    dom.Element? originElement = document.querySelector('google-sheets-html-origin');
    if (originElement == null) {
      throw const FormatException('Missing <google-sheets-html-origin> element.');
    }

    // Inside it, find the <table>.
    dom.Element? tableElement = originElement.querySelector('table');
    if (tableElement == null) {
      throw const FormatException('Missing <table> element inside <google-sheets-html-origin>.');
    }

    List<HtmlTableRow> rows = _parseRows(tableElement);

    return HtmlGoogleSheetsHtmlOrigin(
      table: HtmlTable(rows: rows),
    );
  }

  List<HtmlTableRow> _parseRows(dom.Element tableElement) {
    List<dom.Element> rowElements = tableElement.querySelectorAll('tr');
    return rowElements.map((dom.Element rowElement) {
      Map<String, String> attributes = CssDecoder.decodeAttributes(rowElement.attributes['style']);
      List<HtmlTableCell> cells = _parseCells(rowElement, attributes);
      String? height = attributes['height'];
      double? rowHeight = CssDecoder.decodeDouble(height);
      return HtmlTableRow(cells: cells, height: rowHeight);
    }).toList();
  }

  List<HtmlTableCell> _parseCells(dom.Element rowElement, Map<String, String> parentAttributes) {
    List<dom.Element> cellElements = rowElement.querySelectorAll('td, th');
    return cellElements.map((dom.Element cellElement) {
      Map<String, String> attributes = CssDecoder.decodeAttributes(cellElement.attributes['style']);
      List<HtmlSpan> spans = _parseSpans(cellElement, parentAttributes.merge(attributes));

      int? colSpan = CssDecoder.decodeInteger(cellElement.attributes['colspan']);
      int? rowSpan = CssDecoder.decodeInteger(cellElement.attributes['rowspan']);

      return HtmlTableCell(
        spans: spans,
        style: HtmlTableStyle.css(attributes),
        colSpan: colSpan,
        rowSpan: rowSpan,
      );
    }).toList();
  }

  List<HtmlSpan> _parseSpans(dom.Element cellElement, Map<String, String> parentAttributes) {
    List<dom.Element> spanElements = cellElement.querySelectorAll('span');
    if (spanElements.isEmpty) {
      String text = cellElement.text.trim();
      return <HtmlSpan>[HtmlSpan(text: text, style: HtmlSpanStyle.css(parentAttributes))];
    }

    return spanElements.map((dom.Element spanElement) {
      String text = spanElement.text.trim();
      Map<String, String> attributes = CssDecoder.decodeAttributes(spanElement.attributes['style']);

      return HtmlSpan(
        text: text,
        style: HtmlSpanStyle.css(parentAttributes.merge(attributes)),
      );
    }).toList();
  }
}

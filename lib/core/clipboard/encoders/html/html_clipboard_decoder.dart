import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:sheets/core/clipboard/encoders/html/css/css_style.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_table.dart';
import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/map_extensions.dart';

class HtmlClipboardDecoder {
  static List<PastedCellProperties> decode(String htmlData) {
    HtmlGoogleSheetsHtmlOrigin parsedDocument = _parseDocument(htmlData);

    // Convert parsed HTML back into cell properties and apply to the sheet.
    List<PastedCellProperties> pastedCells = _applyHtmlDocumentToSheet(parsedDocument);
    return pastedCells;
  }

  /// Apply parsed HTML document content back into the sheet's data model.
  static List<PastedCellProperties> _applyHtmlDocumentToSheet(HtmlGoogleSheetsHtmlOrigin document) {
    HtmlTable table = document.table;

    List<PastedCellProperties> pastedCells = <PastedCellProperties>[];
    int currentRowOffset = 0;
    Map<int, List<int>> rowMergedColumns = <int, List<int>>{};

    for (HtmlTableRow row in table.rows) {
      int currentColOffset = 0;
      for (HtmlTableCell cell in row.cells) {
        while (rowMergedColumns.containsKey(currentRowOffset) &&
            rowMergedColumns[currentRowOffset]!.contains(currentColOffset)) {
          currentColOffset++;
        }

        PastedCellProperties pastedCellProperties = _extractCellPropertiesFromHtmlCell(
            currentRowOffset,
            currentColOffset,
            cell
        );
        pastedCells.add(pastedCellProperties);

        int colSpan = cell.colSpan ?? 1;
        int rowSpan = cell.rowSpan ?? 1;

        if (rowSpan > 1) {
          for (int i = currentRowOffset + 1; i < currentRowOffset + rowSpan; i++) {
            rowMergedColumns.putIfAbsent(i, () => <int>[]);
            for (int j = currentColOffset; j < currentColOffset + colSpan; j++) {
              if (!rowMergedColumns[i]!.contains(j)) {
                rowMergedColumns[i]!.add(j);
              }
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
  static PastedCellProperties _extractCellPropertiesFromHtmlCell(int rowOffset, int colOffset, HtmlTableCell cell) {
    return PastedCellProperties(
      rowOffset: rowOffset,
      colOffset: colOffset,
      rowSpan: cell.rowSpan,
      colSpan: cell.colSpan,
      text: SheetRichText(
        spans: cell.spans.map((HtmlSpan span) {
          HtmlSpanStyle? style = span.style;
          return SheetTextSpan(
            text: span.text,
            style: SheetTextSpanStyle(
              color: style?.color?.toDart(),
              fontWeight: style?.fontWeight?.toDart(),
              fontSize: style?.fontSize?.toDart() != null ? FontSize.fromPoints(style!.fontSize!.toDart()) : null,
              fontFamily: style?.fontFamily?.toDart(),
              fontStyle: style?.fontStyle?.toDart(),
              decoration: style?.textDecoration?.toDart(),
            ),
          );
        }).toList(),
      ),
      style: CellStyle(
        horizontalAlign: cell.style?.textAlign?.toDart(),
        verticalAlign: cell.style?.verticalAlign?.toDart(),
        border: cell.style?.border?.toDart(),
        backgroundColor: cell.style?.backgroundColor?.toDart(),
      ),
    );
  }

  /// Parse a full HTML document containing `<google-sheets-html-origin>` and `<table>` into a [HtmlGoogleSheetsHtmlOrigin].
  static HtmlGoogleSheetsHtmlOrigin _parseDocument(String html) {
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

  static List<HtmlTableRow> _parseRows(dom.Element tableElement) {
    List<dom.Element> rowElements = tableElement.querySelectorAll('tr');
    return rowElements.map((dom.Element rowElement) {
      Map<String, String> attributes = CssStyle.decodeProperties(rowElement.attributes['style']);
      List<HtmlTableCell> cells = _parseCells(rowElement, attributes);
      return HtmlTableRow(cells: cells);
    }).toList();
  }

  static List<HtmlTableCell> _parseCells(dom.Element rowElement, Map<String, String> parentAttributes) {
    List<dom.Element> cellElements = rowElement.querySelectorAll('td, th');
    return cellElements.map((dom.Element cellElement) {
      Map<String, String> attributes = CssStyle.decodeProperties(cellElement.attributes['style']);
      List<HtmlSpan> spans = _parseSpans(cellElement, parentAttributes.merge(attributes));

      int? colSpan = int.tryParse(cellElement.attributes['colspan'] ?? '1');
      int? rowSpan = int.tryParse(cellElement.attributes['rowspan'] ?? '1');

      return HtmlTableCell(
        spans: spans,
        style: HtmlTableStyle.fromCssMap(attributes),
        colSpan: colSpan,
        rowSpan: rowSpan,
      );
    }).toList();
  }

  static List<HtmlSpan> _parseSpans(dom.Element cellElement, Map<String, String> parentAttributes) {
    List<dom.Element> spanElements = cellElement.querySelectorAll('span');
    if (spanElements.isEmpty) {
      String text = cellElement.text;
      return <HtmlSpan>[HtmlSpan(text: text, style: HtmlSpanStyle.fromCssMap(parentAttributes))];
    }

    return spanElements.map((dom.Element spanElement) {
      String text = spanElement.text;
      Map<String, String> attributes = CssStyle.decodeProperties(spanElement.attributes['style']);
      attributes = parentAttributes.merge(attributes);

      return HtmlSpan(
        text: text,
        style: HtmlSpanStyle.fromCssMap(attributes),
      );
    }).toList();
  }
}

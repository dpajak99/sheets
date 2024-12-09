import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_table.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

class HtmlClipboardEncoder {
  static String encode(List<IndexedCellProperties> cellsProperties) {
    HtmlTable table = _buildHtmlTable(cellsProperties);
    HtmlGoogleSheetsHtmlOrigin document = HtmlGoogleSheetsHtmlOrigin(table: table);
    String html = document.toHtml();
    return html;
  }

  /// Build a full HTML table from a list of IndexedCellProperties.
  static HtmlTable _buildHtmlTable(List<IndexedCellProperties> cellsProps) {
    Map<RowIndex, List<IndexedCellProperties>> rowsMap = cellsProps.groupByRows();

    List<HtmlTableRow> htmlRows = <HtmlTableRow>[];
    for (MapEntry<RowIndex, List<IndexedCellProperties>> entry in rowsMap.entries) {
      List<IndexedCellProperties> rowCellsProperties = entry.value;

      List<HtmlTableCell> htmlCells = rowCellsProperties.map(_buildHtmlTableCell).toList();
      htmlRows.add(HtmlTableRow(cells: htmlCells));

      int maxRowSpan = htmlCells.map((HtmlTableCell cell) => cell.rowSpan ?? 1).fold(0, (int a, int b) => a > b ? a : b);
      if (maxRowSpan > 1) {
        for (int i = 1; i < maxRowSpan; i++) {
          htmlRows.add(HtmlTableRow.empty());
        }
      }
    }

    return HtmlTable(rows: htmlRows);
  }

  /// Convert a single IndexedCellProperties into HtmlTableCell.
  static HtmlTableCell _buildHtmlTableCell(IndexedCellProperties cellProps) {
    List<HtmlSpan> spans = _buildSpansFromCellProperties(cellProps.properties);
    TextAlign textAlign = cellProps.properties.visibleTextAlign;
    Border? border = cellProps.properties.style.border;
    Color backgroundColor = cellProps.properties.style.backgroundColor;
    int colSpan = cellProps.properties.mergeStatus.width + 1;
    int rowSpan = cellProps.properties.mergeStatus.height + 1;

    return HtmlTableCell(
      spans: spans,
      style: HtmlTableStyle.fromDart(
        textAlign: textAlign,
        border: border,
        backgroundColor: backgroundColor,
      ),
      colSpan: colSpan,
      rowSpan: rowSpan,
    );
  }

  /// Create spans from cell properties text runs, fonts, etc.
  static List<HtmlSpan> _buildSpansFromCellProperties(CellProperties props) {
    return props.value.spans.map((SheetTextSpan span) {
      return HtmlSpan(
        text: span.text,
        style: HtmlSpanStyle.fromDart(
          color: span.style.color,
          fontWeight: span.style.fontWeight,
          fontSize: span.style.fontSize,
          fontFamily: span.style.fontFamily,
          fontStyle: span.style.fontStyle,
          textDecoration: span.style.decoration,
        ),
      );
    }).toList();
  }
}

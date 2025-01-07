import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_table.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

class HtmlClipboardEncoder {
  /// Encodes a list of CellProperties into an HTML table format string.
  static String encode(List<CellProperties> cellPropertiesList) {
    HtmlTable table = _buildHtmlTable(cellPropertiesList);
    HtmlGoogleSheetsHtmlOrigin document = HtmlGoogleSheetsHtmlOrigin(table: table);
    String html = document.toHtml();
    return html;
  }

  /// Builds a complete HTML table from a list of cell properties.
  /// It groups cells by their row indices, then for each row creates an HtmlTableRow.
  /// Since some cells may be merged (spanning multiple rows and/or columns),
  /// we need to carefully handle the row and column calculations to ensure the final HTML structure is correct.
  static HtmlTable _buildHtmlTable(List<CellProperties> cellPropertiesList) {
    // Group cells by their row index for more efficient processing
    Map<RowIndex, List<CellProperties>> rowsMap = cellPropertiesList.groupByRows();
    int maxColumns = rowsMap.values
        .map((List<CellProperties> e) => e.length)
        .reduce((int value, int element) => value > element ? value : element);
    List<HtmlTableRow> htmlRows = <HtmlTableRow>[];

    // Iterate over each group (each represents one table row in raw form)
    for (MapEntry<RowIndex, List<CellProperties>> entry in rowsMap.entries) {
      List<CellProperties> rowCellsProperties = entry.value;
      if (rowCellsProperties.isEmpty) {
        continue; // Skip empty rows if any occur
      }

      // Convert each cell property into a formatted HTML table cell
      List<HtmlTableCell> htmlCells = rowCellsProperties.map(_buildHtmlTableCell).toList();

      // Add a new table row with the generated cells
      htmlRows.add(HtmlTableRow(cells: htmlCells));

      List<int> rowSpans = _extractRowSpans(htmlCells);
      int minRowSpan = rowSpans.reduce((int value, int element) => value < element ? value : element);
      if (minRowSpan > 1 && rowSpans.length == maxColumns) {
        int rowsToAdd = minRowSpan - 1;
        htmlRows.addAll(List<HtmlTableRow>.filled(rowsToAdd > 0 ? rowsToAdd : 0, HtmlTableRow.empty()));
      }
    }

    return HtmlTable(rows: htmlRows);
  }

  /// Converts a single CellProperties object into a corresponding HtmlTableCell.
  /// Merged cells are handled here by calculating colSpan and rowSpan based on merge status.
  /// The style and text content are also applied.
  static HtmlTableCell _buildHtmlTableCell(CellProperties cellProps) {
    List<HtmlSpan> spans = _buildSpansFromCellProperties(cellProps);
    TextAlign textAlign = cellProps.visibleTextAlign;
    Border? border = cellProps.style.border;
    Color backgroundColor = cellProps.style.backgroundColor;

    // Calculate colSpan and rowSpan to properly represent merged cells
    // `width` and `height` in mergeStatus indicate how many additional columns/rows are merged
    int colSpan = cellProps.mergeStatus.width + 1;
    int rowSpan = cellProps.mergeStatus.height + 1;

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

  /// Builds spans (text segments) from the cell's text properties.
  /// Each SheetTextSpan is converted into an HtmlSpan with the appropriate styles.
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

  static List<int> _extractRowSpans(List<HtmlTableCell> cells) {
    List<int> rowSpans = List<int>.filled(cells.length, 1);
    for (int i = 0; i < cells.length; i++) {
      rowSpans[i] = cells[i].rowSpan ?? 1;
    }
    return rowSpans;
  }
}

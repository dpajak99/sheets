import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/html/css_encoder.dart';
import 'package:sheets/core/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/html/elements/html_span.dart';
import 'package:sheets/core/html/elements/html_table.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/text_style_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';

class HtmlParser {
  /// Parse a full HTML document containing `<google-sheets-html-origin>` and `<table>` into a [HtmlGoogleSheetsHtmlOrigin].
  static HtmlGoogleSheetsHtmlOrigin parseDocument(String html) {
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
      List<HtmlTableCell> cells = _parseCells(rowElement);
      String? height = _extractStyleValue(rowElement, 'height');
      double rowHeight = _parseDoubleOrDefault(height, 20);
      return HtmlTableRow(cells: cells, height: rowHeight);
    }).toList();
  }

  static List<HtmlTableCell> _parseCells(dom.Element rowElement) {
    List<dom.Element> cellElements = rowElement.querySelectorAll('td, th');
    return cellElements.map((dom.Element cellElement) {
      List<HtmlSpan> spans = _parseSpans(cellElement);
      String? textAlignValue = _extractStyleValue(cellElement, 'text-align');
      String? bgColorValue = _extractStyleValue(cellElement, 'background-color');

      TextAlign? textAlign = _decodeTextAlign(textAlignValue);
      Color? backgroundColor = _decodeColor(bgColorValue);
      int? colSpan = _parseIntAttribute(cellElement, 'colspan');
      int? rowSpan = _parseIntAttribute(cellElement, 'rowspan');

      // Border, textRotation, etc., can be extracted similarly if stored in attributes/styles.
      // For demonstration, assume none or extract them similarly:
      Border? border = _decodeBorder(cellElement);

      // textRotation is not standard HTML/CSS, you may have stored it as a custom attribute:
      bool hasTextRotation = cellElement.attributes.containsKey('data-sheets-root');
      TextRotation? textRotation = hasTextRotation ? TextRotation.none : null;

      return HtmlTableCell(
        spans: spans,
        textAlign: textAlign,
        border: border,
        backgroundColor: backgroundColor,
        colSpan: colSpan,
        rowSpan: rowSpan,
        textRotation: textRotation,
      );
    }).toList();
  }

  static List<HtmlSpan> _parseSpans(dom.Element cellElement) {
    List<dom.Element> spanElements = cellElement.querySelectorAll('span');
    if (spanElements.isEmpty) {
      // No spans, treat cell text as a single run.
      String text = cellElement.text.trim();
      return <HtmlSpan>[HtmlSpan(text: text)];
    }

    return spanElements.map((dom.Element spanElement) {
      String text = spanElement.text.trim();

      String? colorValue = _extractStyleValue(spanElement, 'color');
      String? fontWeightValue = _extractStyleValue(spanElement, 'font-weight');
      String? fontSizeValue = _extractStyleValue(spanElement, 'font-size');
      String? fontFamilyValue = _extractStyleValue(spanElement, 'font-family');
      String? fontStyleValue = _extractStyleValue(spanElement, 'font-style');
      String? textDecorationValue = _extractStyleValue(spanElement, 'text-decoration');

      Color? color = _decodeColor(colorValue);
      FontWeight? fontWeight = _decodeFontWeight(fontWeightValue);
      double? fontSize = _parseFontSize(fontSizeValue);
      FontStyle? fontStyle = _decodeFontStyle(fontStyleValue);
      _TextDecorationParseResult textDecorationParsed = _decodeTextDecoration(textDecorationValue);

      return HtmlSpan(
        text: text,
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamilyValue?.isNotEmpty == true ? fontFamilyValue : null,
        fontStyle: fontStyle,
        textDecoration: textDecorationParsed.decoration,
        textDecorationStyle: textDecorationParsed.style,
      );
    }).toList();
  }

  // --- Utility and decoding methods ---
  static String? _extractStyleValue(dom.Element element, String styleName) {
    String? style = element.attributes['style'];
    if (style == null) {
      return null;
    }
    // Split by ';' to get individual declarations
    Iterable<String> declarations = style.split(';').map((String d) => d.trim()).where((String d) => d.isNotEmpty);
    for ( String decl in declarations) {
      List<String> parts = decl.split(':').map((String p) => p.trim()).toList();
      if (parts.length == 2) {
        String name = parts[0].toLowerCase();
        String value = parts[1];
        if (name == styleName.toLowerCase()) {
          return value;
        }
      }
    }
    return null;
  }

  static int? _parseIntAttribute(dom.Element element, String attribute) {
    String? value = element.attributes[attribute];
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  static double _parseDoubleOrDefault(String? value, double defaultValue) {
    if (value == null) {
      return defaultValue;
    }
    double? parsed = double.tryParse(value.replaceAll('px', '').trim());
    return parsed ?? defaultValue;
  }

  static double? _parseFontSize(String? value) {
    if (value == null) {
      return null;
    }
    return double.tryParse(value.replaceAll('pt', '').replaceAll('px', '').trim());
  }

  static TextAlign? _decodeTextAlign(String? value) {
    if (value == null) {
      return null;
    }
    switch (value) {
      case 'center':
        return TextAlign.center;
      case 'end':
        return TextAlign.end;
      case 'justify':
        return TextAlign.justify;
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'start':
        return TextAlign.start;
      default:
        return null;
    }
  }

  static Color? _decodeColor(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value == 'transparent') {
      return const Color(0x00000000);
    }
    if (value.startsWith('#')) {
      return CssEncoder.colorFromHex(value);
    }
    if (value.startsWith('rgba')) {
      RegExpMatch? rgba = RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)').firstMatch(value);
      if (rgba != null) {
        int r = int.parse(rgba.group(1)!);
        int g = int.parse(rgba.group(2)!);
        int b = int.parse(rgba.group(3)!);
        int a = (double.parse(rgba.group(4)!) * 255).toInt();
        return Color.fromARGB(a, r, g, b);
      }
    }
    // If needed, parse other color formats (e.g., rgb(...) )
    return null;
  }

  static FontWeight? _decodeFontWeight(String? value) {
    if (value == null) {
      return null;
    }
    // Common values: "normal", "bold", "100", "200", etc.
    if (value == 'bold') {
      return FontWeight.bold;
    } else if (value == 'normal') {
      return FontWeight.normal;
    }
    int? numeric = int.tryParse(value);
    if (numeric != null) {
      return FontWeight.values.firstWhere((FontWeight w) => w.value == numeric, orElse: () => FontWeight.normal);
    }
    return FontWeight.normal;
  }

  static FontStyle? _decodeFontStyle(String? value) {
    if (value == null) {
      return null;
    }
    return (value == 'italic') ? FontStyle.italic : FontStyle.normal;
  }

  static _TextDecorationParseResult _decodeTextDecoration(String? value) {
    if (value == null) {
      return _TextDecorationParseResult(null, null);
    }
    List<String> parts = value.split(' ');
    List<TextDecoration> decorations = <TextDecoration>[];
    for (String p in parts) {
      switch (p) {
        case 'underline':
          decorations.add(TextDecoration.underline);
        case 'overline':
          decorations.add(TextDecoration.overline);
        case 'line-through':
          decorations.add(TextDecoration.lineThrough);
      }
    }
    // For simplicity, textDecorationStyle is not extracted here.
    return _TextDecorationParseResult(TextDecoration.combine(decorations), null);
  }

  static Border? _decodeBorder(dom.Element element) {
    // Attempt to decode a uniform border from the 'border' style, or individual border sides.
    // This is a simplified demonstration.
    // A real implementation might parse each border side individually.
    String? borderValue = _extractStyleValue(element, 'border');
    if (borderValue != null) {
      return _parseBorderStyle(borderValue);
    }

    // Otherwise, check 'border-top', 'border-right', 'border-bottom', 'border-left'
    BorderSide? top = _decodeBorderSide(_extractStyleValue(element, 'border-top'));
    BorderSide? right = _decodeBorderSide(_extractStyleValue(element, 'border-right'));
    BorderSide? bottom = _decodeBorderSide(_extractStyleValue(element, 'border-bottom'));
    BorderSide? left = _decodeBorderSide(_extractStyleValue(element, 'border-left'));

    if (top == null && right == null && bottom == null && left == null) {
      return null;
    }

    return Border(
      top: top ?? BorderSide.none,
      right: right ?? BorderSide.none,
      bottom: bottom ?? BorderSide.none,
      left: left ?? BorderSide.none,
    );
  }

  static Border _parseBorderStyle(String borderValue) {
    BorderSide side = _decodeBorderSide(borderValue) ?? BorderSide.none;
    return Border.fromBorderSide(side);
  }

  static BorderSide? _decodeBorderSide(String? value) {
    if (value == null) {
      return null;
    }
    List<String> parts = value.split(' ').map((String p) => p.trim()).where((String p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      return null;
    }

    double? width;
    Color? color;
    // style = solid assumed
    for (String part in parts) {
      if (part.endsWith('px')) {
        width = double.tryParse(part.replaceAll('px', '')) ?? 1.0;
      } else if (part.startsWith('#') || part.startsWith('rgba') || part.startsWith('rgb')) {
        Color? decodedColor = _decodeColor(part);
        if (decodedColor != null) {
          color = decodedColor;
        }
      }
    }

    return MaterialSheetTheme.defaultBorderSide.copyWith(
        color: color, width: width
    );
  }
}

class IndexedCellPropertiesParser {
  IndexedCellPropertiesParser(this._sheetData, this._selectionAnchor);

  final SheetData _sheetData;
  final CellIndex _selectionAnchor;

  /// Build a full HTML table from a list of IndexedCellProperties.
  HtmlTable buildHtmlTable(List<IndexedCellProperties> cellsProps) {
    Map<RowIndex, List<IndexedCellProperties>> rowsMap = _groupByRow(cellsProps);

    List<HtmlTableRow> htmlRows = rowsMap.entries.map((MapEntry<RowIndex, List<IndexedCellProperties>> entry) {
      RowIndex rowIndex = entry.key;
      List<IndexedCellProperties> rowCellsProperties = entry.value;

      List<HtmlTableCell> htmlCells = rowCellsProperties.map(_buildHtmlTableCell).toList();

      double rowHeight = _sheetData.getRowHeight(rowIndex);
      return HtmlTableRow(cells: htmlCells, height: rowHeight);
    }).toList();

    return HtmlTable(rows: htmlRows);
  }

  /// Apply parsed HTML document content back into the sheet's data model.
  List<CellIndex> applyHtmlDocumentToSheet(HtmlGoogleSheetsHtmlOrigin document) {
    HtmlTable table = document.table;
    CellIndex startCell = _selectionAnchor; // Assume we have a reference cell for paste start.

    List<CellIndex> pastedCells = <CellIndex>[];
    int currentRowOffset = 0;
    for (HtmlTableRow row in table.rows) {
      int currentColOffset = 0;
      for (HtmlTableCell cell in row.cells) {
        CellIndex targetIndex = CellIndex(
          row: startCell.row + currentRowOffset,
          column: startCell.column + currentColOffset,
        );
        pastedCells.add(targetIndex);
        CellProperties cellProperties = _extractCellPropertiesFromHtmlCell(cell);
        _sheetData.setCellProperties(targetIndex, cellProperties);
        currentColOffset++;
      }
      currentRowOffset++;
    }
    return pastedCells;
  }

  /// Convert a single IndexedCellProperties into HtmlTableCell.
  HtmlTableCell _buildHtmlTableCell(IndexedCellProperties cellProps) {
    // Here you would map your internal cell properties (like text, formatting, borders)
    // to HtmlSpans and styling attributes.
    List<HtmlSpan> spans = _buildSpansFromCellProperties(cellProps.properties);
    TextAlign textAlign = cellProps.properties.visibleTextAlign;
    Border? border = cellProps.properties.style.border;
    Color backgroundColor = cellProps.properties.style.backgroundColor;
    int colSpan = cellProps.properties.mergeStatus.width + 1;
    int rowSpan = cellProps.properties.mergeStatus.height + 1;
    TextRotation textRotation = cellProps.properties.style.rotation;

    return HtmlTableCell(
      spans: spans,
      textAlign: textAlign,
      border: border,
      backgroundColor: backgroundColor,
      colSpan: colSpan,
      rowSpan: rowSpan,
      textRotation: textRotation,
    );
  }

  /// Create spans from cell properties text runs, fonts, etc.
  List<HtmlSpan> _buildSpansFromCellProperties(CellProperties props) {
    // Example: if cellProperties has a single text run:
    return props.value.spans.map((SheetTextSpan span) {
      return HtmlSpan(
        text: span.text,
        color: span.style.color,
        fontWeight: span.style.fontWeight,
        fontSize: span.style.fontSize,
        fontFamily: span.style.fontFamily,
        fontStyle: span.style.fontStyle,
        textDecoration: span.style.decoration,
        textDecorationStyle: span.style.decorationStyle,
      );
    }).toList();
  }

  /// Extract cell properties from an HtmlTableCell when pasting.
  CellProperties _extractCellPropertiesFromHtmlCell(HtmlTableCell cell) {
    // Here we do the inverse of _buildHtmlTableCell, extracting styles and text.
    // For simplicity, we assume a single span per cell.
    HtmlSpan firstSpan = cell.spans.isNotEmpty ? cell.spans.first : HtmlSpan(text: '');
    return CellProperties(
      value: SheetRichText(spans: <SheetTextSpan>[
        SheetTextSpan(
          text: firstSpan.text,
          style: defaultTextStyle.join(
            TextStyle(
              color: firstSpan.color,
              fontWeight: firstSpan.fontWeight,
              fontSize: firstSpan.fontSize,
              fontFamily: firstSpan.fontFamily,
              fontStyle: firstSpan.fontStyle,
              decoration: firstSpan.textDecoration,
              decorationStyle: firstSpan.textDecorationStyle,
            ),
          ),
        ),
      ]),
      style: CellStyle(
        horizontalAlign: cell.textAlign,
        border: cell.border,
        backgroundColor: cell.backgroundColor,
        rotation: cell.textRotation,
      ),
      mergeStatus: NoCellMerge(),
    );
  }

  Map<RowIndex, List<IndexedCellProperties>> _groupByRow(List<IndexedCellProperties> cellsProps) {
    Map<RowIndex, List<IndexedCellProperties>> rows = <RowIndex, List<IndexedCellProperties>>{};
    for (IndexedCellProperties cellProp in cellsProps) {
      rows.putIfAbsent(cellProp.index.row, () => <IndexedCellProperties>[]).add(cellProp);
    }
    return rows;
  }
}

// Helper class for text decoration parsing result
class _TextDecorationParseResult {
  _TextDecorationParseResult(this.decoration, this.style);
  final TextDecoration? decoration;
  final TextDecorationStyle? style;
}

// Extension Let if needed
extension Let<T, R> on T {
  R let(R Function(T) op) => op(this);
}

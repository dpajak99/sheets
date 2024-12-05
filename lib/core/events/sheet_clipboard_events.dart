import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/text_style_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:super_clipboard/super_clipboard.dart';

abstract class SheetClipboardEvent extends SheetEvent {
  @override
  SheetClipboardAction<SheetClipboardEvent> createAction(SheetController controller);
}

abstract class SheetClipboardAction<T extends SheetClipboardEvent> extends SheetAction<T> {
  SheetClipboardAction(super.event, super.controller);
}

class CopySelectionEvent extends SheetClipboardEvent {
  CopySelectionEvent();

  @override
  CopySelectionAction createAction(SheetController controller) => CopySelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig();

  @override
  List<Object?> get props => <Object?>[];
}

class CopySelectionAction extends SheetClipboardAction<CopySelectionEvent> {
  CopySelectionAction(super.event, super.controller);

  @override
  Future<void> execute() async {
    List<CellIndex> selectedCells =
    controller.selection.value.getSelectedCells(controller.data.columnCount, controller.data.rowCount);

    List<IndexedCellProperties> cellsProperties = selectedCells.map((CellIndex index) {
      return IndexedCellProperties(
        index: index,
        properties: controller.data.getCellProperties(index),
      );
    }).toList();

    HtmlGoogleSheetsHtmlOrigin htmlDocument = HtmlGoogleSheetsHtmlOrigin(
      table: IndexedCellPropertiesParser(controller.data, controller.selection.value.mainCell).buildHtmlTable(cellsProperties),
    );

    String htmlString = htmlDocument.toHtml();
    SystemClipboard? clipboard = SystemClipboard.instance;
    DataWriterItem item = DataWriterItem();
    item.add(Formats.htmlText.lazy(() => htmlString));
    await clipboard?.write(<DataWriterItem>[item]);
  }
}

class PasteSelectionEvent extends SheetClipboardEvent {
  PasteSelectionEvent();

  @override
  PasteSelectionAction createAction(SheetController controller) => PasteSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig =>
      SheetRebuildConfig(
        rebuildData: true,
        rebuildViewport: true,
      );

  @override
  List<Object?> get props => <Object?>[];
}

class PasteSelectionAction extends SheetClipboardAction<PasteSelectionEvent> {
  PasteSelectionAction(super.event, super.controller);

  @override
  Future<void> execute() async {
    String? htmlData = await SystemClipboard.instance?.read().then((ClipboardReader reader) async {
      return reader.readValue(Formats.htmlText);
    });

    if (htmlData == null) {
      return;
    }

    // Decode HTML into a structured document.
    HtmlGoogleSheetsHtmlOrigin parsedDocument = HtmlParser.parseDocument(htmlData);

    // Convert parsed HTML back into cell properties and apply to the sheet.
    List<CellIndex> pastedCells = IndexedCellPropertiesParser(controller.data, controller.selection.value.mainCell).applyHtmlDocumentToSheet(parsedDocument);

    controller.selection.update(SheetSelectionFactory.range(start: pastedCells.first, end: pastedCells.last, completed: true));
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

class HtmlGoogleSheetsHtmlOrigin extends HtmlElement {
  HtmlGoogleSheetsHtmlOrigin({required this.table}) : super(tagName: 'google-sheets-html-origin');

  final HtmlTable table;

  @override
  String get content => table.toHtml();
}

class HtmlTable extends HtmlElement {
  HtmlTable({required this.rows}) : super(tagName: 'table');

  final List<HtmlTableRow> rows;

  @override
  String get content => rows.map((HtmlTableRow r) => r.toHtml()).join();
}

abstract class HtmlElement {
  HtmlElement({required this.tagName});

  final String tagName;

  String get content;

  Map<String, String> get attributes => <String, String>{};

  String toHtml() {
    return '<$tagName${_attributesToString()}>$content</$tagName>';
  }

  String _attributesToString() {
    if (attributes.isEmpty) {
      return '';
    }
    String attrString = attributes.entries.map((MapEntry<String, String> e) => '${e.key}="${e.value}"').join(' ');
    return ' $attrString';
  }
}

abstract class StyledHtmlElement extends HtmlElement {
  StyledHtmlElement({required super.tagName});

  Map<String, String> get styles => <String, String>{};

  @override
  String toHtml() {
    String styleStr = styles.isNotEmpty ? ' style="${_styleToString()}"' : '';
    String attrStr = attributes.isEmpty ? '' : ' ${_attributesToStringWithoutTag()}';
    return '<$tagName$styleStr$attrStr>$content</$tagName>';
  }

  String _styleToString() => styles.entries.map((MapEntry<String, String> e) => '${e.key}:${e.value}').join(';');

  String _attributesToStringWithoutTag() {
    return attributes.entries.map((MapEntry<String, String> e) => '${e.key}="${e.value}"').join(' ');
  }
}

class HtmlTableRow extends StyledHtmlElement {
  HtmlTableRow({required this.cells, required this.height}) : super(tagName: 'tr');

  final List<HtmlTableCell> cells;
  final double height;

  @override
  String get content => cells.map((HtmlTableCell c) => c.toHtml()).join();

  @override
  Map<String, String> get styles => <String, String>{'height': '${height}px'};
}

class HtmlTableCell extends StyledHtmlElement {
  HtmlTableCell({
    required this.spans,
    this.textAlign,
    this.border,
    this.backgroundColor,
    this.colSpan,
    this.rowSpan,
    this.textRotation,
  }) : super(tagName: 'td');

  final List<HtmlSpan> spans;
  final TextAlign? textAlign;
  final Border? border;
  final Color? backgroundColor;
  final int? colSpan;
  final int? rowSpan;
  final TextRotation? textRotation; // Assume TextRotation is defined elsewhere.

  @override
  String get content {
    // If multiple spans, wrap them accordingly.
    // If single span, just return its text or span toHtml().
    if (spans.length == 1) {
      return spans.first.text;
    }
    return spans.map((HtmlSpan s) => s.toHtml()).join();
  }

  @override
  Map<String, String> get styles {
    return <String, String>{
      if (textAlign != null) 'text-align': CssEncoder.encodeTextAlign(textAlign!),
      if (backgroundColor != null) 'background-color': CssEncoder.encodeColor(backgroundColor!)
    }
      ..addAll(border != null ? CssEncoder.encodeBorder(border!) : <String, String>{});
  }

  @override
  Map<String, String> get attributes {
    return <String, String>{
      if (colSpan != null && colSpan! > 1) 'colspan': colSpan.toString(),
      if (rowSpan != null && rowSpan! > 1) 'rowspan': rowSpan.toString(),
      if (textRotation != null) 'data-sheets-root': '1',
    };
  }
}

class HtmlSpan extends StyledHtmlElement {
  HtmlSpan({
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
  }) : super(tagName: 'span');

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;

  @override
  String get content => text;

  @override
  Map<String, String> get styles {
    return <String, String>{
      if (color != null) 'color': CssEncoder.encodeColor(color!),
      if (fontWeight != null) 'font-weight': CssEncoder.encodeFontWeight(fontWeight!),
      if (fontSize != null) 'font-size': '${fontSize}pt',
      if (fontFamily != null) 'font-family': fontFamily!,
      if (fontStyle != null) 'font-style': CssEncoder.encodeFontStyle(fontStyle!),
      if (textDecoration != null) 'text-decoration': CssEncoder.encodeTextDecoration(textDecoration!, textDecorationStyle),
    };
  }
}

class CssEncoder {
  static String encodeColor(Color color) {
    if (color.alpha == 0) {
      return 'transparent';
    } else if (color.alpha == 255) {
      return _colorToHex(color);
    } else {
      return _colorToRgba(color);
    }
  }

  static String encodeFontWeight(FontWeight fontWeight) => fontWeight.value.toString();

  static String encodeFontStyle(FontStyle fontStyle) => fontStyle == FontStyle.italic ? 'italic' : 'normal';

  static String encodeTextDecoration(TextDecoration textDecoration, [TextDecorationStyle? style]) {
    List<String> decorations = <String>[];
    if (textDecoration.contains(TextDecoration.underline)) {
      decorations.add('underline');
    }
    if (textDecoration.contains(TextDecoration.overline)) {
      decorations.add('overline');
    }
    if (textDecoration.contains(TextDecoration.lineThrough)) {
      decorations.add('line-through');
    }
    return decorations.join(' ');
  }

  static String encodeTextAlign(TextAlign textAlign) {
    return switch (textAlign) {
      TextAlign.center => 'center',
      TextAlign.end => 'end',
      TextAlign.justify => 'justify',
      TextAlign.left => 'left',
      TextAlign.right => 'right',
      TextAlign.start => 'start',
    };
  }

  static Map<String, String> encodeBorder(Border border) {
    Map<String, String> values = <String, String>{};
    if (border.isUniform && _shouldPaintBorder(border.top)) {
      values['border'] = '${border.top.width}px solid ${_colorToHex(border.top.color)}';
    } else {
      if (_shouldPaintBorder(border.top)) {
        values['border-top'] = '${border.top.width}px solid ${_colorToHex(border.top.color)}';
      }
      if (_shouldPaintBorder(border.right)) {
        values['border-right'] = '${border.right.width}px solid ${_colorToHex(border.right.color)}';
      }
      if (_shouldPaintBorder(border.bottom)) {
        values['border-bottom'] = '${border.bottom.width}px solid ${_colorToHex(border.bottom.color)}';
      }
      if (_shouldPaintBorder(border.left)) {
        values['border-left'] = '${border.left.width}px solid ${_colorToHex(border.left.color)}';
      }
    }
    return values;
  }

  static bool _shouldPaintBorder(BorderSide side) => side != BorderSide.none && side.width > 0;

  static String _colorToHex(Color color) => '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  static String _colorToRgba(Color color) => 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha / 255})';

  static Color? _colorFromHex(String hex) {
    String parsedHex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$parsedHex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(parsedHex, radix: 16));
    }
    return null;

  }
}

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
      return CssEncoder._colorFromHex(value);
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

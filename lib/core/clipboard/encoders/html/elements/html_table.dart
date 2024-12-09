import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_border.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_color.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_style.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_text_align.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_vertical_align.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_element.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';

class HtmlTable extends HtmlElement {
  HtmlTable({required this.rows}) : super(tagName: 'table');

  final List<HtmlTableRow> rows;

  @override
  String get content => rows.map((HtmlTableRow r) => r.toHtml()).join();

  @override
  List<Object?> get props => <Object?>[rows];
}

class HtmlTableRow extends HtmlElement {
  HtmlTableRow({
    required this.cells,
    this.height,
  }) : super(tagName: 'tr');

  HtmlTableRow.empty({double? height}) : this(cells: <HtmlTableCell>[], height: height);

  final List<HtmlTableCell> cells;
  final double? height;

  @override
  String get content => cells.map((HtmlTableCell c) => c.toHtml()).join();

  @override
  Map<String, String> get attributes {
    return <String, String>{};
  }

  @override
  List<Object?> get props => <Object?>[cells, height];
}

class HtmlTableCell extends StyledHtmlElement {
  HtmlTableCell({
    required this.spans,
    this.style,
    int? colSpan,
    int? rowSpan,
  })  : colSpan = colSpan ?? 1,
        rowSpan = rowSpan ?? 1,
        super(tagName: 'td');

  final List<HtmlSpan> spans;
  final HtmlTableStyle? style;
  final int? colSpan;
  final int? rowSpan;

  @override
  String get content {
    // If multiple spans, wrap them accordingly.
    // If single span, just return its text or span toHtml() and apply span styles to cell.
    if (spans.length == 1) {
      return spans.first.text;
    }
    return spans.map((HtmlSpan s) => s.toHtml()).join();
  }

  @override
  CssStyle get styles {
    HtmlTableStyle cellStyle = style ?? HtmlTableStyle.empty();
    if (spans.length == 1) {
      return CombinedCssStyle(styles: <CssStyle>[cellStyle, spans.first.styles]);
    }
    return cellStyle;
  }

  @override
  Map<String, String> get attributes {
    return <String, String>{
      if (colSpan != null && colSpan! > 1) 'colspan': colSpan.toString(),
      if (rowSpan != null && rowSpan! > 1) 'rowspan': rowSpan.toString(),
    };
  }

  @override
  List<Object?> get props => <Object?>[spans, style, colSpan, rowSpan];
}

class HtmlTableStyle extends CssStyle {
  HtmlTableStyle.empty()
      : textAlign = null,
        verticalAlign = null,
        border = null,
        backgroundColor = null;

  HtmlTableStyle.fromDart({
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    Border? border,
    Color? backgroundColor,
  })  : textAlign = CssTextAlign.fromDart(textAlign),
        verticalAlign = CssVerticalAlign.fromDart(textAlignVertical),
        border = CssBorder.fromDart(border),
        backgroundColor = CssBackgroundColor.fromDart(backgroundColor);

  HtmlTableStyle.fromCssMap(Map<String, String> styles)
      : textAlign = CssTextAlign.fromCssMap(styles),
        verticalAlign = CssVerticalAlign.fromCssMap(styles),
        border = CssBorder.fromCssMap(styles),
        backgroundColor = CssBackgroundColor.fromCssMap(styles);

  final CssTextAlign? textAlign;
  final CssVerticalAlign? verticalAlign;
  final CssBorder? border;
  final CssBackgroundColor? backgroundColor;

  @override
  List<CssProperty> get properties => <CssProperty>[
        if (textAlign != null) textAlign!,
        if (verticalAlign != null) verticalAlign!,
        if (border != null) border!,
        if (backgroundColor != null) backgroundColor!,
      ];
}

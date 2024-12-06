import 'package:flutter/material.dart';
import 'package:sheets/core/html/css_encoder.dart';
import 'package:sheets/core/html/elements/html_element.dart';
import 'package:sheets/core/html/elements/html_span.dart';
import 'package:sheets/utils/text_rotation.dart';

class HtmlTable extends HtmlElement {
  HtmlTable({required this.rows}) : super(tagName: 'table');

  final List<HtmlTableRow> rows;

  @override
  String get content => rows.map((HtmlTableRow r) => r.toHtml()).join();
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
  final TextRotation? textRotation;

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
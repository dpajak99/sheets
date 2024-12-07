import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_decoder.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_encoder.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_element.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/utils/text_vertical_align.dart';

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
    return <String, String>{
      if (height != null) 'height': '${height}px',
    };
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
  HtmlTableStyle get styles {
    HtmlTableStyle cellStyle = style ?? HtmlTableStyle();
    if (spans.length == 1) {
      cellStyle.addOther(spans.first.styles);
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
  List<Object?> get props => <Object?>[spans];
}

class HtmlTableStyle extends CssStyle {
  HtmlTableStyle({
    TextAlign? textAlign,
    TextVerticalAlign? textVerticalAlign,
    Border? border,
    Color? backgroundColor,
  }) : super.css(<String, String>{
          if (textAlign != null) 'text-align': CssEncoder.encodeTextAlign(textAlign),
          if (textVerticalAlign != null) 'vertical-align': CssEncoder.encodeTextAlignVertical(textVerticalAlign),
          if (backgroundColor != null) 'background-color': CssEncoder.encodeColor(backgroundColor),
          if (border != null) ...CssEncoder.encodeBorder(border),
        });

  HtmlTableStyle.css(super.styles) : super.css();

  static const List<String> kSupportedStyles = <String>[
    'text-align',
    'border',
    'border-top',
    'border-right',
    'border-bottom',
    'border-left',
    'background-color',
    'vertical-align',
    ...HtmlSpanStyle.kSupportedStyles
  ];

  TextAlign? get textAlign {
    return CssDecoder.decodeTextAlign(styles['text-align']);
  }

  TextVerticalAlign? get textVerticalAlign {
    return CssDecoder.decodeTextVerticalAlign(styles['vertical-align']);
  }

  Border? get border {
    String? borderValue = styles['border'];
    if (borderValue != null) {
      return CssDecoder.decodeBorder(borderValue);
    }

    // Otherwise, check 'border-top', 'border-right', 'border-bottom', 'border-left'
    BorderSide? top = CssDecoder.decodeBorderSide(styles['border-top']);
    BorderSide? right = CssDecoder.decodeBorderSide(styles['border-right']);
    BorderSide? bottom = CssDecoder.decodeBorderSide(styles['border-bottom']);
    BorderSide? left = CssDecoder.decodeBorderSide(styles['border-left']);

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

  Color? get backgroundColor {
    return CssDecoder.decodeColor(styles['background-color']);
  }

  @override
  List<String> get supportedStyles => kSupportedStyles;

  @override
  List<Object?> get props => <Object?>[textAlign, border, backgroundColor];
}

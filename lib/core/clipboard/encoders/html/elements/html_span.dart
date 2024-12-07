import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_decoder.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_encoder.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_element.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class HtmlSpan extends StyledHtmlElement {
  HtmlSpan({
    required this.text,
    this.style,
  }) : super(tagName: 'span');

  final String text;
  final HtmlSpanStyle? style;

  @override
  String get content => text;

  @override
  HtmlSpanStyle get styles => style ?? HtmlSpanStyle();

  @override
  List<Object?> get props => <Object?>[text, style];
}

class HtmlSpanStyle extends CssStyle {
  HtmlSpanStyle({
    Color? color,
    FontWeight? fontWeight,
    FontSize? fontSize,
    String? fontFamily,
    FontStyle? fontStyle,
    TextDecoration? textDecoration,
  }) : super.css(<String, String>{
          if (color != null) 'color': CssEncoder.encodeColor(color),
          if (fontWeight != null) 'font-weight': CssEncoder.encodeFontWeight(fontWeight),
          if (fontSize != null) 'font-size': fontSize.asString(FontSizeUnit.pt),
          if (fontFamily != null) 'font-family': fontFamily,
          if (fontStyle != null) 'font-style': CssEncoder.encodeFontStyle(fontStyle),
          if (textDecoration != null) 'text-decoration': CssEncoder.encodeTextDecoration(textDecoration),
        });

  HtmlSpanStyle.css(super.styles) : super.css();

  static const List<String> kSupportedStyles = <String>[
    'color',
    'font-weight',
    'font-size',
    'font-family',
    'font-style',
    'text-decoration',
  ];

  Color? get color {
    return CssDecoder.decodeColor(styles['color']);
  }

  FontWeight? get fontWeight {
    return CssDecoder.decodeFontWeight(styles['font-weight']);
  }

  FontSize? get fontSize {
    return CssDecoder.decodeFontSize(styles['font-size']);
  }

  String? get fontFamily {
    return styles['font-family'];
  }

  FontStyle? get fontStyle {
    return CssDecoder.decodeFontStyle(styles['font-style']);
  }

  @override
  List<String> get supportedStyles => kSupportedStyles;

  TextDecoration? get textDecoration {
    return CssDecoder.decodeTextDecoration(styles['text-decoration']).decoration;
  }
}

import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_color.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_double.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_font_style.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_font_weignt.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_string.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_style.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_text_decoration.dart';
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
  HtmlSpanStyle get styles => style ?? HtmlSpanStyle.empty();

  @override
  List<Object?> get props => <Object?>[text, style];
}

class HtmlSpanStyle extends CssStyle {
  HtmlSpanStyle.empty()
      : color = null,
        fontWeight = null,
        fontSize = null,
        fontFamily = null,
        fontStyle = null,
        textDecoration = null;

  HtmlSpanStyle.fromDart({
    Color? color,
    FontWeight? fontWeight,
    FontSize? fontSize,
    String? fontFamily,
    FontStyle? fontStyle,
    TextDecoration? textDecoration,
  })  : color = CssColor.fromDart(color),
        fontWeight = CssFontWeight.fromDart(fontWeight),
        fontSize = CssFontSize.fromDart(fontSize),
        fontFamily = CssFontFamily.fromDart(fontFamily),
        fontStyle = CssFontStyle.fromDart(fontStyle),
        textDecoration = CssTextDecoration.fromDart(textDecoration);

  HtmlSpanStyle.fromCssMap(Map<String, String> map)
      : color = CssColor.fromCssMap(map),
        fontWeight = CssFontWeight.fromCssMap(map),
        fontSize = CssFontSize.fromCssMap(map),
        fontFamily = CssFontFamily.fromCssMap(map),
        fontStyle = CssFontStyle.fromCssMap(map),
        textDecoration = CssTextDecoration.fromCssMap(map);

  final CssColor? color;
  final CssFontWeight? fontWeight;
  final CssFontSize? fontSize;
  final CssFontFamily? fontFamily;
  final CssFontStyle? fontStyle;
  final CssTextDecoration? textDecoration;

  @override
  List<CssProperty> get properties => <CssProperty>[
        if (color != null) color!,
        if (fontWeight != null) fontWeight!,
        if (fontSize != null) fontSize!,
        if (fontFamily != null) fontFamily!,
        if (fontStyle != null) fontStyle!,
        if (textDecoration != null) textDecoration!,
      ];
}

import 'package:flutter/material.dart';
import 'package:sheets/core/html/css_encoder.dart';
import 'package:sheets/core/html/elements/html_element.dart';

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

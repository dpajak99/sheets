import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_double.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_span.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('HtmlSpan', () {
    test('renders correctly with default empty style', () {
      HtmlSpan span = HtmlSpan(text: 'Hello, World!');

      String result = span.toHtml();

      expect(result, '<span>Hello, World!</span>');
    });

    test('renders correctly with custom style', () {
      HtmlSpanStyle style = HtmlSpanStyle.fromDart(
        color: const Color(0xFFFF0000),
        fontWeight: FontWeight.bold,
        fontSize: const FontSize.fromPoints(12),
        fontFamily: 'Arial',
        fontStyle: FontStyle.italic,
        textDecoration: TextDecoration.underline,
      );

      HtmlSpan span = HtmlSpan(
        text: 'Styled Text',
        style: style,
      );

      String result = span.toHtml();

      expect(
        result,
        '<span style="color:#ff0000;font-weight:bold;font-size:12.0pt;font-family:Arial;font-style:italic;text-decoration:underline">Styled Text</span>',
      );
    });

    test('renders correctly without a style', () {
      HtmlSpan span = HtmlSpan(
        text: 'Plain Text',
      );

      String result = span.toHtml();

      expect(result, '<span>Plain Text</span>');
    });
  });

  group('HtmlSpanStyle', () {
    test('creates an empty style', () {
      HtmlSpanStyle style = HtmlSpanStyle.empty();

      expect(style.properties, isEmpty);
    });

    test('creates a style from Dart properties', () {
      HtmlSpanStyle style = HtmlSpanStyle.fromDart(
        color: const Color(0xFF0000FF),
        fontWeight: FontWeight.w500,
        fontSize: const FontSize.fromPoints(14),
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        textDecoration: TextDecoration.lineThrough,
      );

      Map<String, String> cssMap = style.propertiesMap;

      expect(cssMap['color'], '#0000ff');
      expect(cssMap['font-weight'], '500');
      expect(cssMap['font-size'], '14.0pt');
      expect(cssMap['font-family'], 'Roboto');
      expect(cssMap['font-style'], 'normal');
      expect(cssMap['text-decoration'], 'line-through');
    });

    test('creates a style from CSS map', () {
      Map<String, String> cssMap = <String, String>{
        'color': '#00ff00',
        'font-weight': 'bold',
        'font-size': '16pt',
        'font-family': 'Verdana',
        'font-style': 'italic',
        'text-decoration': 'overline',
      };

      HtmlSpanStyle style = HtmlSpanStyle.fromCssMap(cssMap);

      expect(style.color!.value.toCss(), '#00ff00');
      expect(style.fontWeight!.value.toCss(), 'bold');
      expect(style.fontSize!.value.toCss(CssDoubleUnit.pt), '16.0pt');
      expect(style.fontFamily!.value.toCss(), 'Verdana');
      expect(style.fontStyle!.value.toCss(), 'italic');
      expect(style.textDecoration!.value.toCss(), 'overline');
    });
  });
}

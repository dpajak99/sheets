// import 'package:flutter/material.dart';
// import 'package:html/dom.dart' as html_dom;
// import 'package:html/parser.dart' as html_parser;
// import 'package:sheets/core/values/sheet_text_span.dart';
//
// class HtmlSpanParser {
//   SheetTextSpan parse(String htmlString) {
//     html_dom.Document document = html_parser.parse(htmlString);
//     html_dom.Element rootSpan = document.getElementsByTagName('span').first;
//
//     return _parseElementToCustomSpan(rootSpan);
//   }
//
//   SheetTextSpan _parseElementToCustomSpan(html_dom.Element element, {TextStyle? parentStyle}) {
//     TextStyle htmlStyle = _parseStyle(element.attributes['style'])!;
//     TextStyle style = parentStyle?.merge(htmlStyle) ?? htmlStyle;
//
//     List<SheetTextSpan> children = <SheetTextSpan>[];
//
//     for (html_dom.Node node in element.nodes) {
//       if (node is html_dom.Element && node.localName == 'span') {
//         children.add(_parseElementToCustomSpan(node, parentStyle: style));
//       } else if (node is html_dom.Text) {
//         children.add(SheetTextSpan(text: node.text, style: style));
//       }
//     }
//
//     return SheetTextSpan(
//       style: style,
//       children: children,
//       text: children.isEmpty ? element.text : '',
//     );
//   }
//
//   TextStyle? _parseStyle(String? styleString) {
//     if (styleString == null) {
//       return null;
//     }
//
//     Map<String, String> styleMap = <String, String>{};
//     styleString.split(';').forEach((String style) {
//       if (style.trim().isEmpty) {
//         return;
//       }
//       List<String> keyValue = style.split(':');
//       if (keyValue.length == 2) {
//         String key = keyValue[0].trim();
//         String value = keyValue[1].trim();
//         styleMap[key] = value;
//       }
//     });
//
//     return TextStyle(
//       fontSize: _parseFontSize(styleMap['font-size']),
//       fontWeight: _parseFontWeight(styleMap['font-weight']),
//       fontStyle: _parseFontStyle(styleMap['font-style']),
//       color: _parseColor(styleMap['color']),
//       fontFamily: styleMap['font-family'],
//     );
//   }
//
//   double? _parseFontSize(String? fontSize) {
//     if (fontSize == null) {
//       return null;
//     }
//     if (fontSize.endsWith('pt')) {
//       double? points = double.tryParse(fontSize.replaceAll('pt', ''));
//       if (points != null) {
//         return points * 1.3333;
//       }
//     }
//     return null;
//   }
//
//   FontWeight? _parseFontWeight(String? fontWeight) {
//     if (fontWeight == null) {
//       return null;
//     }
//     switch (fontWeight.toLowerCase()) {
//       case 'bold':
//         return FontWeight.bold;
//       case 'normal':
//         return FontWeight.normal;
//       default:
//         return null;
//     }
//   }
//
//   FontStyle? _parseFontStyle(String? fontStyle) {
//     if (fontStyle == null) {
//       return null;
//     }
//     switch (fontStyle.toLowerCase()) {
//       case 'italic':
//         return FontStyle.italic;
//       case 'normal':
//         return FontStyle.normal;
//       default:
//         return null;
//     }
//   }
//
//   Color? _parseColor(String? colorString) {
//     if (colorString == null) {
//       return null;
//     }
//     if (colorString.startsWith('#')) {
//       String hexColor = colorString.replaceFirst('#', '');
//       if (hexColor.length == 6) {
//         hexColor = 'FF$hexColor';
//       }
//       int? colorInt = int.tryParse(hexColor, radix: 16);
//       if (colorInt != null) {
//         return Color(colorInt);
//       }
//     }
//     return null;
//   }
// }

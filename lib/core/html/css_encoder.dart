import 'package:flutter/material.dart';

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

  static Color? colorFromHex(String hex) {
    String parsedHex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$parsedHex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(parsedHex, radix: 16));
    }
    return null;

  }
}

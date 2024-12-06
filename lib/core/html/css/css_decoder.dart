import 'package:flutter/material.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/text_vertical_align.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';

class CssDecoder {
  static Map<String, String> decodeAttributes(String? style) {
    if (style == null) {
      return <String, String>{};
    }
    Map<String, String> attributes = <String, String>{};
    List<String> parts = style.split(';');
    for (String part in parts) {
      List<String> keyValue = part.split(':');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        attributes[key] = value;
      }
    }
    return attributes;
  }

  static TextVerticalAlign decodeTextVerticalAlign(String? value) {
    if (value == null) {
      return TextVerticalAlign.top;
    }
    return switch (value) {
      'top' => TextVerticalAlign.top,
      'middle' => TextVerticalAlign.center,
      'bottom' => TextVerticalAlign.bottom,
      (_) => TextVerticalAlign.top,
    };
  }

  static Color? decodeColor(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value == 'transparent') {
      return Colors.transparent;
    }
    if (value.startsWith('#')) {
      return _colorFromHex(value);
    }
    if (value.startsWith('rgba')) {
      return _colorFromRgba(value);
    }

    return null;
  }

  static double? decodeDouble(String? value) {
    if (value == null) {
      return null;
    }
    return double.tryParse(value);
  }

  static int? decodeInteger(String? value) {
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  static TextDecorationParseResult decodeTextDecoration(String? value) {
    if (value == null) {
      return TextDecorationParseResult(null, null);
    }
    List<String> parts = value.split(' ');
    List<TextDecoration> decorations = <TextDecoration>[];
    for (String p in parts) {
      decorations.add(switch (p) {
        'underline' => TextDecoration.underline,
        'overline' => TextDecoration.overline,
        'line-through' => TextDecoration.lineThrough,
        (_) => TextDecoration.none,
      });
    }
    return TextDecorationParseResult(TextDecoration.combine(decorations), null);
  }

  static FontWeight? decodeFontWeight(String? value) {
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

  static FontStyle? decodeFontStyle(String? value) {
    if (value == null) {
      return null;
    }
    return (value == 'italic') ? FontStyle.italic : FontStyle.normal;
  }

  static TextAlign? decodeTextAlign(String? value) {
    if (value == null) {
      return null;
    }
    return switch (value) {
      'center' => TextAlign.center,
      'end' => TextAlign.end,
      'justify' => TextAlign.justify,
      'left' => TextAlign.left,
      'right' => TextAlign.right,
      'start' => TextAlign.start,
      (_) => null,
    };
  }

  static FontSize? decodeFontSize(String? value) {
    if (value == null) {
      return null;
    }
    return FontSize.fromString(value);
  }

  static Border decodeBorder(String borderValue) {
    BorderSide side = CssDecoder.decodeBorderSide(borderValue) ?? BorderSide.none;
    return Border.fromBorderSide(side);
  }

  static BorderSide? decodeBorderSide(String? value) {
    if (value == null) {
      return null;
    }
    List<String> parts = value.split(' ').map((String p) => p.trim()).where((String p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      return null;
    }

    double? width;
    Color? color;

    for (String part in parts) {
      if (part.endsWith('px')) {
        width = double.tryParse(part.replaceAll('px', '')) ?? 1.0;
      } else if (part.startsWith('#') || part.startsWith('rgba') || part.startsWith('rgb')) {
        Color? decodedColor = CssDecoder.decodeColor(part);
        if (decodedColor != null) {
          color = decodedColor;
        }
      }
    }

    return MaterialSheetTheme.defaultBorderSide.copyWith(color: color, width: width);
  }

  static Color? _colorFromHex(String hex) {
    String parsedHex = hex.replaceAll('#', '');
    if (parsedHex.length == 6) {
      return Color(int.parse('FF$parsedHex', radix: 16));
    } else if (parsedHex.length == 8) {
      return Color(int.parse(parsedHex, radix: 16));
    }
    return null;
  }

  static Color? _colorFromRgba(String value) {
    RegExpMatch? rgba = RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)').firstMatch(value);
    if (rgba != null) {
      int r = int.parse(rgba.group(1)!);
      int g = int.parse(rgba.group(2)!);
      int b = int.parse(rgba.group(3)!);
      int a = (double.parse(rgba.group(4)!) * 255).toInt();
      return Color.fromARGB(a, r, g, b);
    }
    return null;
  }
}

class TextDecorationParseResult {
  TextDecorationParseResult(this.decoration, this.style);

  final TextDecoration? decoration;
  final TextDecorationStyle? style;
}

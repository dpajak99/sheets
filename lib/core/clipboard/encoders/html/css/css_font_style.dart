import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssFontStyle extends CssProperty<FontStyle, CssFontStyleValue> {
  CssFontStyle._(super.value);

  static const List<String> supportedProperties = <String>[
    'font-style',
  ];

  static CssFontStyle? fromDart(FontStyle? fontStyle) {
    if (fontStyle == null) {
      return null;
    }
    CssFontStyleValue value = CssFontStyleValue.fromDart(fontStyle);
    return CssFontStyle._(value);
  }

  static CssFontStyle? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }
    CssFontStyleValue value = CssFontStyleValue.fromCss(map['font-style']!);
    return CssFontStyle._(value);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'font-style': value.toCss()};
  }
}

class CssFontStyleValue extends CssValue<FontStyle> {
  CssFontStyleValue._(this._value, this._css);

  static CssFontStyleValue fromCss(String value) {
    if (value == 'italic') {
      return CssFontStyleValue.italic;
    } else {
      return CssFontStyleValue.normal;
    }
  }

  static CssFontStyleValue fromDart(FontStyle value) {
    return switch (value) {
      FontStyle.normal => CssFontStyleValue.normal,
      FontStyle.italic => CssFontStyleValue.italic,
    };
  }

  static final CssFontStyleValue normal = CssFontStyleValue._(FontStyle.normal, 'normal');
  static final CssFontStyleValue italic = CssFontStyleValue._(FontStyle.italic, 'italic');

  final FontStyle _value;
  final String _css;

  @override
  FontStyle toDart() => _value;

  String toCss() => _css;
}

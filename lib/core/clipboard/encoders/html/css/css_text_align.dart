import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssTextAlign extends CssProperty<TextAlign, CssTextAlignValue> {
  CssTextAlign._(super.value);

  static const List<String> supportedProperties = <String>['text-align'];

  static CssTextAlign? fromDart(TextAlign? textAlign) {
    if (textAlign == null) {
      return null;
    }
    CssTextAlignValue value = CssTextAlignValue.fromDart(textAlign);
    return CssTextAlign._(value);
  }

  static CssTextAlign? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }
    CssTextAlignValue value = CssTextAlignValue.fromCss(map['text-align']!);
    return CssTextAlign._(value);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'text-align': value.toCss()};
  }
}

class CssTextAlignValue extends CssValue<TextAlign> {
  CssTextAlignValue._(this._dart, this._css);

  static CssTextAlignValue fromCss(String value) {
    return switch (value) {
      'left' => CssTextAlignValue.left,
      'right' => CssTextAlignValue.right,
      'center' => CssTextAlignValue.center,
      'justify' => CssTextAlignValue.justify,
      'start' => CssTextAlignValue.start,
      'end' => CssTextAlignValue.end,
      (_) => throw Exception('Unknown value: $value'),
    };
  }

  static CssTextAlignValue fromDart(TextAlign value) {
    return switch (value) {
      TextAlign.left => CssTextAlignValue.left,
      TextAlign.right => CssTextAlignValue.right,
      TextAlign.center => CssTextAlignValue.center,
      TextAlign.justify => CssTextAlignValue.justify,
      TextAlign.start => CssTextAlignValue.start,
      TextAlign.end => CssTextAlignValue.end,
    };
  }

  static final CssTextAlignValue left = CssTextAlignValue._(TextAlign.left, 'left');
  static final CssTextAlignValue right = CssTextAlignValue._(TextAlign.right, 'right');
  static final CssTextAlignValue center = CssTextAlignValue._(TextAlign.center, 'center');
  static final CssTextAlignValue justify = CssTextAlignValue._(TextAlign.justify, 'justify');
  static final CssTextAlignValue start = CssTextAlignValue._(TextAlign.start, 'start');
  static final CssTextAlignValue end = CssTextAlignValue._(TextAlign.end, 'end');

  final TextAlign _dart;
  final String _css;

  @override
  TextAlign toDart() => _dart;

  String toCss() => _css;
}

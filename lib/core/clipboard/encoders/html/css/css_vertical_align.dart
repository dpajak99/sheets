import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssVerticalAlign extends CssProperty<TextAlignVertical, CssVerticalAlignValue> {
  CssVerticalAlign._(super.value);

  static const List<String> supportedProperties = <String>['vertical-align'];

  static CssVerticalAlign? fromDart(TextAlignVertical? verticalAlign) {
    if (verticalAlign == null) {
      return null;
    }
    CssVerticalAlignValue value = CssVerticalAlignValue.fromDart(verticalAlign);
    return CssVerticalAlign._(value);
  }

  static CssVerticalAlign? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }
    CssVerticalAlignValue value = CssVerticalAlignValue.fromCss(map['vertical-align']!);
    return CssVerticalAlign._(value);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'vertical-align': value.toCss()};
  }
}

class CssVerticalAlignValue extends CssValue<TextAlignVertical> {
  CssVerticalAlignValue._(this._value, this._css);

  static CssVerticalAlignValue fromCss(String value) {
    return switch (value) {
      'top' => CssVerticalAlignValue.top,
      'middle' => CssVerticalAlignValue.middle,
      'bottom' => CssVerticalAlignValue.bottom,
      (_) => throw Exception('Unknown value: $value'),
    };
  }

  static CssVerticalAlignValue fromDart(TextAlignVertical value) {
    return switch (value) {
      TextAlignVertical.top => CssVerticalAlignValue.top,
      TextAlignVertical.center => CssVerticalAlignValue.middle,
      TextAlignVertical.bottom => CssVerticalAlignValue.bottom,
      (_) => throw Exception('Unknown value: $value'),
    };
  }

  static final CssVerticalAlignValue top = CssVerticalAlignValue._(TextAlignVertical.top, 'top');
  static final CssVerticalAlignValue middle = CssVerticalAlignValue._(TextAlignVertical.center, 'middle');
  static final CssVerticalAlignValue bottom = CssVerticalAlignValue._(TextAlignVertical.bottom, 'bottom');

  final TextAlignVertical _value;
  final String _css;

  @override
  TextAlignVertical toDart() => _value;

  String toCss() => _css;

  bool get isDefault => this == CssVerticalAlignValue.bottom;
}

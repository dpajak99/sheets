import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssFontWeight extends CssProperty<FontWeight, CssFontWeightValue> {
  CssFontWeight._(super.value);

  static const List<String> supportedProperties = <String>[
    'font-weight',
  ];

  static CssFontWeight? fromDart(FontWeight? fontWeight) {
    if (fontWeight == null) {
      return null;
    }
    CssFontWeightValue value = CssFontWeightValue.fromDart(fontWeight);
    return CssFontWeight._(value);
  }

  static CssFontWeight? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }
    CssFontWeightValue? fontWeight = CssFontWeightValue.fromCss(map['font-weight']);
    return CssFontWeight._(fontWeight!);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'font-weight': value.toCss()};
  }
}

class CssFontWeightValue extends CssValue<FontWeight> {
  CssFontWeightValue._(this._value, this._css);

  factory CssFontWeightValue.custom(int value) {
    FontWeight fontWeight = FontWeight.values.firstWhere((FontWeight w) => w.value == value, orElse: () => FontWeight.normal);
    return CssFontWeightValue._(fontWeight, value.toString());
  }

  static CssFontWeightValue? fromCss(String? value) {
    if (value == null) {
      return null;
    }

    if (value == 'bold') {
      return CssFontWeightValue.bold;
    } else if (value == 'normal') {
      return CssFontWeightValue.normal;
    }
    int? numeric = int.tryParse(value);
    if (numeric != null) {
      return CssFontWeightValue.custom(numeric);
    }
    throw Exception('Unknown value: $value');
  }

  static CssFontWeightValue fromDart(FontWeight value) {
    return switch (value) {
      FontWeight.normal => CssFontWeightValue.normal,
      FontWeight.bold => CssFontWeightValue.bold,
      (_) => CssFontWeightValue.custom(value.value),
    };
  }

  static final CssFontWeightValue normal = CssFontWeightValue._(FontWeight.normal, 'normal');
  static final CssFontWeightValue bold = CssFontWeightValue._(FontWeight.bold, 'bold');

  final FontWeight _value;
  final String _css;

  @override
  FontWeight toDart() => _value;

  String toCss() => _css;
}

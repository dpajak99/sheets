import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssTextDecoration extends CssProperty<TextDecoration, CssTextDecorationValue> {
  CssTextDecoration._(super.value);

  static const List<String> supportedProperties = <String>['text-decoration'];

  static CssTextDecoration? fromDart(TextDecoration? textDecoration) {
    if (textDecoration == null) {
      return null;
    }
    CssTextDecorationValue value = CssTextDecorationValue.fromDart(textDecoration);
    return CssTextDecoration._(value);
  }

  static CssTextDecoration? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }

    CssTextDecorationValue value = CssTextDecorationValue.fromCss(map['text-decoration']!);
    return CssTextDecoration._(value);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'text-decoration': value.toCss()};
  }
}

class CssTextDecorationValue extends CssValue<TextDecoration> {
  CssTextDecorationValue._(this._value, this._css);

  static CssTextDecorationValue fromCss(String value) {
    List<String> values = value.split(' ');
    List<CssTextDecorationValue> cssValues = values
        .map((String v) => switch (v) {
              'none' => CssTextDecorationValue.none,
              'underline' => CssTextDecorationValue.underline,
              'overline' => CssTextDecorationValue.overline,
              'line-through' => CssTextDecorationValue.lineThrough,
              (_) => throw Exception('Unknown value: $value'),
            })
        .toList();
    return fromDartValues(cssValues.map((CssTextDecorationValue v) => v.toDart()).toList());
  }

  static CssTextDecorationValue fromDart(TextDecoration value) {
    return switch (value) {
      TextDecoration.none => CssTextDecorationValue.none,
      TextDecoration.underline => CssTextDecorationValue.underline,
      TextDecoration.overline => CssTextDecorationValue.overline,
      TextDecoration.lineThrough => CssTextDecorationValue.lineThrough,
      (_) => () {
          List<TextDecoration> values = <TextDecoration>[
            if (value.contains(TextDecoration.underline)) TextDecoration.underline,
            if (value.contains(TextDecoration.overline)) TextDecoration.overline,
            if (value.contains(TextDecoration.lineThrough)) TextDecoration.lineThrough,
          ];
          return CssTextDecorationValue.fromDartValues(values);
        }(),
    };
  }

  static CssTextDecorationValue fromDartValues(List<TextDecoration> values) {
    try {
      List<CssTextDecorationValue> cssValues = values.map(fromDart).toList();
      return CssTextDecorationValue._(
        TextDecoration.combine(values),
        cssValues.map((CssTextDecorationValue v) => v.toCss()).join(' '),
      );
    } catch (e) {
      throw Exception('fromDartValues: Unknown value: $values');
    }
  }

  static final CssTextDecorationValue none = CssTextDecorationValue._(TextDecoration.none, 'none');
  static final CssTextDecorationValue underline = CssTextDecorationValue._(TextDecoration.underline, 'underline');
  static final CssTextDecorationValue overline = CssTextDecorationValue._(TextDecoration.overline, 'overline');
  static final CssTextDecorationValue lineThrough = CssTextDecorationValue._(TextDecoration.lineThrough, 'line-through');

  final TextDecoration _value;
  final String _css;

  @override
  TextDecoration toDart() => _value;

  String toCss() => _css;
}

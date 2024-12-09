import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class CssFontSize extends CssProperty<double, CssDoubleValue> {
  CssFontSize._(super.value);

  static const List<String> supportedProperties = <String>[
    'font-size',
  ];

  static CssFontSize? fromDart(FontSize? fontSize) {
    if (fontSize == null) {
      return null;
    }
    CssDoubleValue size = CssDoubleValue.fromPoints(fontSize.pt);
    return CssFontSize._(size);
  }

  static CssFontSize? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }

    CssDoubleValue? size = CssDoubleValue.fromCss(map['font-size']!);
    return CssFontSize._(size);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'font-size': value.toCss(CssDoubleUnit.pt)};
  }
}

enum CssDoubleUnit { pt, px }

class CssDoubleValue extends CssValue<double> {
  CssDoubleValue.fromPixels(this._value) : _unit = CssDoubleUnit.px;

  CssDoubleValue.fromPoints(this._value) : _unit = CssDoubleUnit.pt;

  factory CssDoubleValue.fromCss(String value) {
    if (value.endsWith('pt')) {
      return CssDoubleValue.fromPoints(double.parse(value.substring(0, value.length - 2)));
    } else if (value.endsWith('px')) {
      return CssDoubleValue.fromPixels(double.parse(value.substring(0, value.length - 2)));
    } else {
      throw ArgumentError('Invalid font size string: $value');
    }
  }

  static bool canParseCss(String value) {
    return value.endsWith('pt') || value.endsWith('px');
  }

  final double _value;
  final CssDoubleUnit _unit;

  @override
  double toDart() => _value;

  String toCss(CssDoubleUnit unit) {
    return switch (unit) {
      CssDoubleUnit.pt => '${pt}pt',
      CssDoubleUnit.px => '${px}px',
    };
  }

  double get pt {
    if (_unit == CssDoubleUnit.pt) {
      return _value;
    } else {
      return _pxToPt(_value);
    }
  }

  double get px {
    if (_unit == CssDoubleUnit.px) {
      return _value;
    } else {
      return _ptToPx(_value);
    }
  }

  double _pxToPt(double px) {
    return px / 96 * 72;
  }

  double _ptToPx(double pt) {
    return pt / 72 * 96;
  }
}

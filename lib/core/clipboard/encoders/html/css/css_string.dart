import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssFontFamily extends CssProperty<String, CssStringValue> {
  CssFontFamily._(super.value);

  static const List<String> supportedProperties = <String>['font-family'];

  static CssFontFamily? fromDart(String? value) {
    if (value == null) {
      return null;
    }
    CssStringValue stringValue = CssStringValue.fromDart(value);
    return CssFontFamily._(stringValue);
  }

  static CssFontFamily? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }

    CssStringValue? stringValue = CssStringValue.fromCss(map['font-family']);
    return CssFontFamily._(stringValue!);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'font-family': value.toCss()};
  }
}

class CssStringValue extends CssValue<String> {
  CssStringValue._(this._value);

  static CssStringValue? fromCss(String? value) {
    if (value == null) {
      return null;
    }
    return CssStringValue._(value);
  }

  static CssStringValue fromDart(String value) {
    return CssStringValue._(value);
  }

  final String _value;

  @override
  String toDart() => _value;

  String toCss() => _value;
}

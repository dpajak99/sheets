import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_style.dart';

class MockCssProperty extends CssProperty<String, MockCssValue> {
  MockCssProperty(super.value);

  @override
  Map<String, String> toCssMap() => <String, String>{value.key: value.value};
}

class MockCssValue extends CssValue<String> {
  MockCssValue(this.key, this.value);

  final String key;
  final String value;

  @override
  String toDart() => value;
}

void main() {
  group('CssStyle', () {
    test('decodeProperties parses valid CSS properties', () {
      String style = 'color: red; font-size: 16px;';

      Map<String, String> result = CssStyle.decodeProperties(style);

      expect(result, <String, String>{
        'color': 'red',
        'font-size': '16px',
      });
    });

    test('decodeProperties handles empty input', () {
      String style = '';

      Map<String, String> result = CssStyle.decodeProperties(style);

      expect(result, <String, String>{});
    });

    test('decodeProperties ignores invalid properties', () {
      String style = 'color: red; invalid-property; font-size: 16px:extra;';

      Map<String, String> result = CssStyle.decodeProperties(style);

      expect(result, <String, String>{
        'color': 'red',
      });
    });

    test('CombinedCssStyle combines properties from multiple styles', () {
      MockCssProperty property1 = MockCssProperty(MockCssValue('color', 'red'));
      MockCssProperty property2 = MockCssProperty(MockCssValue('font-size', '16px'));

      CssStyle style1 = _MockCssStyle(properties: <CssProperty<dynamic, CssValue<dynamic>>>[property1]);
      CssStyle style2 = _MockCssStyle(properties: <CssProperty<dynamic, CssValue<dynamic>>>[property2]);

      CombinedCssStyle combinedStyle = CombinedCssStyle(styles: <CssStyle>[style1, style2]);

      Map<String, String> combinedProperties = combinedStyle.propertiesMap;

      expect(combinedProperties, <String, String>{
        'color': 'red',
        'font-size': '16px',
      });
    });

    test('CombinedCssStyle handles empty styles', () {
      CombinedCssStyle combinedStyle = CombinedCssStyle(styles: <CssStyle>[]);

      expect(combinedStyle.properties, isEmpty);
      expect(combinedStyle.propertiesMap, isEmpty);
    });

    test('CombinedCssStyle with duplicate keys uses last defined property', () {
      MockCssProperty property1 = MockCssProperty(MockCssValue('color', 'red'));
      MockCssProperty property2 = MockCssProperty(MockCssValue('color', 'blue'));

      CssStyle style1 = _MockCssStyle(properties: <CssProperty<dynamic, CssValue<dynamic>>>[property1]);
      CssStyle style2 = _MockCssStyle(properties: <CssProperty<dynamic, CssValue<dynamic>>>[property2]);

      CombinedCssStyle combinedStyle = CombinedCssStyle(styles: <CssStyle>[style1, style2]);

      Map<String, String> combinedProperties = combinedStyle.propertiesMap;

      expect(combinedProperties, <String, String>{
        'color': 'blue',
      });
    });
  });
}

class _MockCssStyle extends CssStyle {
  _MockCssStyle({required this.properties});

  @override
  final List<CssProperty> properties;
}

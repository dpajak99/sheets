import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_string.dart';

void main() {
  group('CssFontFamily', () {
    group('fromDart', () {
      test('should return null when font-family is null', () {
        // Act
        CssFontFamily? cssFontFamily = CssFontFamily.fromDart(null);

        // Assert
        expect(cssFontFamily, isNull);
      });

      test('should create CssFontFamily from a Dart string', () {
        // Act
        CssFontFamily? cssFontFamily = CssFontFamily.fromDart('Arial');

        // Assert
        expect(cssFontFamily?.toCssMap(), <String, String>{'font-family': 'Arial'});
      });
    });

    group('fromCssMap', () {
      test('should return null when no supported property is present', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': '#000000'};

        // Act
        CssFontFamily? cssFontFamily = CssFontFamily.fromCssMap(cssMap);

        // Assert
        expect(cssFontFamily, isNull);
      });

      test('should parse font-family from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-family': 'Times New Roman'};

        // Act
        CssFontFamily? cssFontFamily = CssFontFamily.fromCssMap(cssMap);

        // Assert
        expect(cssFontFamily?.toCssMap(), <String, String>{'font-family': 'Times New Roman'});
      });

      test('should parse font-family with quotes from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-family': '"Courier New"'};

        // Act
        CssFontFamily? cssFontFamily = CssFontFamily.fromCssMap(cssMap);

        // Assert
        expect(cssFontFamily?.toCssMap(), <String, String>{'font-family': '"Courier New"'});
      });
    });

    group('toCssMap', () {
      test('should return correct CSS map for font-family', () {
        // Arrange
        CssFontFamily cssFontFamily = CssFontFamily.fromDart('Verdana')!;

        // Act
        Map<String, String> cssMap = cssFontFamily.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-family': 'Verdana'});
      });

      test('should return correct CSS map for font-family with quotes', () {
        // Arrange
        CssFontFamily cssFontFamily = CssFontFamily.fromDart('"Comic Sans MS"')!;

        // Act
        Map<String, String> cssMap = cssFontFamily.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-family': '"Comic Sans MS"'});
      });
    });
  });

  group('CssStringValue', () {
    group('fromCss', () {
      test('should return null when value is null', () {
        // Act
        CssStringValue? cssStringValue = CssStringValue.fromCss(null);

        // Assert
        expect(cssStringValue, isNull);
      });

      test('should create CssStringValue from a CSS string', () {
        // Act
        CssStringValue? cssStringValue = CssStringValue.fromCss('Georgia');

        // Assert
        expect(cssStringValue?.toDart(), 'Georgia');
        expect(cssStringValue?.toCss(), 'Georgia');
      });
    });

    group('fromDart', () {
      test('should create CssStringValue from a Dart string', () {
        // Act
        CssStringValue cssStringValue = CssStringValue.fromDart('Helvetica');

        // Assert
        expect(cssStringValue.toDart(), 'Helvetica');
        expect(cssStringValue.toCss(), 'Helvetica');
      });
    });

    group('toCss', () {
      test('should return the correct CSS string', () {
        // Arrange
        CssStringValue cssStringValue = CssStringValue.fromDart('Tahoma');

        // Act
        String css = cssStringValue.toCss();

        // Assert
        expect(css, 'Tahoma');
      });

      test('should return the correct CSS string with quotes', () {
        // Arrange
        CssStringValue cssStringValue = CssStringValue.fromDart('"Palatino Linotype"');

        // Act
        String css = cssStringValue.toCss();

        // Assert
        expect(css, '"Palatino Linotype"');
      });
    });
  });
}

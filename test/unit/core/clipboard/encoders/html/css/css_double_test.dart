import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_double.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('CssFontSize', () {
    group('fromDart', () {
      test('should return null when FontSize is null', () {
        // Act
        CssFontSize? fontSize = CssFontSize.fromDart(null);

        // Assert
        expect(fontSize, isNull);
      });

      test('should create CssFontSize from FontSize', () {
        // Arrange
        FontSize fontSize = const FontSize.fromPoints(12);

        // Act
        CssFontSize? cssFontSize = CssFontSize.fromDart(fontSize);

        // Assert
        expect(cssFontSize?.toCssMap(), <String, String>{'font-size': '12.0pt'});
      });
    });

    group('fromCssMap', () {
      test('should return null when no supported property is present', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': '#000000'};

        // Act
        CssFontSize? cssFontSize = CssFontSize.fromCssMap(cssMap);

        // Assert
        expect(cssFontSize, isNull);
      });

      test('should parse font size from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-size': '16px'};

        // Act
        CssFontSize? cssFontSize = CssFontSize.fromCssMap(cssMap);

        // Assert
        expect(cssFontSize?.toCssMap(), <String, String>{'font-size': '12.0pt'});
      });
    });

    group('toCssMap', () {
      test('should return correct CSS map', () {
        // Arrange
        CssFontSize fontSize = CssFontSize.fromDart(const FontSize.fromPoints(12))!;

        // Act
        Map<String, String> cssMap = fontSize.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-size': '12.0pt'});
      });
    });
  });

  group('CssDoubleValue', () {
    group('fromCss', () {
      test('should parse point value from CSS string', () {
        // Arrange
        String value = '12pt';

        // Act
        CssDoubleValue cssValue = CssDoubleValue.fromCss(value);

        // Assert
        expect(cssValue.toDart(), 12.0);
        expect(cssValue.toCss(CssDoubleUnit.pt), '12.0pt');
      });

      test('should parse pixel value from CSS string', () {
        // Arrange
        String value = '16px';

        // Act
        CssDoubleValue cssValue = CssDoubleValue.fromCss(value);

        // Assert
        expect(cssValue.toDart(), 16.0);
        expect(cssValue.toCss(CssDoubleUnit.pt), '12.0pt');
      });

      test('should throw an error for invalid CSS string', () {
        // Arrange
        String invalidValue = 'invalid';

        // Act & Assert
        expect(() => CssDoubleValue.fromCss(invalidValue), throwsArgumentError);
      });
    });

    group('toCss', () {
      test('should return correct point value string', () {
        // Arrange
        CssDoubleValue cssValue = CssDoubleValue.fromPoints(12);

        // Act
        String cssString = cssValue.toCss(CssDoubleUnit.pt);

        // Assert
        expect(cssString, '12.0pt');
      });

      test('should return correct pixel value string', () {
        // Arrange
        CssDoubleValue cssValue = CssDoubleValue.fromPixels(16);

        // Act
        String cssString = cssValue.toCss(CssDoubleUnit.px);

        // Assert
        expect(cssString, '16.0px');
      });
    });

    group('Conversion between units', () {
      test('should convert points to pixels', () {
        // Arrange
        CssDoubleValue cssValue = CssDoubleValue.fromPoints(12);

        // Act
        double pixels = cssValue.px;

        // Assert
        expect(pixels, 16.0);
      });

      test('should convert pixels to points', () {
        // Arrange
        CssDoubleValue cssValue = CssDoubleValue.fromPixels(16);

        // Act
        double points = cssValue.pt;

        // Assert
        expect(points, 12.0);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_color.dart';

void main() {
  group('CssColor', () {
    group('fromDart', () {
      test('should return null when value is null', () {
        // Act
        CssColor? cssColor = CssColor.fromDart(null);

        // Assert
        expect(cssColor, isNull);
      });

      test('should create CssColor from a Color', () {
        // Arrange
        Color color = const Color(0xFFFF0000);

        // Act
        CssColor? cssColor = CssColor.fromDart(color);

        // Assert
        expect(cssColor?.toCssMap(), <String, String>{'color': '#ff0000'});
      });
    });

    group('fromCssMap', () {
      test('should return null when no supported property is present', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'background-color': '#ff0000'};

        // Act
        CssColor? cssColor = CssColor.fromCssMap(cssMap);

        // Assert
        expect(cssColor, isNull);
      });

      test('should parse color from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': '#ff0000'};

        // Act
        CssColor? cssColor = CssColor.fromCssMap(cssMap);

        // Assert
        expect(cssColor?.toCssMap(), <String, String>{'color': '#ff0000'});
      });
    });
  });

  group('CssBackgroundColor', () {
    group('fromDart', () {
      test('should return null when value is null', () {
        // Act
        CssBackgroundColor? backgroundColor = CssBackgroundColor.fromDart(null);

        // Assert
        expect(backgroundColor, isNull);
      });

      test('should create CssBackgroundColor from a Color', () {
        // Arrange
        Color color = const Color(0xFF00FF00);

        // Act
        CssBackgroundColor? backgroundColor = CssBackgroundColor.fromDart(color);

        // Assert
        expect(backgroundColor?.toCssMap(), <String, String>{'background-color': '#00ff00'});
      });
    });

    group('fromCssMap', () {
      test('should return null when no supported property is present', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': '#00ff00'};

        // Act
        CssBackgroundColor? backgroundColor = CssBackgroundColor.fromCssMap(cssMap);

        // Assert
        expect(backgroundColor, isNull);
      });

      test('should parse background color from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'background-color': '#00ff00'};

        // Act
        CssBackgroundColor? backgroundColor = CssBackgroundColor.fromCssMap(cssMap);

        // Assert
        expect(backgroundColor?.toCssMap(), <String, String>{'background-color': '#00ff00'});
      });
    });
  });

  group('CssColorValue', () {
    group('fromCss', () {
      test('should parse color from hex value', () {
        // Arrange
        String hexColor = '#ff0000';

        // Act
        CssColorValue? cssColorValue = CssColorValue.fromCss(hexColor);

        // Assert
        expect(cssColorValue?.toCss(), '#ff0000');
        expect(cssColorValue?.toDart(), const Color(0xFFFF0000));
      });

      test('should parse color from rgb value', () {
        // Arrange
        String rgbColor = 'rgb(255, 0, 0)';

        // Act
        CssColorValue? cssColorValue = CssColorValue.fromCss(rgbColor);

        // Assert
        expect(cssColorValue?.toCss(), '#ff0000');
        expect(cssColorValue?.toDart(), const Color(0xFFFF0000));
      });

      test('should parse color from rgba value', () {
        // Arrange
        String rgbaColor = 'rgba(255, 0, 0, 0.50)';

        // Act
        CssColorValue? cssColorValue = CssColorValue.fromCss(rgbaColor);

        // Assert
        expect(cssColorValue?.toCss(), 'rgba(255, 0, 0, 0.50)');
        expect(cssColorValue?.toDart(), const Color.fromRGBO(255, 0, 0, 0.5));
      });

      test('should parse color from named value', () {
        // Arrange
        String namedColor = 'red';

        // Act
        CssColorValue? cssColorValue = CssColorValue.fromCss(namedColor);

        // Assert
        expect(cssColorValue?.toCss(), '#ff0000');
        expect(cssColorValue?.toDart(), const Color(0xFFFF0000));
      });

      test('should throw exception for unknown color', () {
        // Arrange
        String invalidColor = 'unknownColor';

        // Act & Assert
        expect(() => CssColorValue.fromCss(invalidColor), throwsException);
      });
    });

    group('fromDart', () {
      test('should create CssColorValue from a Color', () {
        // Arrange
        Color color = const Color(0xFF00FF00);

        // Act
        CssColorValue cssColorValue = CssColorValue.fromDart(color);

        // Assert
        expect(cssColorValue.toCss(), '#00ff00');
      });
    });

    group('toCss', () {
      test('should return correct CSS string for a Color', () {
        // Arrange
        CssColorValue cssColorValue = CssColorValue.fromDart(const Color(0xFF0000FF));

        // Act
        String cssString = cssColorValue.toCss();

        // Assert
        expect(cssString, '#0000ff');
      });
    });
  });
}

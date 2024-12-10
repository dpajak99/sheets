import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_font_style.dart';

void main() {
  group('CssFontStyle', () {
    group('fromDart', () {
      test('should return null when FontStyle is null', () {
        // Act
        CssFontStyle? fontStyle = CssFontStyle.fromDart(null);

        // Assert
        expect(fontStyle, isNull);
      });

      test('should create CssFontStyle from FontStyle.normal', () {
        // Act
        CssFontStyle? cssFontStyle = CssFontStyle.fromDart(FontStyle.normal);

        // Assert
        expect(cssFontStyle?.toCssMap(), <String, String>{'font-style': 'normal'});
      });

      test('should create CssFontStyle from FontStyle.italic', () {
        // Act
        CssFontStyle? cssFontStyle = CssFontStyle.fromDart(FontStyle.italic);

        // Assert
        expect(cssFontStyle?.toCssMap(), <String, String>{'font-style': 'italic'});
      });
    });

    group('fromCssMap', () {
      test('should return null when no supported property is present', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': '#000000'};

        // Act
        CssFontStyle? cssFontStyle = CssFontStyle.fromCssMap(cssMap);

        // Assert
        expect(cssFontStyle, isNull);
      });

      test('should parse font-style: normal from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-style': 'normal'};

        // Act
        CssFontStyle? cssFontStyle = CssFontStyle.fromCssMap(cssMap);

        // Assert
        expect(cssFontStyle?.toCssMap(), <String, String>{'font-style': 'normal'});
      });

      test('should parse font-style: italic from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-style': 'italic'};

        // Act
        CssFontStyle? cssFontStyle = CssFontStyle.fromCssMap(cssMap);

        // Assert
        expect(cssFontStyle?.toCssMap(), <String, String>{'font-style': 'italic'});
      });
    });

    group('toCssMap', () {
      test('should return correct CSS map for FontStyle.normal', () {
        // Arrange
        CssFontStyle cssFontStyle = CssFontStyle.fromDart(FontStyle.normal)!;

        // Act
        Map<String, String> cssMap = cssFontStyle.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-style': 'normal'});
      });

      test('should return correct CSS map for FontStyle.italic', () {
        // Arrange
        CssFontStyle cssFontStyle = CssFontStyle.fromDart(FontStyle.italic)!;

        // Act
        Map<String, String> cssMap = cssFontStyle.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-style': 'italic'});
      });
    });
  });

  group('CssFontStyleValue', () {
    group('fromCss', () {
      test('should parse font-style: normal from CSS string', () {
        // Act
        CssFontStyleValue cssValue = CssFontStyleValue.fromCss('normal');

        // Assert
        expect(cssValue.toDart(), FontStyle.normal);
        expect(cssValue.toCss(), 'normal');
      });

      test('should parse font-style: italic from CSS string', () {
        // Act
        CssFontStyleValue cssValue = CssFontStyleValue.fromCss('italic');

        // Assert
        expect(cssValue.toDart(), FontStyle.italic);
        expect(cssValue.toCss(), 'italic');
      });

      test('should default to font-style: normal for unknown CSS string', () {
        // Act
        CssFontStyleValue cssValue = CssFontStyleValue.fromCss('unknown');

        // Assert
        expect(cssValue.toDart(), FontStyle.normal);
        expect(cssValue.toCss(), 'normal');
      });
    });

    group('fromDart', () {
      test('should return CssFontStyleValue.normal for FontStyle.normal', () {
        // Act
        CssFontStyleValue cssValue = CssFontStyleValue.fromDart(FontStyle.normal);

        // Assert
        expect(cssValue.toDart(), FontStyle.normal);
        expect(cssValue.toCss(), 'normal');
      });

      test('should return CssFontStyleValue.italic for FontStyle.italic', () {
        // Act
        CssFontStyleValue cssValue = CssFontStyleValue.fromDart(FontStyle.italic);

        // Assert
        expect(cssValue.toDart(), FontStyle.italic);
        expect(cssValue.toCss(), 'italic');
      });
    });
  });
}

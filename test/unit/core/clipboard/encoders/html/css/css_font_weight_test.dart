import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_font_weignt.dart';

void main() {
  group('CssFontWeight', () {
    group('fromDart', () {
      test('should return null when FontWeight is null', () {
        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromDart(null);

        // Assert
        expect(cssFontWeight, isNull);
      });

      test('should create CssFontWeight from FontWeight.normal', () {
        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromDart(FontWeight.normal);

        // Assert
        expect(cssFontWeight?.toCssMap(), <String, String>{'font-weight': 'normal'});
      });

      test('should create CssFontWeight from FontWeight.bold', () {
        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromDart(FontWeight.bold);

        // Assert
        expect(cssFontWeight?.toCssMap(), <String, String>{'font-weight': 'bold'});
      });

      test('should create CssFontWeight from custom FontWeight value', () {
        // Arrange
        FontWeight customWeight = FontWeight.w600;

        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromDart(customWeight);

        // Assert
        expect(cssFontWeight?.toCssMap(), <String, String>{'font-weight': '600'});
      });
    });

    group('fromCssMap', () {
      test('should return null when no supported property is present', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': '#000000'};

        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromCssMap(cssMap);

        // Assert
        expect(cssFontWeight, isNull);
      });

      test('should parse font-weight: normal from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-weight': 'normal'};

        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromCssMap(cssMap);

        // Assert
        expect(cssFontWeight?.toCssMap(), <String, String>{'font-weight': 'normal'});
      });

      test('should parse font-weight: bold from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-weight': 'bold'};

        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromCssMap(cssMap);

        // Assert
        expect(cssFontWeight?.toCssMap(), <String, String>{'font-weight': 'bold'});
      });

      test('should parse font-weight: 700 from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-weight': '700'};

        // Act
        CssFontWeight? cssFontWeight = CssFontWeight.fromCssMap(cssMap);

        // Assert
        expect(cssFontWeight?.toCssMap(), <String, String>{'font-weight': '700'});
      });

      test('should throw exception for unknown CSS value', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'font-weight': 'unknown'};

        // Act & Assert
        expect(() => CssFontWeight.fromCssMap(cssMap), throwsException);
      });
    });

    group('toCssMap', () {
      test('should return correct CSS map for FontWeight.normal', () {
        // Arrange
        CssFontWeight cssFontWeight = CssFontWeight.fromDart(FontWeight.normal)!;

        // Act
        Map<String, String> cssMap = cssFontWeight.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-weight': 'normal'});
      });

      test('should return correct CSS map for FontWeight.bold', () {
        // Arrange
        CssFontWeight cssFontWeight = CssFontWeight.fromDart(FontWeight.bold)!;

        // Act
        Map<String, String> cssMap = cssFontWeight.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-weight': 'bold'});
      });

      test('should return correct CSS map for custom FontWeight value', () {
        // Arrange
        CssFontWeight cssFontWeight = CssFontWeight.fromDart(FontWeight.w600)!;

        // Act
        Map<String, String> cssMap = cssFontWeight.toCssMap();

        // Assert
        expect(cssMap, <String, String>{'font-weight': '600'});
      });
    });
  });

  group('CssFontWeightValue', () {
    group('fromCss', () {
      test('should parse font-weight: normal from CSS string', () {
        // Act
        CssFontWeightValue? cssValue = CssFontWeightValue.fromCss('normal');

        // Assert
        expect(cssValue?.toDart(), FontWeight.normal);
        expect(cssValue?.toCss(), 'normal');
      });

      test('should parse font-weight: bold from CSS string', () {
        // Act
        CssFontWeightValue? cssValue = CssFontWeightValue.fromCss('bold');

        // Assert
        expect(cssValue?.toDart(), FontWeight.bold);
        expect(cssValue?.toCss(), 'bold');
      });

      test('should parse numeric font-weight from CSS string', () {
        // Act
        CssFontWeightValue? cssValue = CssFontWeightValue.fromCss('500');

        // Assert
        expect(cssValue?.toDart(), FontWeight.w500);
        expect(cssValue?.toCss(), '500');
      });

      test('should throw exception for unknown CSS value', () {
        // Act & Assert
        expect(() => CssFontWeightValue.fromCss('unknown'), throwsException);
      });
    });

    group('fromDart', () {
      test('should return CssFontWeightValue.normal for FontWeight.normal', () {
        // Act
        CssFontWeightValue cssValue = CssFontWeightValue.fromDart(FontWeight.normal);

        // Assert
        expect(cssValue.toDart(), FontWeight.normal);
        expect(cssValue.toCss(), 'normal');
      });

      test('should return CssFontWeightValue.bold for FontWeight.bold', () {
        // Act
        CssFontWeightValue cssValue = CssFontWeightValue.fromDart(FontWeight.bold);

        // Assert
        expect(cssValue.toDart(), FontWeight.bold);
        expect(cssValue.toCss(), 'bold');
      });

      test('should return CssFontWeightValue.custom for custom FontWeight value', () {
        // Act
        CssFontWeightValue cssValue = CssFontWeightValue.fromDart(FontWeight.w400);

        // Assert
        expect(cssValue.toDart(), FontWeight.w400);
        expect(cssValue.toCss(), 'normal');
      });
    });
  });
}

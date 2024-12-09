import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_border.dart';

void main() {
  group('CssBorder', () {
    group('fromDart', () {
      test('should return null when border is null', () {
        // Act
        CssBorder? border = CssBorder.fromDart(null);

        // Assert
        expect(border, isNull);
      });

      test('should create a CssBorder from a uniform Dart Border', () {
        // Arrange
        Border border = const Border.fromBorderSide(BorderSide(width: 2, color: Color(0xFFFF0000)));

        // Act
        CssBorder? cssBorder = CssBorder.fromDart(border);

        // Assert
        expect(cssBorder?.toCssMap(), <String, String>{'border': '2.0px solid #ff0000'});
      });

      test('should create a CssBorder from a non-uniform Dart Border', () {
        // Arrange
        Border border = const Border(
          top: BorderSide(color: Color(0xFFFF0000)),
          right: BorderSide(width: 2, color: Color(0xFF00FF00)),
          bottom: BorderSide(width: 3, color: Color(0xFF0000FF)),
          left: BorderSide(width: 4, color: Color(0xFFFFFF00)),
        );

        // Act
        CssBorder? cssBorder = CssBorder.fromDart(border);

        // Assert
        expect(cssBorder?.toCssMap(), <String, String>{
          'border-top': '1.0px solid #ff0000',
          'border-right': '2.0px solid #00ff00',
          'border-bottom': '3.0px solid #0000ff',
          'border-left': '4.0px solid #ffff00',
        });
      });
    });

    group('fromCssMap', () {
      test('should return null when map does not contain supported properties', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'color': 'red'};

        // Act
        CssBorder? cssBorder = CssBorder.fromCssMap(cssMap);

        // Assert
        expect(cssBorder, isNull);
      });

      test('should parse uniform border from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{'border': '2px solid #ff0000'};

        // Act
        CssBorder? cssBorder = CssBorder.fromCssMap(cssMap);

        // Assert
        expect(cssBorder?.toCssMap(), <String, String>{'border': '2.0px solid #ff0000'});
      });

      test('should parse non-uniform border from CSS map', () {
        // Arrange
        Map<String, String> cssMap = <String, String>{
          'border-top': '1px solid #ff0000',
          'border-right': '2px solid #00ff00',
          'border-bottom': '3px solid #0000ff',
          'border-left': '4px solid #ffff00',
        };

        // Act
        CssBorder? cssBorder = CssBorder.fromCssMap(cssMap);

        // Assert
        expect(cssBorder?.toCssMap(), <String, String>{
          'border-top': '1.0px solid #ff0000',
          'border-right': '2.0px solid #00ff00',
          'border-bottom': '3.0px solid #0000ff',
          'border-left': '4.0px solid #ffff00',
        });
      });
    });

    group('CssBorderValue', () {
      test('should correctly identify uniform borders', () {
        // Arrange
        CssBorderValue borderValue = CssBorderValue.all(
          CssBorderSideValue.fromDart(const BorderSide(width: 2, color: Colors.red)),
        );

        // Act & Assert
        expect(borderValue.isUniform, isTrue);
      });

      test('should correctly identify non-uniform borders', () {
        // Arrange
        CssBorderValue borderValue = CssBorderValue(
          top: CssBorderSideValue.fromDart(const BorderSide(color: Colors.red)),
          right: CssBorderSideValue.fromDart(const BorderSide(width: 2, color: Colors.green)),
          bottom: CssBorderSideValue.fromDart(const BorderSide(width: 3, color: Colors.blue)),
          left: CssBorderSideValue.fromDart(const BorderSide(width: 4, color: Colors.yellow)),
        );

        // Act & Assert
        expect(borderValue.isUniform, isFalse);
      });
    });

    group('CssBorderSideValue', () {
      test('should parse from Dart BorderSide', () {
        // Arrange
        BorderSide borderSide = const BorderSide(width: 2, color: Color(0xFFFF0000));

        // Act
        CssBorderSideValue cssBorderSide = CssBorderSideValue.fromDart(borderSide);

        // Assert
        expect(cssBorderSide.toCss(), '2.0px solid #ff0000');
      });

      test('should parse from CSS string', () {
        // Arrange
        String cssString = '2px solid #ff0000';

        // Act
        CssBorderSideValue? cssBorderSide = CssBorderSideValue.fromCss(cssString);

        // Assert
        expect(cssBorderSide?.toCss(), '2.0px solid #ff0000');
      });

      test('should handle invalid CSS strings gracefully', () {
        // Arrange
        String cssString = 'invalid-css';

        // Act
        CssBorderSideValue? cssBorderSide = CssBorderSideValue.fromCss(cssString);

        // Assert
        expect(cssBorderSide, isNotNull);
        expect(cssBorderSide?.toCss(), 'none');
      });
    });
  });
}

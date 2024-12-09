import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_vertical_align.dart';

void main() {
  group('CssVerticalAlign', () {
    group('fromDart', () {
      test('should convert TextAlignVertical to CssVerticalAlign', () {
        expect(CssVerticalAlign.fromDart(TextAlignVertical.top)?.value.toCss(), 'top');
        expect(CssVerticalAlign.fromDart(TextAlignVertical.center)?.value.toCss(), 'middle');
        expect(CssVerticalAlign.fromDart(TextAlignVertical.bottom)?.value.toCss(), 'bottom');
      });

      test('should return null for null TextAlignVertical', () {
        expect(CssVerticalAlign.fromDart(null), isNull);
      });
    });

    group('fromCssMap', () {
      test('should convert CSS map to CssVerticalAlign', () {
        Map<String, String> cssMap = <String, String>{'vertical-align': 'middle'};

        CssVerticalAlign? result = CssVerticalAlign.fromCssMap(cssMap);

        expect(result?.value.toDart(), TextAlignVertical.center);
      });

      test('should return null if no supported properties in CSS map', () {
        Map<String, String> cssMap = <String, String>{'font-size': '14px'};

        CssVerticalAlign? result = CssVerticalAlign.fromCssMap(cssMap);

        expect(result, isNull);
      });

      test('should throw an exception for unknown vertical-align value', () {
        Map<String, String> cssMap = <String, String>{'vertical-align': 'unknown'};

        expect(() => CssVerticalAlign.fromCssMap(cssMap), throwsException);
      });
    });

    group('toCssMap', () {
      test('should convert CssVerticalAlign to CSS map', () {
        CssVerticalAlign cssVerticalAlign = CssVerticalAlign.fromDart(TextAlignVertical.center)!;

        Map<String, String> cssMap = cssVerticalAlign.toCssMap();

        expect(cssMap, <String, String>{'vertical-align': 'middle'});
      });
    });
  });

  group('CssVerticalAlignValue', () {
    group('fromCss', () {
      test('should convert CSS string to CssVerticalAlignValue', () {
        expect(CssVerticalAlignValue.fromCss('top').toDart(), TextAlignVertical.top);
        expect(CssVerticalAlignValue.fromCss('middle').toDart(), TextAlignVertical.center);
        expect(CssVerticalAlignValue.fromCss('bottom').toDart(), TextAlignVertical.bottom);
      });

      test('should throw exception for unknown value', () {
        expect(() => CssVerticalAlignValue.fromCss('unknown'), throwsException);
      });
    });

    group('fromDart', () {
      test('should convert TextAlignVertical to CssVerticalAlignValue', () {
        expect(CssVerticalAlignValue.fromDart(TextAlignVertical.top).toCss(), 'top');
        expect(CssVerticalAlignValue.fromDart(TextAlignVertical.center).toCss(), 'middle');
        expect(CssVerticalAlignValue.fromDart(TextAlignVertical.bottom).toCss(), 'bottom');
      });
    });

    group('toCss', () {
      test('should return correct CSS string', () {
        expect(CssVerticalAlignValue.top.toCss(), 'top');
        expect(CssVerticalAlignValue.middle.toCss(), 'middle');
        expect(CssVerticalAlignValue.bottom.toCss(), 'bottom');
      });
    });

    group('toDart', () {
      test('should return correct TextAlignVertical', () {
        expect(CssVerticalAlignValue.top.toDart(), TextAlignVertical.top);
        expect(CssVerticalAlignValue.middle.toDart(), TextAlignVertical.center);
        expect(CssVerticalAlignValue.bottom.toDart(), TextAlignVertical.bottom);
      });
    });

    group('isDefault', () {
      test('should return true for default CssVerticalAlignValue', () {
        expect(CssVerticalAlignValue.bottom.isDefault, true);
      });

      test('should return false for non-default CssVerticalAlignValue', () {
        expect(CssVerticalAlignValue.top.isDefault, false);
        expect(CssVerticalAlignValue.middle.isDefault, false);
      });
    });
  });
}

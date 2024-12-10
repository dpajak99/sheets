import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_text_align.dart';

void main() {
  group('CssTextAlign', () {
    group('fromDart', () {
      test('should convert TextAlign to CssTextAlign', () {
        expect(CssTextAlign.fromDart(TextAlign.left)?.value.toCss(), 'left');
        expect(CssTextAlign.fromDart(TextAlign.right)?.value.toCss(), 'right');
        expect(CssTextAlign.fromDart(TextAlign.center)?.value.toCss(), 'center');
        expect(CssTextAlign.fromDart(TextAlign.justify)?.value.toCss(), 'justify');
        expect(CssTextAlign.fromDart(TextAlign.start)?.value.toCss(), 'start');
        expect(CssTextAlign.fromDart(TextAlign.end)?.value.toCss(), 'end');
      });

      test('should return null for null TextAlign', () {
        expect(CssTextAlign.fromDart(null), isNull);
      });
    });

    group('fromCssMap', () {
      test('should convert CSS map to CssTextAlign', () {
        Map<String, String> cssMap = <String, String>{'text-align': 'center'};

        CssTextAlign? result = CssTextAlign.fromCssMap(cssMap);

        expect(result?.value.toDart(), TextAlign.center);
      });

      test('should return null if no supported properties in CSS map', () {
        Map<String, String> cssMap = <String, String>{'font-size': '14px'};

        CssTextAlign? result = CssTextAlign.fromCssMap(cssMap);

        expect(result, isNull);
      });

      test('should throw an exception for unknown text-align value', () {
        Map<String, String> cssMap = <String, String>{'text-align': 'unknown'};

        expect(() => CssTextAlign.fromCssMap(cssMap), throwsException);
      });
    });

    group('toCssMap', () {
      test('should convert CssTextAlign to CSS map', () {
        CssTextAlign cssTextAlign = CssTextAlign.fromDart(TextAlign.right)!;

        Map<String, String> cssMap = cssTextAlign.toCssMap();

        expect(cssMap, <String, String>{'text-align': 'right'});
      });
    });
  });

  group('CssTextAlignValue', () {
    group('fromCss', () {
      test('should convert CSS string to CssTextAlignValue', () {
        expect(CssTextAlignValue.fromCss('left').toDart(), TextAlign.left);
        expect(CssTextAlignValue.fromCss('right').toDart(), TextAlign.right);
        expect(CssTextAlignValue.fromCss('center').toDart(), TextAlign.center);
        expect(CssTextAlignValue.fromCss('justify').toDart(), TextAlign.justify);
        expect(CssTextAlignValue.fromCss('start').toDart(), TextAlign.start);
        expect(CssTextAlignValue.fromCss('end').toDart(), TextAlign.end);
      });

      test('should throw exception for unknown value', () {
        expect(() => CssTextAlignValue.fromCss('unknown'), throwsException);
      });
    });

    group('fromDart', () {
      test('should convert TextAlign to CssTextAlignValue', () {
        expect(CssTextAlignValue.fromDart(TextAlign.left).toCss(), 'left');
        expect(CssTextAlignValue.fromDart(TextAlign.right).toCss(), 'right');
        expect(CssTextAlignValue.fromDart(TextAlign.center).toCss(), 'center');
        expect(CssTextAlignValue.fromDart(TextAlign.justify).toCss(), 'justify');
        expect(CssTextAlignValue.fromDart(TextAlign.start).toCss(), 'start');
        expect(CssTextAlignValue.fromDart(TextAlign.end).toCss(), 'end');
      });
    });

    group('toCss', () {
      test('should return correct CSS string', () {
        expect(CssTextAlignValue.left.toCss(), 'left');
        expect(CssTextAlignValue.right.toCss(), 'right');
        expect(CssTextAlignValue.center.toCss(), 'center');
        expect(CssTextAlignValue.justify.toCss(), 'justify');
        expect(CssTextAlignValue.start.toCss(), 'start');
        expect(CssTextAlignValue.end.toCss(), 'end');
      });
    });

    group('toDart', () {
      test('should return correct TextAlign', () {
        expect(CssTextAlignValue.left.toDart(), TextAlign.left);
        expect(CssTextAlignValue.right.toDart(), TextAlign.right);
        expect(CssTextAlignValue.center.toDart(), TextAlign.center);
        expect(CssTextAlignValue.justify.toDart(), TextAlign.justify);
        expect(CssTextAlignValue.start.toDart(), TextAlign.start);
        expect(CssTextAlignValue.end.toDart(), TextAlign.end);
      });
    });
  });
}

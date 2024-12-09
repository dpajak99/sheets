import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_text_decoration.dart';

void main() {
  group('CssTextDecoration', () {
    group('fromDart', () {
      test('should convert TextDecoration to CssTextDecoration', () {
        expect(CssTextDecoration.fromDart(TextDecoration.none)?.value.toCss(), 'none');
        expect(CssTextDecoration.fromDart(TextDecoration.underline)?.value.toCss(), 'underline');
        expect(CssTextDecoration.fromDart(TextDecoration.overline)?.value.toCss(), 'overline');
        expect(CssTextDecoration.fromDart(TextDecoration.lineThrough)?.value.toCss(), 'line-through');
      });

      test('should return null for null TextDecoration', () {
        expect(CssTextDecoration.fromDart(null), isNull);
      });
    });

    group('fromCssMap', () {
      test('should convert CSS map to CssTextDecoration', () {
        Map<String, String> cssMap = <String, String>{'text-decoration': 'underline overline'};

        CssTextDecoration? result = CssTextDecoration.fromCssMap(cssMap);

        expect(result?.value.toDart(), TextDecoration.combine(<TextDecoration>[TextDecoration.underline, TextDecoration.overline]));
      });

      test('should return null if no supported properties in CSS map', () {
        Map<String, String> cssMap = <String, String>{'font-size': '14px'};

        CssTextDecoration? result = CssTextDecoration.fromCssMap(cssMap);

        expect(result, isNull);
      });

      test('should throw an exception for unknown text-decoration value', () {
        Map<String, String> cssMap = <String, String>{'text-decoration': 'unknown'};

        expect(() => CssTextDecoration.fromCssMap(cssMap), throwsException);
      });
    });

    group('toCssMap', () {
      test('should convert CssTextDecoration to CSS map', () {
        CssTextDecoration cssTextDecoration =
        CssTextDecoration.fromDart(TextDecoration.combine(<TextDecoration>[TextDecoration.underline, TextDecoration.overline]))!;

        Map<String, String> cssMap = cssTextDecoration.toCssMap();

        expect(cssMap, <String, String>{'text-decoration': 'underline overline'});
      });
    });
  });

  group('CssTextDecorationValue', () {
    group('fromCss', () {
      test('should convert CSS string to CssTextDecorationValue', () {
        expect(CssTextDecorationValue.fromCss('none').toDart(), TextDecoration.none);
        expect(CssTextDecorationValue.fromCss('underline').toDart(), TextDecoration.underline);
        expect(CssTextDecorationValue.fromCss('overline').toDart(), TextDecoration.overline);
        expect(CssTextDecorationValue.fromCss('line-through').toDart(), TextDecoration.lineThrough);
        expect(
          CssTextDecorationValue.fromCss('underline overline').toDart(),
          TextDecoration.combine(<TextDecoration>[TextDecoration.underline, TextDecoration.overline]),
        );
      });

      test('should throw exception for unknown value', () {
        expect(() => CssTextDecorationValue.fromCss('unknown'), throwsException);
      });
    });

    group('fromDart', () {
      test('should convert TextDecoration to CssTextDecorationValue', () {
        expect(CssTextDecorationValue.fromDart(TextDecoration.none).toCss(), 'none');
        expect(CssTextDecorationValue.fromDart(TextDecoration.underline).toCss(), 'underline');
        expect(CssTextDecorationValue.fromDart(TextDecoration.overline).toCss(), 'overline');
        expect(CssTextDecorationValue.fromDart(TextDecoration.lineThrough).toCss(), 'line-through');
      });
    });

    group('fromDartValues', () {
      test('should convert a list of TextDecorations to CssTextDecorationValue', () {
        CssTextDecorationValue value = CssTextDecorationValue.fromDartValues(
          <TextDecoration>[TextDecoration.underline, TextDecoration.overline],
        );

        expect(value.toCss(), 'underline overline');
        expect(value.toDart(), TextDecoration.combine(<TextDecoration>[TextDecoration.underline, TextDecoration.overline]));
      });
    });

    group('toCss', () {
      test('should return correct CSS string', () {
        expect(CssTextDecorationValue.none.toCss(), 'none');
        expect(CssTextDecorationValue.underline.toCss(), 'underline');
        expect(CssTextDecorationValue.overline.toCss(), 'overline');
        expect(CssTextDecorationValue.lineThrough.toCss(), 'line-through');
      });
    });

    group('toDart', () {
      test('should return correct TextDecoration', () {
        expect(CssTextDecorationValue.none.toDart(), TextDecoration.none);
        expect(CssTextDecorationValue.underline.toDart(), TextDecoration.underline);
        expect(CssTextDecorationValue.overline.toDart(), TextDecoration.overline);
        expect(CssTextDecorationValue.lineThrough.toDart(), TextDecoration.lineThrough);
      });
    });
  });
}

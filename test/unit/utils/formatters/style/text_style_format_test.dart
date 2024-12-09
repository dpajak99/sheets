import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';

void main() {
  group('Tests of TextStyleFormatActions', () {
    group('Tests of ToggleFontWeightAction', () {
      test('Should [toggle font weight] to bold and back to normal', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(fontWeight: FontWeight.normal);
        ToggleFontWeightIntent intent = ToggleFontWeightIntent();
        ToggleFontWeightAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontWeight, FontWeight.bold);

        // Act
        action = intent.createAction(baseTextStyle: updatedStyle);
        SheetTextSpanStyle revertedStyle = action.format(updatedStyle);

        // Assert
        expect(revertedStyle.fontWeight, FontWeight.normal);
      });
    });

    group('Tests of ToggleFontStyleAction', () {
      test('Should [toggle font style] to italic and back to normal', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(fontStyle: FontStyle.normal);
        ToggleFontStyleIntent intent = ToggleFontStyleIntent();
        ToggleFontStyleAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontStyle, FontStyle.italic);

        // Act
        action = intent.createAction(baseTextStyle: updatedStyle);
        SheetTextSpanStyle revertedStyle = action.format(updatedStyle);

        // Assert
        expect(updatedStyle.fontStyle, FontStyle.italic);
        expect(revertedStyle.fontStyle, FontStyle.normal);
      });
    });

    group('Tests of ToggleTextDecorationAction', () {
      test('Should [toggle underline decoration]', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle();
        ToggleTextDecorationIntent intent = ToggleTextDecorationIntent(value: TextDecoration.underline);
        ToggleTextDecorationAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.decoration, TextDecoration.underline);

        // Act
        action = intent.createAction(baseTextStyle: updatedStyle);
        SheetTextSpanStyle revertedStyle = action.format(updatedStyle);

        // Assert
        expect(revertedStyle.decoration, TextDecoration.none);
      });
    });

    group('Tests of SetFontColorAction', () {
      test('Should [set font color]', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(color: Colors.black);
        SetFontColorIntent intent = SetFontColorIntent(color: Colors.red);
        SetFontColorAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.color, Colors.red);
      });
    });

    group('Tests of DecreaseFontSizeAction', () {
      test('Should [decrease font size] by 1', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(fontSize: const FontSize.fromPixels(14));
        DecreaseFontSizeIntent intent = DecreaseFontSizeIntent();
        DecreaseFontSizeAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontSize, const FontSize.fromPoints(9.5));
      });
    });

    group('Tests of IncreaseFontSizeAction', () {
      test('Should [increase font size] by 1', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(fontSize: const FontSize.fromPixels(14));
        IncreaseFontSizeIntent intent = IncreaseFontSizeIntent();
        IncreaseFontSizeAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontSize, const FontSize.fromPoints(11.5));
      });
    });

    group('Tests of SetFontSizeAction', () {
      test('Should [set font size]', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(fontSize: const FontSize.fromPixels(14));
        SetFontSizeIntent intent = SetFontSizeIntent(fontSize: const FontSize.fromPixels(18));
        SetFontSizeAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontSize, const FontSize.fromPixels(18));
      });
    });

    group('Tests of SetFontFamilyAction', () {
      test('Should [set font family]', () {
        // Arrange
        SheetTextSpanStyle initialStyle = SheetTextSpanStyle(fontFamily: 'Roboto');
        SetFontFamilyIntent intent = SetFontFamilyIntent(fontFamily: 'Arial');
        SetFontFamilyAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        SheetTextSpanStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontFamily, 'Arial');
      });
    });
  });
}

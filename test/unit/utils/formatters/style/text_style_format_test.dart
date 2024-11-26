import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';

void main() {
  group('Tests of TextStyleFormatActions', () {
    group('Tests of ToggleFontWeightAction', () {
      test('Should [toggle font weight] to bold and back to normal', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(fontWeight: FontWeight.normal);
        ToggleFontWeightIntent intent = ToggleFontWeightIntent();
        ToggleFontWeightAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontWeight, FontWeight.bold);

        // Act
        action = intent.createAction(baseTextStyle: updatedStyle);
        TextStyle revertedStyle = action.format(updatedStyle);

        // Assert
        expect(revertedStyle.fontWeight, FontWeight.normal);
      });
    });

    group('Tests of ToggleFontStyleAction', () {
      test('Should [toggle font style] to italic and back to normal', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(fontStyle: FontStyle.normal);
        ToggleFontStyleIntent intent = ToggleFontStyleIntent();
        ToggleFontStyleAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontStyle, FontStyle.italic);

        // Act
        action = intent.createAction(baseTextStyle: updatedStyle);
        TextStyle revertedStyle = action.format(updatedStyle);

        // Assert
        expect(updatedStyle.fontStyle, FontStyle.italic);
        expect(revertedStyle.fontStyle, FontStyle.normal);
      });
    });

    group('Tests of ToggleTextDecorationAction', () {
      test('Should [toggle underline decoration]', () {
        // Arrange
        TextStyle initialStyle = const TextStyle();
        ToggleTextDecorationIntent intent = ToggleTextDecorationIntent(value: TextDecoration.underline);
        ToggleTextDecorationAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.decoration, TextDecoration.underline);

        // Act
        action = intent.createAction(baseTextStyle: updatedStyle);
        TextStyle revertedStyle = action.format(updatedStyle);

        // Assert
        expect(revertedStyle.decoration, TextDecoration.none);
      });
    });

    group('Tests of SetFontColorAction', () {
      test('Should [set font color]', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(color: Colors.black);
        SetFontColorIntent intent = SetFontColorIntent(color: Colors.red);
        SetFontColorAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.color, Colors.red);
      });
    });

    group('Tests of DecreaseFontSizeAction', () {
      test('Should [decrease font size] by 1', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(fontSize: 14);
        DecreaseFontSizeIntent intent = DecreaseFontSizeIntent();
        DecreaseFontSizeAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontSize, 13);
      });
    });

    group('Tests of IncreaseFontSizeAction', () {
      test('Should [increase font size] by 1', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(fontSize: 14);
        IncreaseFontSizeIntent intent = IncreaseFontSizeIntent();
        IncreaseFontSizeAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontSize, 15);
      });
    });

    group('Tests of SetFontSizeAction', () {
      test('Should [set font size]', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(fontSize: 14);
        SetFontSizeIntent intent = SetFontSizeIntent(fontSize: 18);
        SetFontSizeAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontSize, 18);
      });
    });

    group('Tests of SetFontFamilyAction', () {
      test('Should [set font family]', () {
        // Arrange
        TextStyle initialStyle = const TextStyle(fontFamily: 'Roboto');
        SetFontFamilyIntent intent = SetFontFamilyIntent(fontFamily: 'Arial');
        SetFontFamilyAction action = intent.createAction(baseTextStyle: initialStyle);

        // Act
        TextStyle updatedStyle = action.format(initialStyle);

        // Assert
        expect(updatedStyle.fontFamily, 'Arial');
      });
    });
  });
}

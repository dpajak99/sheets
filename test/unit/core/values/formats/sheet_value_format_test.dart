import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('SheetNumberFormat Tests', () {
    test('Should format a number correctly using decimal pattern', () {
      // Arrange
      SheetNumberFormat numberFormat = SheetNumberFormat.decimalPattern();
      SheetRichText richText = SheetRichText.single(text: '1234.56');

      // Act
      SheetRichText? formattedText = numberFormat.formatVisible(richText);

      // Assert
      expect(formattedText?.toPlainText(), '1,234.56');
    });

    test('Should return null for non-numeric input', () {
      // Arrange
      SheetNumberFormat numberFormat = SheetNumberFormat.decimalPattern();
      SheetRichText richText = SheetRichText.single(text: 'text');

      // Act
      SheetRichText? formattedText = numberFormat.formatVisible(richText);

      // Assert
      expect(formattedText, isNull);
    });

    test('Should correctly increase and decrease decimals', () {
      // Arrange
      SheetNumberFormat numberFormat = SheetNumberFormat.decimalPatternDigits();
      numberFormat.numberFormat.minimumFractionDigits = 2;

      // Act
      numberFormat.increaseDecimal();
      int increased = numberFormat.numberFormat.minimumFractionDigits;

      numberFormat.decreaseDecimal();
      numberFormat.decreaseDecimal();
      int decreased = numberFormat.numberFormat.minimumFractionDigits;

      // Assert
      expect(increased, 3);
      expect(decreased, 1);
    });
  });

  group('SheetDateFormat Tests', () {
    test('Should format a date correctly using the provided pattern', () {
      // Arrange
      SheetDateFormat dateFormat = SheetDateFormat('yyyy-MM-dd');
      SheetRichText richText = SheetRichText.single(text: '2023-11-25');

      // Act
      SheetRichText? formattedText = dateFormat.formatVisible(richText);

      // Assert
      expect(formattedText?.toPlainText(), '2023-11-25');
    });

    test('Should return null for invalid date input', () {
      // Arrange
      SheetDateFormat dateFormat = SheetDateFormat('yyyy-MM-dd');
      SheetRichText richText = SheetRichText.single(text: 'invalid-date');

      // Act
      SheetRichText? formattedText = dateFormat.formatVisible(richText);

      // Assert
      expect(formattedText, isNull);
    });
  });

  group('SheetDurationFormat Tests', () {
    test('Should format a duration correctly with milliseconds', () {
      // Arrange
      SheetDurationFormat durationFormat = SheetDurationFormat.withMilliseconds();
      SheetRichText richText = SheetRichText.single(text: '01:30:45.678');

      // Act
      SheetRichText? formattedText = durationFormat.formatVisible(richText);

      // Assert
      expect(formattedText?.toPlainText(), '01:30:45.678');
    });

    test('Should format a duration correctly without milliseconds', () {
      // Arrange
      SheetDurationFormat durationFormat = SheetDurationFormat.withoutMilliseconds();
      SheetRichText richText = SheetRichText.single(text: '01:30:45');

      // Act
      SheetRichText? formattedText = durationFormat.formatVisible(richText);

      // Assert
      expect(formattedText?.toPlainText(), '01:30:45');
    });

    test('Should return null for invalid duration input', () {
      // Arrange
      SheetDurationFormat durationFormat = SheetDurationFormat.auto();
      SheetRichText richText = SheetRichText.single(text: 'invalid-duration');

      // Act
      SheetRichText? formattedText = durationFormat.formatVisible(richText);

      // Assert
      expect(formattedText, isNull);
    });
  });

  group('SheetStringFormat Tests', () {
    test('Should not modify the input text', () {
      // Arrange
      SheetStringFormat stringFormat = SheetStringFormat();
      SheetRichText richText = SheetRichText.single(text: 'Example Text');

      // Act
      SheetRichText formattedText = stringFormat.formatVisible(richText);

      // Assert
      expect(formattedText.toPlainText(), 'Example Text');
    });

    test('Should return left text alignment', () {
      // Arrange
      SheetStringFormat stringFormat = SheetStringFormat();

      // Act
      TextAlign align = stringFormat.textAlign;

      // Assert
      expect(align, TextAlign.left);
    });
  });

  group('Auto-detection Tests', () {
    test('Should auto-detect a number format', () {
      // Arrange
      SheetRichText richText = SheetRichText.single(text: '1234.56');

      // Act
      SheetValueFormat detectedFormat = SheetValueFormat.auto(richText);

      // Assert
      expect(detectedFormat, isA<SheetNumberFormat>());
    });

    test('Should auto-detect a date format', () {
      // Arrange
      SheetRichText richText = SheetRichText.single(text: '2023-11-25');

      // Act
      SheetValueFormat detectedFormat = SheetValueFormat.auto(richText);

      // Assert
      expect(detectedFormat, isA<SheetDateFormat>());
    });

    test('Should auto-detect a duration format', () {
      // Arrange
      SheetRichText richText = SheetRichText.single(text: '01:30:45');

      // Act
      SheetValueFormat detectedFormat = SheetValueFormat.auto(richText);

      // Assert
      expect(detectedFormat, isA<SheetDurationFormat>());
    });

    test('Should default to string format for unknown patterns', () {
      // Arrange
      SheetRichText richText = SheetRichText.single(text: 'Unknown Pattern');

      // Act
      SheetValueFormat detectedFormat = SheetValueFormat.auto(richText);

      // Assert
      expect(detectedFormat, isA<SheetStringFormat>());
    });
  });
}

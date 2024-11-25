import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/text_style_extensions.dart';

void main() {
  group('Tests of TextStyleExtensions', () {
    group('Tests of join()', () {
      test('Should [return the original TextStyle] when [other is null]', () {
        // Arrange
        TextStyle original = const TextStyle(color: Colors.red, fontSize: 14);

        // Act
        TextStyle result = original.join(null);

        // Assert
        expect(result, original);
      });

      test('Should [merge styles] by overwriting non-default properties', () {
        // Arrange
        TextStyle original = const TextStyle(color: Colors.red, fontSize: 14);
        TextStyle other = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

        // Act
        TextStyle result = original.join(other);

        // Assert
        TextStyle expected = const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );
        expect(result, expected);
      });

      test('Should [retain original style properties] when [other is default]', () {
        // Arrange
        TextStyle original = const TextStyle(color: Colors.blue, fontStyle: FontStyle.italic);
        TextStyle other = const TextStyle();

        // Act
        TextStyle result = original.join(other);

        // Assert
        expect(result, original);
      });

      test('Should [apply other style properties] when [original is default]', () {
        // Arrange
        TextStyle original = const TextStyle();
        TextStyle other = const TextStyle(decoration: TextDecoration.underline, fontSize: 16);

        // Act
        TextStyle result = original.join(other);

        // Assert
        TextStyle expected = const TextStyle(decoration: TextDecoration.underline, fontSize: 16);
        expect(result, expected);
      });

      test('Should [merge shadows and font features]', () {
        // Arrange
        TextStyle original = const TextStyle(shadows: <Shadow>[Shadow(blurRadius: 2)]);
        TextStyle other = const TextStyle(fontFeatures: <FontFeature>[FontFeature.slashedZero()]);

        // Act
        TextStyle result = original.join(other);

        // Assert
        TextStyle expected = const TextStyle(
          shadows: <Shadow>[Shadow(blurRadius: 2)],
          fontFeatures: <FontFeature>[FontFeature.slashedZero()],
        );
        expect(result, expected);
      });

      test('Should [merge complex properties] like locale and decoration style', () {
        // Arrange
        TextStyle original = const TextStyle(locale: Locale('en'), decoration: TextDecoration.lineThrough);
        TextStyle other = const TextStyle(locale: Locale('fr'), decorationStyle: TextDecorationStyle.dashed);

        // Act
        TextStyle result = original.join(other);

        // Assert
        TextStyle expected = const TextStyle(
          locale: Locale('fr'),
          decoration: TextDecoration.lineThrough,
          decorationStyle: TextDecorationStyle.dashed,
        );
        expect(result, expected);
      });
    });
  });
}

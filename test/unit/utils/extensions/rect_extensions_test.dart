import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

void main() {
  group('Tests of RectExtensions', () {
    group('Tests of subtract()', () {
      test('Should [shrink rect by value]', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualRect = rect.subtract(2);

        // Assert
        Rect expectedRect = const Rect.fromLTRB(2, 2, 8, 8);
        expect(actualRect, expectedRect);
      });

      test('Should [shrink rect to zero or less if value is too large]', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(5, 5, 10, 10);

        // Act
        Rect actualRect = rect.subtract(10);

        // Assert
        Rect expectedRect = const Rect.fromLTRB(15, 15, 0, 0); // Rect collapses
        expect(actualRect, expectedRect);
      });

      test('Should [handle zero subtraction correctly]', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualRect = rect.subtract(0);

        // Assert
        expect(actualRect, rect);
      });
    });

    group('Tests of expand()', () {
      test('Should [expand rect by value]', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualRect = rect.expand(2);

        // Assert
        Rect expectedRect = const Rect.fromLTRB(-2, -2, 12, 12);
        expect(actualRect, expectedRect);
      });

      test('Should [handle zero expansion correctly]', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualRect = rect.expand(0);

        // Assert
        expect(actualRect, rect);
      });

      test('Should [expand rect with negative value as shrink]', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualRect = rect.expand(-2);

        // Assert
        Rect expectedRect = const Rect.fromLTRB(2, 2, 8, 8);
        expect(actualRect, expectedRect);
      });
    });

    group('Tests of within()', () {
      test('Should [return true] if offset is inside the rect', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);
        Offset offset = const Offset(5, 5);

        // Act
        bool actual = rect.within(offset);

        // Assert
        expect(actual, isTrue);
      });

      test('Should [return false] if offset is outside the rect', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);
        Offset offset = const Offset(15, 15);

        // Act
        bool actual = rect.within(offset);

        // Assert
        expect(actual, isFalse);
      });

      test('Should [return true] if offset is on the rect boundary', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(0, 0, 10, 10);
        Offset offset = const Offset(10, 10);

        // Act
        bool actual = rect.within(offset);

        // Assert
        expect(actual, isTrue);
      });

      test('Should [return false] if rect is zero size and offset is not at the corner', () {
        // Arrange
        Rect rect = const Rect.fromLTRB(5, 5, 5, 5);
        Offset offset = const Offset(5, 6);

        // Act
        bool actual = rect.within(offset);

        // Assert
        expect(actual, isFalse);
      });
    });
  });
}

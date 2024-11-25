import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

void main() {
  group('Tests of RectExtensions', () {
    group('Tests of RectExtensions.subtract()', () {
      test('Should [return Rect] with subtracted values (>0)', () {
        // Arrange
        Rect actualRect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualResult = actualRect.subtract(2);

        // Assert
        Rect expectedResult = const Rect.fromLTRB(2, 2, 8, 8);

        expect(actualResult, expectedResult);
      });

      test('Should [return Rect] with subtracted values (<0)', () {
        // Arrange
        Rect actualRect = const Rect.fromLTRB(0, 0, 10, 10);

        // Act
        Rect actualResult = actualRect.subtract(-2);

        // Assert
        Rect expectedResult = const Rect.fromLTRB(-2, -2, 12, 12);

        expect(actualResult, expectedResult);
      });
    });

    group('Tests of RectExtensions.expand()', () {});

    group('Tests of RectExtensions.within()', () {
      test('Should [return true] if given point is within the rect', () {
        // Arrange
        Rect actualRect = const Rect.fromLTRB(0, 0, 10, 10);
        Offset actualPoint = const Offset(5, 5);

        // Act
        bool actualResult = actualRect.within(actualPoint);

        // Assert
        expect(actualResult, true);
      });

      test('Should [return false] if given point is not within the rect', () {
        // Arrange
        Rect actualRect = const Rect.fromLTRB(0, 0, 10, 10);
        Offset actualPoint = const Offset(15, 15);

        // Act
        bool actualResult = actualRect.within(actualPoint);

        // Assert
        expect(actualResult, false);
      });
    });
  });
}

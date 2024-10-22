import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/viewport/viewport_offset_transformer.dart';

void main() {
  group('Tests of ViewportOffsetTransformer', () {
    group('Tests of ViewportOffsetTransformer.globalToLocal()', () {
      test('Should [return local offset] when [global offset is within globalRect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 500, 500);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(150, 150);

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(50, 50); // (150 - 100, 150 - 100)
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [clamp local offset to zero] when [global offset is before globalRect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 500, 500);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(50, 50); // Before globalRect

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = Offset.zero; // Clamped to (0, 0)
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [clamp local offset to globalRect size] when [global offset is beyond globalRect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 500, 500);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(700, 700); // Beyond globalRect

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(500, 500); // Clamped to (width, height)
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [return correct local offset] when [global offset is partially outside globalRect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 500, 500);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(50, 150); // x before, y within

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(0, 50); // x clamped to 0, y = 150 - 100
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [handle negative coordinates] when [globalRect is at negative position]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(-100, -100, 500, 500);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(-50, -50);

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(50, 50); // (-50 - (-100), -50 - (-100))
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [handle zero-sized globalRect] when [width and height are zero]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 0, 0);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(150, 150);

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = Offset.zero; // Clamped to (0, 0)
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [return local offset within bounds] when [global offset is exactly on the edge]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 500, 500);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(600, 600); // Right at the bottom-right corner

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(500, 500); // (600 - 100, 600 - 100)
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [return zero offset] when [global offset equals globalRect top-left]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(200, 200, 400, 400);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(200, 200); // Same as globalRect's top-left

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = Offset.zero;
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [return correct local offset] when [global offset is within globalRect and no clamping needed]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(50, 50, 300, 300);
        ViewportOffsetTransformer transformer = ViewportOffsetTransformer(globalRect);
        Offset globalOffset = const Offset(200, 250);

        // Act
        Offset localOffset = transformer.globalToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(150, 200); // (200 - 50, 250 - 50)
        expect(localOffset, equals(expectedLocalOffset));
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';

void main() {
  group('Tests of SheetViewportRect', () {
    group('Tests of SheetViewportRect constructor', () {
      test('Should [initialize global and local rects] when [constructed with global Rect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 100, 500, 400);

        // Act
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Assert
        expect(viewportRect.global, equals(globalRect));
        expect(viewportRect.local, equals(const Rect.fromLTWH(0, 0, 500, 400)));
      });
    });

    group('Tests of SheetViewportRect.width', () {
      test('Should [return width of global rect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(0, 0, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Act
        double width = viewportRect.width;

        // Assert
        expect(width, equals(600.0));
      });
    });

    group('Tests of SheetViewportRect.height', () {
      test('Should [return height of global rect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(0, 0, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Act
        double height = viewportRect.height;

        // Assert
        expect(height, equals(400.0));
      });
    });

    group('Tests of SheetViewportRect.size', () {
      test('Should [return size of global rect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(0, 0, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Act
        Size size = viewportRect.size;

        // Assert
        expect(size, equals(const Size(600, 400)));
      });
    });

    group('Tests of SheetViewportRect.innerRectLocal', () {
      test('Should [return inner local rect] adjusted by headers width and height', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(0, 0, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Act
        Rect innerRectLocal = viewportRect.innerRectLocal;

        // Assert
        Rect expectedRect = const Rect.fromLTRB(0, 0, 554, 376);
        expect(innerRectLocal, equals(expectedRect));
      });
    });

    group('Tests of SheetViewportRect.globalOffsetToLocal()', () {
      test('Should [convert global offset to local offset]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 50, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);
        Offset globalOffset = const Offset(150, 100);

        // Act
        Offset localOffset = viewportRect.globalOffsetToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = Offset(
          globalOffset.dx - globalRect.left,
          globalOffset.dy - globalRect.top,
        );
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [clamp local offset to zero] when [global offset is before global rect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 50, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);
        Offset globalOffset = const Offset(50, 25);

        // Act
        Offset localOffset = viewportRect.globalOffsetToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = const Offset(0, 0);
        expect(localOffset, equals(expectedLocalOffset));
      });

      test('Should [clamp local offset to rect size] when [global offset exceeds global rect]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(100, 50, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);
        Offset globalOffset = const Offset(800, 500);

        // Act
        Offset localOffset = viewportRect.globalOffsetToLocal(globalOffset);

        // Assert
        Offset expectedLocalOffset = Offset(globalRect.width, globalRect.height);
        expect(localOffset, equals(expectedLocalOffset));
      });
    });

    group('Tests of SheetViewportRect.isEquivalent()', () {
      test('Should [return true] when [rects are equal]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(0, 0, 600, 400);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Act
        bool isEqual = viewportRect.isEquivalent(globalRect);

        // Assert
        expect(isEqual, isTrue);
      });

      test('Should [return false] when [rects are not equal]', () {
        // Arrange
        Rect globalRect = const Rect.fromLTWH(0, 0, 600, 400);
        Rect otherRect = const Rect.fromLTWH(0, 0, 600, 500);
        SheetViewportRect viewportRect = SheetViewportRect(globalRect);

        // Act
        bool isEqual = viewportRect.isEquivalent(otherRect);

        // Assert
        expect(isEqual, isFalse);
      });
    });
  });
}

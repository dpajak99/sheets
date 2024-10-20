import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_direction.dart';
import 'package:sheets/core/selection/selection_rect.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of SelectionRect() constructor', () {
    test('Should [return SelectionRect] for SelectionDirection.bottomRight', () {
      // Arrange
      Rect startRect = const Rect.fromLTRB(0, 0, 100, 20);
      Rect endRect = const Rect.fromLTRB(100, 20, 200, 40);

      // Act
      SelectionRect actualSelectionRect = SelectionRect(startRect, endRect, SelectionDirection.bottomRight);

      // Assert
      SelectionRect expectedSelectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 200, 40),
        hiddenBorders: <Direction>[],
      );

      expect(actualSelectionRect, expectedSelectionRect);
    });

    test('Should [return SelectionRect] for SelectionDirection.bottomLeft', () {
      // Arrange
      Rect startRect = const Rect.fromLTRB(0, 0, 100, 20);
      Rect endRect = const Rect.fromLTRB(100, 20, 200, 40);

      // Act
      SelectionRect actualSelectionRect = SelectionRect(startRect, endRect, SelectionDirection.bottomLeft);

      // Assert
      SelectionRect expectedSelectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(100, 0, 100, 40),
        hiddenBorders: <Direction>[],
      );

      expect(actualSelectionRect, expectedSelectionRect);
    });

    test('Should [return SelectionRect] for SelectionDirection.topRight', () {
      // Arrange
      Rect startRect = const Rect.fromLTRB(0, 0, 100, 20);
      Rect endRect = const Rect.fromLTRB(100, 20, 200, 40);

      // Act
      SelectionRect actualSelectionRect = SelectionRect(startRect, endRect, SelectionDirection.topRight);

      // Assert
      SelectionRect expectedSelectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 20, 200, 20),
        hiddenBorders: <Direction>[],
      );

      expect(actualSelectionRect, expectedSelectionRect);
    });

    test('Should [return SelectionRect] for SelectionDirection.topLeft', () {
      // Arrange
      Rect startRect = const Rect.fromLTRB(0, 0, 100, 20);
      Rect endRect = const Rect.fromLTRB(100, 20, 200, 40);

      // Act
      SelectionRect actualSelectionRect = SelectionRect(startRect, endRect, SelectionDirection.topLeft);

      // Assert
      SelectionRect expectedSelectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(100, 20, 100, 20),
        hiddenBorders: <Direction>[],
      );

      expect(actualSelectionRect, expectedSelectionRect);
    });
  });

  group('Tests of SelectionRect.isLeftBorderVisible', (){
    test('Should [return true] when Direction.left is not hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.top, Direction.right, Direction.bottom],
      );

      // Act
      bool actualIsLeftBorderVisible = selectionRect.isLeftBorderVisible;

      // Assert
      expect(actualIsLeftBorderVisible, true);
    });

    test('Should [return false] when Direction.left is hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.left],
      );

      // Act
      bool actualIsLeftBorderVisible = selectionRect.isLeftBorderVisible;

      // Assert
      expect(actualIsLeftBorderVisible, false);
    });
  });

  group('Tests of SelectionRect.isTopBorderVisible', (){
    test('Should [return true] when Direction.top is not hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.left, Direction.right, Direction.bottom],
      );

      // Act
      bool actualIsTopBorderVisible = selectionRect.isTopBorderVisible;

      // Assert
      expect(actualIsTopBorderVisible, true);
    });

    test('Should [return false] when Direction.top is hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.top],
      );

      // Act
      bool actualIsTopBorderVisible = selectionRect.isTopBorderVisible;

      // Assert
      expect(actualIsTopBorderVisible, false);
    });
  });

  group('Tests of SelectionRect.isRightBorderVisible', (){
    test('Should [return true] when Direction.right is not hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.top, Direction.left, Direction.bottom],
      );

      // Act
      bool actualIsRightBorderVisible = selectionRect.isRightBorderVisible;

      // Assert
      expect(actualIsRightBorderVisible, true);
    });

    test('Should [return false] when Direction.right is hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.right],
      );

      // Act
      bool actualIsRightBorderVisible = selectionRect.isRightBorderVisible;

      // Assert
      expect(actualIsRightBorderVisible, false);
    });
  });

  group('Tests of SelectionRect.isBottomBorderVisible', (){
    test('Should [return true] when Direction.bottom is not hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.top, Direction.right, Direction.left],
      );

      // Act
      bool actualIsBottomBorderVisible = selectionRect.isBottomBorderVisible;

      // Assert
      expect(actualIsBottomBorderVisible, true);
    });

    test('Should [return false] when Direction.bottom is hidden', () {
      // Arrange
      SelectionRect selectionRect = SelectionRect.fromLTRB(
        rect: const Rect.fromLTRB(0, 0, 100, 20),
        hiddenBorders: <Direction>[Direction.bottom],
      );

      // Act
      bool actualIsBottomBorderVisible = selectionRect.isBottomBorderVisible;

      // Assert
      expect(actualIsBottomBorderVisible, false);
    });
  });
}

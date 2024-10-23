import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_direction.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of SelectionCellCorners.single() constructor', () {
    test('Should [return SelectionCellCorners] with single CellIndex in each corner', () {
      // Arrange
      CellIndex cellIndex = CellIndex.raw(1, 1);

      // Act
      SelectionCellCorners actualSelectionCellCorners = SelectionCellCorners.single(cellIndex);

      // Assert
      SelectionCellCorners expectedSelectionCellCorners = SelectionCellCorners(cellIndex, cellIndex, cellIndex, cellIndex);

      expect(actualSelectionCellCorners, expectedSelectionCellCorners);
    });
  });

  group('Tests of SelectionCellCorners.fromDirection() factory', () {
    test('Should [return SelectionCellCorners] for SelectionDirection.bottomRight', () {
      // Arrange
      CellIndex topLeft = CellIndex.raw(1, 1);
      CellIndex topRight = CellIndex.raw(1, 4);
      CellIndex bottomLeft = CellIndex.raw(4, 1);
      CellIndex bottomRight = CellIndex.raw(4, 4);

      // Act
      SelectionCellCorners actualSelectionCellCorners = SelectionCellCorners.fromDirection(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
        direction: SelectionDirection.bottomRight,
      );

      // Assert
      SelectionCellCorners expectedSelectionCellCorners = SelectionCellCorners(topLeft, topRight, bottomLeft, bottomRight);

      expect(actualSelectionCellCorners, expectedSelectionCellCorners);
    });

    test('Should [return SelectionCellCorners] for SelectionDirection.bottomLeft', () {
      // Arrange
      CellIndex topLeft = CellIndex.raw(1, 1);
      CellIndex topRight = CellIndex.raw(1, 4);
      CellIndex bottomLeft = CellIndex.raw(4, 1);
      CellIndex bottomRight = CellIndex.raw(4, 4);

      // Act
      SelectionCellCorners actualSelectionCellCorners = SelectionCellCorners.fromDirection(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
        direction: SelectionDirection.bottomLeft,
      );

      // Assert
      SelectionCellCorners expectedSelectionCellCorners = SelectionCellCorners(topRight, topLeft, bottomRight, bottomLeft);

      expect(actualSelectionCellCorners, expectedSelectionCellCorners);
    });

    test('Should [return SelectionCellCorners] for SelectionDirection.topRight', () {
      // Arrange
      CellIndex topLeft = CellIndex.raw(1, 1);
      CellIndex topRight = CellIndex.raw(1, 4);
      CellIndex bottomLeft = CellIndex.raw(4, 1);
      CellIndex bottomRight = CellIndex.raw(4, 4);

      // Act
      SelectionCellCorners actualSelectionCellCorners = SelectionCellCorners.fromDirection(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
        direction: SelectionDirection.topRight,
      );

      // Assert
      SelectionCellCorners expectedSelectionCellCorners = SelectionCellCorners(bottomLeft, bottomRight, topLeft, topRight);

      expect(actualSelectionCellCorners, expectedSelectionCellCorners);
    });

    test('Should [return SelectionCellCorners] for SelectionDirection.topLeft', () {
      // Arrange
      CellIndex topLeft = CellIndex.raw(1, 1);
      CellIndex topRight = CellIndex.raw(1, 4);
      CellIndex bottomLeft = CellIndex.raw(4, 1);
      CellIndex bottomRight = CellIndex.raw(4, 4);

      // Act
      SelectionCellCorners actualSelectionCellCorners = SelectionCellCorners.fromDirection(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
        direction: SelectionDirection.topLeft,
      );

      // Assert
      SelectionCellCorners expectedSelectionCellCorners = SelectionCellCorners(bottomRight, bottomLeft, topRight, topLeft);

      expect(actualSelectionCellCorners, expectedSelectionCellCorners);
    });
  });

  group('Tests of SelectionCellCorners.getRelativePosition()', () {
    test('Should [return Direction.top] if the closest border is TOP (above border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(0, 3);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.top;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.top] if the closest border is TOP (under border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(2, 3);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.top;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.left] if the closest border is LEFT (left border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(3, 0);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.left;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.left] if the closest border is LEFT (right border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(3, 2);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.left;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.bottom] if the closest border is BOTTOM (above border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(6, 3);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.bottom;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.bottom] if the closest border is BOTTOM (under border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(4, 3);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.bottom;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.right] if the closest border is RIGHT (left border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(3, 6);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.right;

      expect(actualDirection, expectedDirection);
    });

    test('Should [return Direction.right] if the closest border is RIGHT (right border)', () {
      // Arrange
      SelectionCellCorners selectionCellCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      CellIndex cellIndex = CellIndex.raw(3, 4);

      // Act
      Direction actualDirection = selectionCellCorners.getRelativePosition(cellIndex);

      // Assert
      Direction expectedDirection = Direction.right;

      expect(actualDirection, expectedDirection);
    });
  });

  group('Tests of SelectionCellCorners.isNestedIn()', () {
    test('Should [return TRUE] if the corners are nested', () {
      // Arrange
      SelectionCellCorners baseCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      SelectionCellCorners nestedCorners = SelectionCellCorners(
        CellIndex.raw(2, 2),
        CellIndex.raw(2, 4),
        CellIndex.raw(4, 2),
        CellIndex.raw(4, 4),
      );

      // Act
      bool actualIsNested = nestedCorners.isNestedIn(baseCorners);

      // Assert
      bool expectedIsNested = true;

      expect(actualIsNested, expectedIsNested);
    });

    test('Should [return FALSE] if the corners are not nested', () {
      // Arrange
      SelectionCellCorners baseCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      SelectionCellCorners nestedCorners = SelectionCellCorners(
        CellIndex.raw(0, 0),
        CellIndex.raw(0, 6),
        CellIndex.raw(6, 0),
        CellIndex.raw(6, 6),
      );

      // Act
      bool actualIsNested = nestedCorners.isNestedIn(baseCorners);

      // Assert
      bool expectedIsNested = false;

      expect(actualIsNested, expectedIsNested);
    });

    test('Should [return FALSE] if the corners are partially nested', () {
      // Arrange
      SelectionCellCorners baseCorners = SelectionCellCorners(
        CellIndex.raw(1, 1),
        CellIndex.raw(1, 5),
        CellIndex.raw(5, 1),
        CellIndex.raw(5, 5),
      );
      SelectionCellCorners nestedCorners = SelectionCellCorners(
        CellIndex.raw(0, 0),
        CellIndex.raw(2, 2),
        CellIndex.raw(6, 0),
        CellIndex.raw(6, 6),
      );

      // Act
      bool actualIsNested = nestedCorners.isNestedIn(baseCorners);

      // Assert
      bool expectedIsNested = false;

      expect(actualIsNested, expectedIsNested);
    });
  });
}

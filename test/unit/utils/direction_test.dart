import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of Direction.isVertical', () {
    test('Should return true for Direction.top', () {
      expect(Direction.top.isVertical, isTrue);
    });

    test('Should return true for Direction.bottom', () {
      expect(Direction.bottom.isVertical, isTrue);
    });

    test('Should return false for Direction.left', () {
      expect(Direction.left.isVertical, isFalse);
    });

    test('Should return false for Direction.right', () {
      expect(Direction.right.isVertical, isFalse);
    });
  });

  group('Tests of Direction.isHorizontal', () {
    test('Should return true for Direction.left', () {
      expect(Direction.left.isHorizontal, isTrue);
    });

    test('Should return true for Direction.right', () {
      expect(Direction.right.isHorizontal, isTrue);
    });

    test('Should return false for Direction.top', () {
      expect(Direction.top.isHorizontal, isFalse);
    });

    test('Should return false for Direction.bottom', () {
      expect(Direction.bottom.isHorizontal, isFalse);
    });
  });

  group('Tests of Direction.opposite', () {
    test('Should return Direction.bottom for Direction.top', () {
      expect(Direction.top.opposite, Direction.bottom);
    });

    test('Should return Direction.top for Direction.bottom', () {
      expect(Direction.bottom.opposite, Direction.top);
    });

    test('Should return Direction.right for Direction.left', () {
      expect(Direction.left.opposite, Direction.right);
    });

    test('Should return Direction.left for Direction.right', () {
      expect(Direction.right.opposite, Direction.left);
    });
  });

  group('Tests of Direction.rotateClockwise', () {
    test('Should return Direction.right for Direction.top', () {
      expect(Direction.top.rotateClockwise, Direction.right);
    });

    test('Should return Direction.bottom for Direction.right', () {
      expect(Direction.right.rotateClockwise, Direction.bottom);
    });

    test('Should return Direction.left for Direction.bottom', () {
      expect(Direction.bottom.rotateClockwise, Direction.left);
    });

    test('Should return Direction.top for Direction.left', () {
      expect(Direction.left.rotateClockwise, Direction.top);
    });
  });

  group('Tests of Direction.rotateCounterClockwise', () {
    test('Should return Direction.left for Direction.top', () {
      expect(Direction.top.rotateCounterClockwise, Direction.left);
    });

    test('Should return Direction.top for Direction.right', () {
      expect(Direction.right.rotateCounterClockwise, Direction.top);
    });

    test('Should return Direction.right for Direction.bottom', () {
      expect(Direction.bottom.rotateCounterClockwise, Direction.right);
    });

    test('Should return Direction.bottom for Direction.left', () {
      expect(Direction.left.rotateCounterClockwise, Direction.bottom);
    });
  });
}

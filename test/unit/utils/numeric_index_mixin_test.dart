import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/numeric_index_mixin.dart';

void main() {
  group('NumericIndexMixin Comparison Operators', () {
    test('Should [compare correctly] using < operator', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(5);
      MockNumericIndex index2 = MockNumericIndex(10);

      // Act & Assert
      expect(index1 < index2, isTrue);
      expect(index2 < index1, isFalse);
    });

    test('Should [compare correctly] using <= operator', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(5);
      MockNumericIndex index2 = MockNumericIndex(5);
      MockNumericIndex index3 = MockNumericIndex(10);

      // Act & Assert
      expect(index1 <= index2, isTrue);
      expect(index1 <= index3, isTrue);
      expect(index3 <= index1, isFalse);
    });

    test('Should [compare correctly] using > operator', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(15);
      MockNumericIndex index2 = MockNumericIndex(10);

      // Act & Assert
      expect(index1 > index2, isTrue);
      expect(index2 > index1, isFalse);
    });

    test('Should [compare correctly] using >= operator', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(10);
      MockNumericIndex index2 = MockNumericIndex(10);
      MockNumericIndex index3 = MockNumericIndex(5);

      // Act & Assert
      expect(index1 >= index2, isTrue);
      expect(index1 >= index3, isTrue);
      expect(index3 >= index1, isFalse);
    });
  });

  group('NumericIndexMixin compareTo Method', () {
    test('Should [return correct comparison value]', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(5);
      MockNumericIndex index2 = MockNumericIndex(10);
      MockNumericIndex index3 = MockNumericIndex(5);

      // Act & Assert
      expect(index1.compareTo(index2), equals(-1));
      expect(index2.compareTo(index1), equals(1));
      expect(index1.compareTo(index3), equals(0));
    });
  });

  group('MockNumericIndex.min', () {
    test('Should [return the minimum value]', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(5);
      MockNumericIndex index2 = MockNumericIndex(10);

      // Act
      MockNumericIndex result = min(index1, index2);

      // Assert
      expect(result, equals(index1));
    });
  });

  group('MockNumericIndex.max', () {
    test('Should [return the maximum value]', () {
      // Arrange
      MockNumericIndex index1 = MockNumericIndex(5);
      MockNumericIndex index2 = MockNumericIndex(10);

      // Act
      MockNumericIndex result = max(index1, index2);

      // Assert
      expect(result, equals(index2));
    });
  });
}

class MockNumericIndex with NumericIndexMixin {
  @override
  final int value;

  MockNumericIndex(this.value);
}

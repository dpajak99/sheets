import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';

void main() {
  group('Tests of IntExtensions', () {
    group('Tests of safeClamp()', () {
      test('Should [return min] when [value is less than min]', () {
        // Arrange
        int value = -5;

        // Act
        int actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 0);
      });

      test('Should [return max] when [value is greater than max]', () {
        // Arrange
        int value = 15;

        // Act
        int actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 10);
      });

      test('Should [return value] when [value is within range]', () {
        // Arrange
        int value = 5;

        // Act
        int actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 5);
      });

      test('Should [return min] when [value equals min]', () {
        // Arrange
        int value = 0;

        // Act
        int actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 0);
      });

      test('Should [return max] when [value equals max]', () {
        // Arrange
        int value = 10;

        // Act
        int actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 10);
      });
    });
  });
}

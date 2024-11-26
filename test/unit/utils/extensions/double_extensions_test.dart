import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/double_extensions.dart';

void main() {
  group('Tests of DoubleExtensions', () {
    group('Tests of safeClamp()', () {
      test('Should [return min] when [value is less than min]', () {
        // Arrange
        double value = -5;

        // Act
        double actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 0.0);
      });

      test('Should [return max] when [value is greater than max]', () {
        // Arrange
        double value = 15;

        // Act
        double actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 10.0);
      });

      test('Should [return value] when [value is within range]', () {
        // Arrange
        double value = 5;

        // Act
        double actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 5.0);
      });

      test('Should [return min] when [value equals min]', () {
        // Arrange
        double value = 0;

        // Act
        double actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 0.0);
      });

      test('Should [return max] when [value equals max]', () {
        // Arrange
        double value = 10;

        // Act
        double actual = value.safeClamp(0, 10);

        // Assert
        expect(actual, 10.0);
      });
    });
  });
}

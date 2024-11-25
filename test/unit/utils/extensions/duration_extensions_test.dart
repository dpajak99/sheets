import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/duration_extensions.dart';

void main() {
  group('Tests of DurationExtensions', () {
    group('Tests of difference()', () {
      test('Should [return positive difference] when [this is greater than other]', () {
        // Arrange
        Duration duration1 = const Duration(seconds: 10);
        Duration duration2 = const Duration(seconds: 5);

        // Act
        Duration actualDifference = duration1.difference(duration2);

        // Assert
        expect(actualDifference, const Duration(seconds: 5));
      });

      test('Should [return negative difference] when [this is less than other]', () {
        // Arrange
        Duration duration1 = const Duration(seconds: 5);
        Duration duration2 = const Duration(seconds: 10);

        // Act
        Duration actualDifference = duration1.difference(duration2);

        // Assert
        expect(actualDifference, const Duration(seconds: -5));
      });

      test('Should [return zero] when [this equals other]', () {
        // Arrange
        Duration duration1 = const Duration(seconds: 5);
        Duration duration2 = const Duration(seconds: 5);

        // Act
        Duration actualDifference = duration1.difference(duration2);

        // Assert
        expect(actualDifference, Duration.zero);
      });
    });

    group('Tests of add()', () {
      test('Should [return sum of durations]', () {
        // Arrange
        Duration duration1 = const Duration(seconds: 10);
        Duration duration2 = const Duration(seconds: 5);

        // Act
        Duration actualSum = duration1.add(duration2);

        // Assert
        expect(actualSum, const Duration(seconds: 15));
      });

      test('Should [return sum when adding negative duration]', () {
        // Arrange
        Duration duration1 = const Duration(seconds: 10);
        Duration duration2 = const Duration(seconds: -5);

        // Act
        Duration actualSum = duration1.add(duration2);

        // Assert
        expect(actualSum, const Duration(seconds: 5));
      });

      test('Should [return the same duration] when adding zero duration', () {
        // Arrange
        Duration duration1 = const Duration(seconds: 10);
        Duration duration2 = Duration.zero;

        // Act
        Duration actualSum = duration1.add(duration2);

        // Assert
        expect(actualSum, duration1);
      });
    });
  });
}

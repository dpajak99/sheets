import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/iterable_extensions.dart';

void main() {
  group('Tests of IterableExtensions', () {
    group('Tests of whereNotNull()', () {
      test('Should [filter out null elements]', () {
        // Arrange
        List<int?> input = <int?>[1, null, 2, null, 3];

        // Act
        List<int> actual = input.whereNotNull<int>();

        // Assert
        expect(actual, <int>[1, 2, 3]);
      });

      test('Should [return empty list] when [all elements are null]', () {
        // Arrange
        List<int?> input = <int?>[null, null, null];

        // Act
        List<int> actual = input.whereNotNull<int>();

        // Assert
        expect(actual, isEmpty);
      });

      test('Should [return original list] when [no elements are null]', () {
        // Arrange
        List<int> input = <int>[1, 2, 3];

        // Act
        List<int> actual = input.whereNotNull<int>();

        // Assert
        expect(actual, input);
      });

      test('Should [handle empty iterable] gracefully', () {
        // Arrange
        List<int?> input = <int?>[];

        // Act
        List<int> actual = input.whereNotNull<int>();

        // Assert
        expect(actual, isEmpty);
      });
    });

    group('Tests of withDivider()', () {
      test('Should [add divider between elements]', () {
        // Arrange
        List<int> input = <int>[1, 2, 3];

        // Act
        List<int> actual = input.withDivider<int>(0);

        // Assert
        expect(actual, <int>[1, 0, 2, 0, 3]);
      });

      test('Should [return empty list] when [input is empty]', () {
        // Arrange
        List<int> input = <int>[];

        // Act
        List<int> actual = input.withDivider<int>(0);

        // Assert
        expect(actual, isEmpty);
      });

      test('Should [handle single element list] without adding dividers', () {
        // Arrange
        List<int> input = <int>[1];

        // Act
        List<int> actual = input.withDivider<int>(0);

        // Assert
        expect(actual, <int>[1]);
      });

      test('Should [work with different divider types]', () {
        // Arrange
        List<String> input = <String>['A', 'B', 'C'];

        // Act
        List<String> actual = input.withDivider<String>('DIV');

        // Assert
        expect(actual, <String>['A', 'DIV', 'B', 'DIV', 'C']);
      });

      test('Should [not modify the original list]', () {
        // Arrange
        List<int> input = <int>[1, 2, 3];

        // Act
        List<int> actual = input.withDivider<int>(0);

        // Assert
        expect(actual, isNot(equals(input)));
        expect(input, <int>[1, 2, 3]); // Original list remains unchanged
      });
    });
  });
}

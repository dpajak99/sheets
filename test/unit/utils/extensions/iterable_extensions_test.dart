import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/iterable_extensions.dart';

void main() {
  group('Tests of IterableExtensions', () {
    group('Tests of IterableExtensions.whereNotNull()', () {
      test('Should [return list] of non-null elements', () {
        // Arrange
        List<String?> actualList = <String?>['a', null, 'b', null, 'c', null, 'd', null, 'e', null];

        // Act
        List<String> actualResult = actualList.whereNotNull();

        // Assert
        List<String> expectedResult = <String>['a', 'b', 'c', 'd', 'e'];

        expect(actualResult, expectedResult);
      });
    });
  });
}

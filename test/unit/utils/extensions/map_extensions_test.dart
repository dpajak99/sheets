import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/map_extensions.dart';

void main() {
  group('MapExtensions', () {
    test('merge combines two maps without overlapping keys', () {
      // Arrange
      Map<String, int> map1 = <String, int>{'a': 1, 'b': 2};
      Map<String, int> map2 = <String, int>{'c': 3, 'd': 4};

      // Act
      Map<String, int> result = map1.merge(map2);

      // Assert
      expect(result, <String, int>{'a': 1, 'b': 2, 'c': 3, 'd': 4});
    });

    test('merge overrides values for overlapping keys', () {
      // Arrange
      Map<String, int> map1 = <String, int>{'a': 1, 'b': 2};
      Map<String, int> map2 = <String, int>{'b': 3, 'c': 4};

      // Act
      Map<String, int> result = map1.merge(map2);

      // Assert
      expect(result, <String, int>{'a': 1, 'b': 3, 'c': 4});
    });

    test('merge with empty map returns the original map', () {
      // Arrange
      Map<String, int> map1 = <String, int>{'a': 1, 'b': 2};
      Map<String, int> map2 = <String, int>{};

      // Act
      Map<String, int> result = map1.merge(map2);

      // Assert
      expect(result, <String, int>{'a': 1, 'b': 2});
    });

    test('merge into an empty map returns the other map', () {
      // Arrange
      Map<String, int> map1 = <String, int>{};
      Map<String, int> map2 = <String, int>{'a': 1, 'b': 2};

      // Act
      Map<String, int> result = map1.merge(map2);

      // Assert
      expect(result, <String, int>{'a': 1, 'b': 2});
    });

    test('merge with both maps empty returns an empty map', () {
      // Arrange
      Map<String, int> map1 = <String, int>{};
      Map<String, int> map2 = <String, int>{};

      // Act
      Map<String, int> result = map1.merge(map2);

      // Assert
      expect(result, <String, int>{});
    });
  });
}

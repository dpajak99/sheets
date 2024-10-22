import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:sheets/utils/directional_values.dart';

void main() {
  group('DirectionalValues Initialization', () {
    test('Should [initialize correctly] with vertical and horizontal values', () {
      // Arrange
      MockListenable vertical = MockListenable();
      MockListenable horizontal = MockListenable();

      // Act
      DirectionalValues<MockListenable> directionalValues = DirectionalValues<MockListenable>(vertical, horizontal);

      // Assert
      expect(directionalValues.vertical, equals(vertical));
      expect(directionalValues.horizontal, equals(horizontal));
    });
  });

  group('Tests DirectionalValues setters', () {
    test('Should [update vertical value] and [notify listeners]', () {
      // Arrange
      MockListenable vertical = MockListenable();
      MockListenable horizontal = MockListenable();
      DirectionalValues<MockListenable> directionalValues = DirectionalValues<MockListenable>(vertical, horizontal);

      bool notified = false;
      directionalValues.addListener(() => notified = true);

      // Act
      MockListenable newVertical = MockListenable();
      directionalValues.vertical = newVertical;

      // Assert
      expect(directionalValues.vertical, equals(newVertical));
      expect(notified, isTrue);
    });

    test('Should [update horizontal value] and [notify listeners]', () {
      // Arrange
      MockListenable vertical = MockListenable();
      MockListenable horizontal = MockListenable();
      DirectionalValues<MockListenable> directionalValues = DirectionalValues<MockListenable>(vertical, horizontal);

      bool notified = false;
      directionalValues.addListener(() => notified = true);

      // Act
      MockListenable newHorizontal = MockListenable();
      directionalValues.horizontal = newHorizontal;

      // Assert
      expect(directionalValues.horizontal, equals(newHorizontal));
      expect(notified, isTrue);
    });
  });

  group('Tests of DirectionalValues.update()', () {
    test('Should [update both values] and [notify listeners]', () {
      // Arrange
      MockListenable vertical = MockListenable();
      MockListenable horizontal = MockListenable();
      DirectionalValues<MockListenable> directionalValues = DirectionalValues<MockListenable>(vertical, horizontal);

      bool notified = false;
      directionalValues.addListener(() => notified = true);

      // Act
      MockListenable newVertical = MockListenable();
      MockListenable newHorizontal = MockListenable();
      directionalValues.update(horizontal: newHorizontal, vertical: newVertical);

      // Assert
      expect(directionalValues.vertical, equals(newVertical));
      expect(directionalValues.horizontal, equals(newHorizontal));
      expect(notified, isTrue);
    });

    test('Should [not notify listeners] if values are the same', () {
      // Arrange
      MockListenable vertical = MockListenable();
      MockListenable horizontal = MockListenable();
      DirectionalValues<MockListenable> directionalValues = DirectionalValues<MockListenable>(vertical, horizontal);

      bool notified = false;
      directionalValues.addListener(() => notified = true);

      // Act
      directionalValues.update(horizontal: horizontal, vertical: vertical);

      // Assert
      expect(notified, isFalse);
    });
  });
}

class MockListenable extends ChangeNotifier {
  void triggerUpdate() => notifyListeners();
}
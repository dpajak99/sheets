import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';

void main() {
  group('NoKeysPressedState', () {
    test('Should [have anyKeyActive == false]', () {
      // Arrange
      NoKeysPressedState state = const NoKeysPressedState();

      // Act
      bool actualAnyKeyActive = state.anyKeyActive;

      // Assert
      expect(actualAnyKeyActive, isFalse);
    });

    test('Should [not have any keys pressed]', () {
      // Arrange
      NoKeysPressedState state = const NoKeysPressedState();
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;

      // Act
      bool isKeyPressed = state.isKeyPressed(keyA);

      // Assert
      expect(isKeyPressed, isFalse);
    });
  });

  group('SingleKeyPressedState', () {
    test('Should [have anyKeyActive == true]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      SingleKeyPressedState state = SingleKeyPressedState(keyA);

      // Act
      bool actualAnyKeyActive = state.anyKeyActive;

      // Assert
      expect(actualAnyKeyActive, isTrue);
    });

    test('Should [correctly identify pressed keys]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
      SingleKeyPressedState state = SingleKeyPressedState(keyA);

      // Act
      bool isKeyAPressed = state.isKeyPressed(keyA);
      bool isKeyBPressed = state.isKeyPressed(keyB);

      // Assert
      expect(isKeyAPressed, isTrue);
      expect(isKeyBPressed, isFalse);
    });
  });

  group('MultiKeysPressedState', () {
    test('Should [have anyKeyActive == true]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
      MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

      // Act
      bool actualAnyKeyActive = state.anyKeyActive;

      // Assert
      expect(actualAnyKeyActive, isTrue);
    });

    test('Should [correctly identify pressed keys]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
      LogicalKeyboardKey keyC = LogicalKeyboardKey.keyC;
      MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

      // Act
      bool isKeyAPressed = state.isKeyPressed(keyA);
      bool isKeyBPressed = state.isKeyPressed(keyB);
      bool isKeyCPressed = state.isKeyPressed(keyC);

      // Assert
      expect(isKeyAPressed, isTrue);
      expect(isKeyBPressed, isTrue);
      expect(isKeyCPressed, isFalse);
    });
  });

  group('KeyboardState.areKeysPressed()', () {
    test('Should [return true] when [all specified keys are pressed]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
      MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

      // Act
      bool areKeysPressed = state.areKeysPressed(<LogicalKeyboardKey>[keyA, keyB]);

      // Assert
      expect(areKeysPressed, isTrue);
    });

    test('Should [return false] when [not all specified keys are pressed]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
      LogicalKeyboardKey keyC = LogicalKeyboardKey.keyC;
      MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

      // Act
      bool areKeysPressed = state.areKeysPressed(<LogicalKeyboardKey>[keyA, keyC]);

      // Assert
      expect(areKeysPressed, isFalse);
    });
  });

  group('KeyboardState.containsState()', () {
    test('Should [return true] when [state contains the other state]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
      MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);
      SingleKeyPressedState otherState = SingleKeyPressedState(keyA);

      // Act
      bool containsState = state.containsState(otherState);

      // Assert
      expect(containsState, isTrue);
    });

    test('Should [return false] when [state does not contain the other state]', () {
      // Arrange
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyC = LogicalKeyboardKey.keyC;
      SingleKeyPressedState state = SingleKeyPressedState(keyA);
      SingleKeyPressedState otherState = SingleKeyPressedState(keyC);

      // Act
      bool containsState = state.containsState(otherState);

      // Assert
      expect(containsState, isFalse);
    });
  });
}

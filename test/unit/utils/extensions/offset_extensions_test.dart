import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';

void main() {
  group('Tests of KeyboardState', () {
    group('Tests of KeyboardState.anyKeyActive', () {
      test('Should [return false] when [NoKeysPressedState]', () {
        // Arrange
        NoKeysPressedState state = const NoKeysPressedState();

        // Act
        bool actualAnyKeyActive = state.anyKeyActive;

        // Assert
        expect(actualAnyKeyActive, isFalse);
      });

      test('Should [return true] when [SingleKeyPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        SingleKeyPressedState state = SingleKeyPressedState(keyA);

        // Act
        bool actualAnyKeyActive = state.anyKeyActive;

        // Assert
        expect(actualAnyKeyActive, isTrue);
      });

      test('Should [return true] when [MultiKeysPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
        MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

        // Act
        bool actualAnyKeyActive = state.anyKeyActive;

        // Assert
        expect(actualAnyKeyActive, isTrue);
      });
    });

    group('Tests of KeyboardState.isKeyPressed()', () {
      test('Should [return false] when [key is not pressed in NoKeysPressedState]', () {
        // Arrange
        NoKeysPressedState state = const NoKeysPressedState();
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;

        // Act
        bool isKeyPressed = state.isKeyPressed(keyA);

        // Assert
        expect(isKeyPressed, isFalse);
      });

      test('Should [return true] when [key is pressed in SingleKeyPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        SingleKeyPressedState state = SingleKeyPressedState(keyA);

        // Act
        bool isKeyPressed = state.isKeyPressed(keyA);

        // Assert
        expect(isKeyPressed, isTrue);
      });

      test('Should [return false] when [different key is checked in SingleKeyPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
        SingleKeyPressedState state = SingleKeyPressedState(keyA);

        // Act
        bool isKeyPressed = state.isKeyPressed(keyB);

        // Assert
        expect(isKeyPressed, isFalse);
      });

      test('Should [return true] when [key is pressed in MultiKeysPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
        MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

        // Act
        bool isKeyAPressed = state.isKeyPressed(keyA);
        bool isKeyBPressed = state.isKeyPressed(keyB);

        // Assert
        expect(isKeyAPressed, isTrue);
        expect(isKeyBPressed, isTrue);
      });

      test('Should [return false] when [key is not pressed in MultiKeysPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyC = LogicalKeyboardKey.keyC;
        MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA]);

        // Act
        bool isKeyPressed = state.isKeyPressed(keyC);

        // Assert
        expect(isKeyPressed, isFalse);
      });
    });

    group('Tests of KeyboardState.areKeysPressed()', () {
      test('Should [return false] when [NoKeysPressedState]', () {
        // Arrange
        NoKeysPressedState state = const NoKeysPressedState();
        List<LogicalKeyboardKey> keys = <LogicalKeyboardKey>[LogicalKeyboardKey.keyA];

        // Act
        bool areKeysPressed = state.areKeysPressed(keys);

        // Assert
        expect(areKeysPressed, isFalse);
      });

      test('Should [return true] when [all keys are pressed in MultiKeysPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
        MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

        // Act
        bool areKeysPressed = state.areKeysPressed(<LogicalKeyboardKey>[keyA, keyB]);

        // Assert
        expect(areKeysPressed, isTrue);
      });

      test('Should [return false] when [not all keys are pressed in MultiKeysPressedState]', () {
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

    group('Tests of KeyboardState.containsState()', () {
      test('Should [return true] when [state contains other state in MultiKeysPressedState]', () {
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

      test('Should [return false] when [state does not contain other state]', () {
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

      test('Should [return true] when [both states are NoKeysPressedState]', () {
        // Arrange
        NoKeysPressedState state = const NoKeysPressedState();
        NoKeysPressedState otherState = const NoKeysPressedState();

        // Act
        bool containsState = state.containsState(otherState);

        // Assert
        expect(containsState, isTrue);
      });
    });

    group('Tests of KeyboardState.keys', () {
      test('Should [return empty list] when [NoKeysPressedState]', () {
        // Arrange
        NoKeysPressedState state = const NoKeysPressedState();

        // Act
        List<LogicalKeyboardKey> keys = state.keys;

        // Assert
        expect(keys, isEmpty);
      });

      test('Should [return list with one key] when [SingleKeyPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        SingleKeyPressedState state = SingleKeyPressedState(keyA);

        // Act
        List<LogicalKeyboardKey> keys = state.keys;

        // Assert
        expect(keys, contains(keyA));
        expect(keys.length, equals(1));
      });

      test('Should [return list with multiple keys] when [MultiKeysPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
        MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

        // Act
        List<LogicalKeyboardKey> keys = state.keys;

        // Assert
        expect(keys, containsAll(<LogicalKeyboardKey>[keyA, keyB]));
        expect(keys.length, equals(2));
      });
    });

    group('Tests of KeyboardState.keyIds', () {
      test('Should [return empty list] when [NoKeysPressedState]', () {
        // Arrange
        NoKeysPressedState state = const NoKeysPressedState();

        // Act
        List<int> keyIds = state.keyIds;

        // Assert
        expect(keyIds, isEmpty);
      });

      test('Should [return list with one keyId] when [SingleKeyPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        SingleKeyPressedState state = SingleKeyPressedState(keyA);

        // Act
        List<int> keyIds = state.keyIds;

        // Assert
        expect(keyIds, contains(keyA.keyId));
        expect(keyIds.length, equals(1));
      });

      test('Should [return list with multiple keyIds] when [MultiKeysPressedState]', () {
        // Arrange
        LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
        LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;
        MultiKeysPressedState state = MultiKeysPressedState(<LogicalKeyboardKey>[keyA, keyB]);

        // Act
        List<int> keyIds = state.keyIds;

        // Assert
        expect(keyIds, containsAll(<int>[keyA.keyId, keyB.keyId]));
        expect(keyIds.length, equals(2));
      });
    });
  });
}

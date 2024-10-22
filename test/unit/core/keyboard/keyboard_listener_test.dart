import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';

void main() {
  group('Tests of KeyboardListener.addKey()', () {
    test('Should [update state] and [emit through pressStream] when [key is added]', () async {
      // Arrange
      Completer<void> testCompleter = Completer<void>();

      KeyboardListener keyboardListener = KeyboardListener();
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      KeyboardState? emittedState;

      keyboardListener.pressStream.listen((KeyboardState state) {
        emittedState = state;
        testCompleter.complete();
      });

      // Act
      keyboardListener.addKey(keyA);
      await testCompleter.future;

      // Assert
      expect(keyboardListener.state.isKeyPressed(keyA), isTrue);
      expect(emittedState?.isKeyPressed(keyA), isTrue);
    });
  });

  group('Tests of KeyboardListener.removeKey()', () {
    test('Should [update state] and [emit through releaseStream] when [key is removed]', () async {
      // Arrange
      Completer<void> testCompleter = Completer<void>();

      KeyboardListener keyboardListener = KeyboardListener();
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      KeyboardState? emittedState;

      keyboardListener.releaseStream.listen((KeyboardState state) {
        emittedState = state;
        testCompleter.complete();
      });

      keyboardListener.addKey(keyA);

      // Act
      keyboardListener.removeKey(keyA);
      await testCompleter.future;

      // Assert
      expect(keyboardListener.state.isKeyPressed(keyA), isFalse);
      expect(emittedState?.isKeyPressed(keyA), isFalse);
    });
  });

  group('Tests of KeyboardListener.holdStream', () {
    test('Should [emit states] when [key is held down]', () async {
      // Arrange
      Completer<void> testCompleter = Completer<void>();

      KeyboardListener keyboardListener = KeyboardListener();
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      List<KeyboardState> emittedStates = <KeyboardState>[];

      keyboardListener.holdStream.listen((KeyboardState state) {
        emittedStates.add(state);
        if (emittedStates.length == 2) {
          testCompleter.complete();
        }
      });

      // Act
      keyboardListener.addKey(keyA);
      await Future<void>.delayed(const Duration(milliseconds: 600));
      keyboardListener.removeKey(keyA);

      await testCompleter.future;

      // Assert
      expect(emittedStates.isNotEmpty, isTrue);
      for (KeyboardState state in emittedStates) {
        expect(state.isKeyPressed(keyA), isTrue);
      }
    });
  });

  group('Tests of KeyboardListener.pressOrHoldStream', () {
    test('Should [emit states] when [key is pressed or held]', () async {
      // Arrange
      Completer<void> testCompleter = Completer<void>();

      KeyboardListener keyboardListener = KeyboardListener();
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      List<KeyboardState> emittedStates = <KeyboardState>[];

      keyboardListener.pressOrHoldStream.listen((KeyboardState state) {
        emittedStates.add(state);
        if (emittedStates.length == 2) {
          testCompleter.complete();
        }
      });

      // Act
      keyboardListener.addKey(keyA);
      await Future<void>.delayed(const Duration(milliseconds: 600));
      keyboardListener.removeKey(keyA);

      // Assert
      expect(emittedStates.length, greaterThan(1));
      expect(emittedStates.first.isKeyPressed(keyA), isTrue);
      expect(emittedStates.last.isKeyPressed(keyA), isTrue);
    });
  });

  group('Tests of KeyboardListener with multiple keys', () {
    test('Should [update state correctly] when [multiple keys are added and removed]', () {
      // Arrange
      KeyboardListener keyboardListener = KeyboardListener();
      LogicalKeyboardKey keyA = LogicalKeyboardKey.keyA;
      LogicalKeyboardKey keyB = LogicalKeyboardKey.keyB;

      // Act
      keyboardListener.addKey(keyA);
      keyboardListener.addKey(keyB);
      keyboardListener.removeKey(keyA);

      // Assert
      expect(keyboardListener.state.isKeyPressed(keyA), isFalse);
      expect(keyboardListener.state.isKeyPressed(keyB), isTrue);
    });
  });
}

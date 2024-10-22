import 'package:flutter_test/flutter_test.dart';

import 'package:sheets/utils/repeat_action_timer.dart';

void main() {
  group('RepeatActionTimer', () {
    test('Should [start and trigger callback] after startDuration', () async {
      // Arrange
      Duration startDuration = const Duration(milliseconds: 100);
      Duration nextHoldDuration = const Duration(milliseconds: 50);
      RepeatActionTimer timer = RepeatActionTimer(
        startDuration: startDuration,
        nextHoldDuration: nextHoldDuration,
      );

      bool callbackTriggered = false;
      bool callback() => callbackTriggered = true;

      // Act
      timer.start(callback);

      // Assert
      await Future<void>.delayed(startDuration + const Duration(milliseconds: 52));
      expect(callbackTriggered, isTrue);

      // Clean up
      timer.reset();
    });

    test('Should [trigger callback periodically] after startDuration', () async {
      // Arrange
      Duration startDuration = const Duration(milliseconds: 100);
      Duration nextHoldDuration = const Duration(milliseconds: 50);
      RepeatActionTimer timer = RepeatActionTimer(
        startDuration: startDuration,
        nextHoldDuration: nextHoldDuration,
      );

      int callbackCount = 0;
      int callback() => callbackCount++;

      // Act
      timer.start(callback);

      // Assert
      await Future<void>.delayed((startDuration + nextHoldDuration * 3) + const Duration(milliseconds: 2));
      expect(callbackCount, greaterThanOrEqualTo(3));

      // Clean up
      timer.reset();
    });

    test('Should [reset and cancel timers] when reset is called', () async {
      // Arrange
      Duration startDuration = const Duration(milliseconds: 100);
      Duration nextHoldDuration = const Duration(milliseconds: 50);
      RepeatActionTimer timer = RepeatActionTimer(
        startDuration: startDuration,
        nextHoldDuration: nextHoldDuration,
      );

      int callbackCount = 0;
      int callback() => callbackCount++;

      // Act
      timer.start(callback);
      await Future<void>.delayed(const Duration(milliseconds: 52));
      timer.reset();
      await Future<void>.delayed(startDuration + nextHoldDuration * 2);

      // Assert
      expect(callbackCount, equals(0));
    });
  });
}

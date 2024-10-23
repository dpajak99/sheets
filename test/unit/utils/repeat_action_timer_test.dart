import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/repeat_action_timer.dart';

void main() {
  group('Tests of RepeatActionTimer', () {
    group('Tests of start()', () {
      test('Should [start holdStartTimer] when [start is called]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        bool callbackCalled = false;
        void callback() {
          callbackCalled = true;
        }

        // Act
        repeatActionTimer.start(callback);

        // Assert
        expect(repeatActionTimer.holdStartTimer, isNotNull);
        expect(callbackCalled, isFalse);
      });

      test('Should [call callback after startDuration] when [start is called]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        int callbackCallCount = 0;
        void callback() {
          callbackCallCount++;
        }

        // Act
        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 500)); // Simulate time passing

        // Assert
        expect(callbackCallCount, equals(0)); // Callback not called yet
        expect(repeatActionTimer.holdPressTimer, isNotNull);
      });

      test('Should [start holdPressTimer] after startDuration when [start is called]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        int callbackCallCount = 0;
        void callback() {
          callbackCallCount++;
        }

        // Act
        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 500)); // Simulate time passing

        // Assert
        expect(repeatActionTimer.holdPressTimer, isNotNull);
        expect(callbackCallCount, equals(0)); // Callback not called yet
      });

      test('Should [call callback periodically] after startDuration when [start is called]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        int callbackCallCount = 0;
        void callback() {
          callbackCallCount++;
        }

        // Act
        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 500)); // Wait for startDuration
        expect(callbackCallCount, equals(0)); // Callback not called yet
        await Future<void>.delayed(const Duration(milliseconds: 100)); // First periodic callback
        expect(callbackCallCount, equals(1));
        await Future<void>.delayed(const Duration(milliseconds: 200)); // Two more callbacks
        expect(callbackCallCount, equals(3));
      });

      test('Should [reset timers before starting new ones] when [start is called]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        int callbackCallCount = 0;
        void callback() {
          callbackCallCount++;
        }

        // Start the timer for the first time
        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 250));

        // Act: Start the timer again before the first one completes
        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(callbackCallCount, equals(0)); // Callback should not be called yet
        expect(repeatActionTimer.holdPressTimer, isNotNull);
      });
    });

    group('Tests of reset()', () {
      test('Should [cancel holdStartTimer and holdPressTimer] when [reset is called]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        void callback() {}

        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 300)); // Timer is still running

        // Act
        repeatActionTimer.reset();

        // Assert
        expect(repeatActionTimer.holdStartTimer, isNull);
        expect(repeatActionTimer.holdPressTimer, isNull);
      });

      test('Should [not call callback after reset] when [timers are cancelled]', () async {
        // Arrange
        const Duration startDuration = Duration(milliseconds: 500);
        const Duration nextHoldDuration = Duration(milliseconds: 100);
        RepeatActionTimer repeatActionTimer = RepeatActionTimer(
          startDuration: startDuration,
          nextHoldDuration: nextHoldDuration,
        );
        int callbackCallCount = 0;
        void callback() {
          callbackCallCount++;
        }

        repeatActionTimer.start(callback);
        await Future<void>.delayed(const Duration(milliseconds: 300)); // Before startDuration

        // Act
        repeatActionTimer.reset();
        await Future<void>.delayed(const Duration(milliseconds: 500)); // Advance time past startDuration

        // Assert
        expect(callbackCallCount, equals(0)); // Callback should not have been called
      });
    });
  });
}

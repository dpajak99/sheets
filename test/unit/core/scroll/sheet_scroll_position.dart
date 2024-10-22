import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';

void main() {
  group('Tests of SheetScrollPosition', () {
    group('Tests of SheetScrollPosition.offset', () {
      test('Should [have initial offset of zero]', () {
        // Arrange
        SheetScrollPosition position = SheetScrollPosition();

        // Act
        double initialOffset = position.offset;

        // Assert
        expect(initialOffset, 0.0);
      });

      test('Should [update offset] when [offset is set]', () {
        // Arrange
        SheetScrollPosition position = SheetScrollPosition();
        double newOffset = 150;

        // Act
        position.offset = newOffset;

        // Assert
        expect(position.offset, newOffset);
      });

      test('Should [not notify listeners] when [offset is unchanged]', () {
        // Arrange
        SheetScrollPosition position = SheetScrollPosition();
        bool notified = false;
        position.addListener(() {
          notified = true;
        });

        // Act
        position.offset = position.offset;

        // Assert
        expect(notified, isFalse);
      });

      test('Should [notify listeners] when [offset is changed]', () {
        // Arrange
        SheetScrollPosition position = SheetScrollPosition();
        bool notified = false;
        position.addListener(() {
          notified = true;
        });

        // Act
        position.offset = 200.0;

        // Assert
        expect(notified, isTrue);
      });
    });
  });
}

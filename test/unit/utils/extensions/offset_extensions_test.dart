import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';

void main() {
  group('Tests of OffsetExtensions', (){
    group('Tests of OffsetExtensions.reverse()', (){
      test('Should [return Offset] with reversed dx and dy', (){
        // Arrange
        Offset actualOffset = const Offset(1, 2);

        // Act
        Offset actualReversedOffset = actualOffset.reverse();

        // Assert
        Offset expectedReversedOffset = const Offset(2, 1);

        expect(actualReversedOffset, expectedReversedOffset);
      });
    });

    group('Tests of OffsetExtensions.limit()', (){
      test('Should [return Offset] with limited dx and dy', (){
        // Arrange
        Offset actualOffset = const Offset(1, 2);
        Offset x = const Offset(0, 1);
        Offset y = const Offset(1, 2);

        // Act
        Offset actualLimitedOffset = actualOffset.limit(x, y);

        // Assert
        Offset expectedLimitedOffset = const Offset(1, 2);

        expect(actualLimitedOffset, expectedLimitedOffset);
      });

      test('Should [return given Offset] if dx and dy are within limits', (){
        // Arrange
        Offset actualOffset = const Offset(1, 2);
        Offset x = const Offset(0, 2);
        Offset y = const Offset(1, 3);

        // Act
        Offset actualLimitedOffset = actualOffset.limit(x, y);

        // Assert
        Offset expectedLimitedOffset = const Offset(1, 2);

        expect(actualLimitedOffset, expectedLimitedOffset);
      });
    });

    group('Tests of OffsetExtensions.limitMin()', (){
      test('Should [return Offset] with limited dx and dy', (){
        // Arrange
        Offset actualOffset = const Offset(4, 4);

        // Act
        Offset actualLimitedOffset = actualOffset.limitMin(5, 5);

        // Assert
        Offset expectedLimitedOffset = const Offset(5, 5);

        expect(actualLimitedOffset, expectedLimitedOffset);
      });

      test('Should [return given Offset] if dx and dy are within limits', (){
        // Arrange
        Offset actualOffset = const Offset(4, 4);

        // Act
        Offset actualLimitedOffset = actualOffset.limitMin(3, 3);

        // Assert
        Offset expectedLimitedOffset = const Offset(4, 4);

        expect(actualLimitedOffset, expectedLimitedOffset);
      });
    });
  });
}
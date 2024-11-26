import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';

void main() {
  group('Tests of TextSpanExtensions', () {
    group('Tests of applyDivider()', () {
      test('Should [add divider between characters] for single TextSpan', () {
        // Arrange
        TextSpan span = const TextSpan(text: 'ABC', style: TextStyle(color: Colors.black));

        // Act
        TextSpan actualSpan = span.applyDivider('-');

        // Assert
        TextSpan expectedSpan = const TextSpan(text: 'A-B-C', style: TextStyle(color: Colors.black));
        expect(actualSpan.toPlainText(), expectedSpan.toPlainText());
      });

      test('Should [apply divider recursively] for nested TextSpan children', () {
        // Arrange
        TextSpan span = const TextSpan(
          text: 'AB',
          children: <InlineSpan>[
            TextSpan(text: 'CD'),
            TextSpan(text: 'EF'),
          ],
        );

        // Act
        TextSpan actualSpan = span.applyDivider('-');

        // Assert
        TextSpan expectedSpan = const TextSpan(
          text: 'A-B',
          children: <InlineSpan>[
            TextSpan(text: 'C-D'),
            TextSpan(text: 'E-F'),
          ],
        );
        expect(actualSpan.toPlainText(), expectedSpan.toPlainText());
      });

      test('Should [return the same span] when text is empty', () {
        // Arrange
        TextSpan span = const TextSpan(text: '');

        // Act
        TextSpan actualSpan = span.applyDivider('-');

        // Assert
        expect(actualSpan.toPlainText(), span.toPlainText());
      });

      test('Should [return the same span] when divider is empty', () {
        // Arrange
        TextSpan span = const TextSpan(text: 'ABC');

        // Act
        TextSpan actualSpan = span.applyDivider('');

        // Assert
        expect(actualSpan.toPlainText(), span.toPlainText());
      });

      test('Should [preserve text style] after applying divider', () {
        // Arrange
        TextStyle style = const TextStyle(fontSize: 16, color: Colors.blue);
        TextSpan span = TextSpan(text: 'XYZ', style: style);

        // Act
        TextSpan actualSpan = span.applyDivider(' ');

        // Assert
        TextSpan expectedSpan = TextSpan(text: 'X Y Z', style: style);
        expect(actualSpan.toPlainText(), expectedSpan.toPlainText());
      });

      test('Should [apply divider with complex text structure]', () {
        // Arrange
        TextSpan span = const TextSpan(
          text: 'A',
          children: <InlineSpan>[
            TextSpan(
              text: 'BC',
              children: <InlineSpan>[
                TextSpan(text: 'DE'),
              ],
            ),
          ],
        );

        // Act
        TextSpan actualSpan = span.applyDivider('-');

        // Assert
        TextSpan expectedSpan = const TextSpan(
          text: 'A',
          children: <InlineSpan>[
            TextSpan(
              text: 'B-C',
              children: <InlineSpan>[
                TextSpan(text: 'D-E'),
              ],
            ),
          ],
        );
        expect(actualSpan.toPlainText(), expectedSpan.toPlainText());
      });
    });
  });
}

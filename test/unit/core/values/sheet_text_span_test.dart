import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('Tests of SheetRichText', () {
    group('Constructor Tests', () {
      test('Should [initialize with default span] when [no spans provided]', () {
        // Arrange & Act
        SheetRichText richText = SheetRichText();

        // Assert
        expect(richText.spans.length, 1);
        expect(richText.spans.first.text, '');
      });

      test('Should [initialize with provided spans]', () {
        // Arrange
        List<SheetTextSpan> spans = <SheetTextSpan>[
          SheetTextSpan(text: 'Hello', style: SheetTextSpanStyle()),
          SheetTextSpan(text: 'World', style: SheetTextSpanStyle()),
        ];

        // Act
        SheetRichText richText = SheetRichText(spans: spans);

        // Assert
        List<SheetTextSpan> expectedSpans = <SheetTextSpan>[
          SheetTextSpan(text: 'HelloWorld', style: SheetTextSpanStyle()),
        ];

        expect(richText.spans, expectedSpans);
      });

      test('Should [initialize with single span] when [using .single constructor]', () {
        // Arrange & Act
        SheetRichText richText = SheetRichText.single(text: 'Hello');

        // Assert
        expect(richText.spans.length, 1);
        expect(richText.spans.first.text, 'Hello');
      });
    });

    group('Tests of SheetRichText.isEmpty', () {
      test('Should [return true] when [all spans are empty]', () {
        // Arrange
        SheetRichText richText = SheetRichText(
          spans: <SheetTextSpan>[
            SheetTextSpan(text: '', style: SheetTextSpanStyle()),
            SheetTextSpan(text: '', style: SheetTextSpanStyle()),
          ],
        );

        // Act
        bool isEmpty = richText.isEmpty;

        // Assert
        expect(isEmpty, true);
      });

      test('Should [return false] when [at least one span is not empty]', () {
        // Arrange
        SheetRichText richText = SheetRichText(
          spans: <SheetTextSpan>[
            SheetTextSpan(text: 'Hello', style: SheetTextSpanStyle()),
            SheetTextSpan(text: '', style: SheetTextSpanStyle()),
          ],
        );

        // Act
        bool isEmpty = richText.isEmpty;

        // Assert
        expect(isEmpty, false);
      });
    });

    group('Tests of SheetRichText.toPlainText()', () {
      test('Should [return concatenated text of all spans]', () {
        // Arrange
        SheetRichText richText = SheetRichText(
          spans: <SheetTextSpan>[
            SheetTextSpan(text: 'Hello', style: SheetTextSpanStyle()),
            SheetTextSpan(text: ' World', style: SheetTextSpanStyle()),
          ],
        );

        // Act
        String plainText = richText.toPlainText();

        // Assert
        expect(plainText, 'Hello World');
      });
    });

    group('Tests of SheetRichText.clear()', () {
      test('Should [return empty span] when [clearStyle is true]', () {
        // Arrange
        SheetRichText richText = SheetRichText.single(text: 'Hello');

        // Act
        SheetRichText clearedText = richText.clear();

        // Assert
        expect(clearedText.spans.length, 1);
        expect(clearedText.spans.first.text, '');
      });

      test('Should [return empty span with default style] when [clearStyle is false]', () {
        // Arrange
        SheetRichText richText = SheetRichText.single(
          text: 'Hello',
          style: SheetTextSpanStyle(color: Colors.red),
        );

        // Act
        SheetRichText clearedText = richText.clear(clearStyle: false);

        // Assert
        expect(clearedText.spans.length, 1);
        expect(clearedText.spans.first.text, '');
      });
    });

    group('Tests of SheetRichText.withText()', () {
      test('Should [replace text in the first span]', () {
        // Arrange
        SheetRichText richText = SheetRichText.single(text: 'Old Text');

        // Act
        SheetRichText updatedRichText = richText.withText('New Text');

        // Assert
        expect(updatedRichText.spans.length, 1);
        expect(updatedRichText.spans.first.text, 'New Text');
      });
    });
  });

  group('Tests of SheetTextSpan', () {
    group('Constructor Tests', () {
      test('Should [initialize text and style]', () {
        // Arrange
        const String text = 'Hello';
        SheetTextSpanStyle style = SheetTextSpanStyle(color: Colors.red);

        // Act
        SheetTextSpan span = SheetTextSpan(text: text, style: style);

        // Assert
        expect(span.text, text);
        expect(span.style, style);
      });
    });

    group('Tests of SheetTextSpan.copyWith()', () {
      test('Should [return new instance] with updated text', () {
        // Arrange
        SheetTextSpan span = SheetTextSpan(
          text: 'Hello',
          style: SheetTextSpanStyle(color: Colors.red),
        );

        // Act
        SheetTextSpan updatedSpan = span.copyWith(text: 'Updated');

        // Assert
        expect(updatedSpan.text, 'Updated');
        expect(updatedSpan.style, SheetTextSpanStyle(color: Colors.red));
      });

      test('Should [return new instance] with updated style', () {
        // Arrange
        SheetTextSpan span = SheetTextSpan(
          text: 'Hello',
          style: SheetTextSpanStyle(color: Colors.red),
        );

        // Act
        SheetTextSpan updatedSpan = span.copyWith(style: SheetTextSpanStyle(color: Colors.blue));

        // Assert
        expect(updatedSpan.text, 'Hello');
        expect(updatedSpan.style, SheetTextSpanStyle(color: Colors.blue));
      });
    });

    group('Tests of SheetTextSpan.toTextSpan()', () {
      test('Should [convert to Flutter TextSpan]', () {
        // Arrange
        SheetTextSpan span = SheetTextSpan(
          text: 'Hello',
          style: SheetTextSpanStyle(color: Colors.red),
        );

        // Act
        TextSpan textSpan = span.toTextSpan();

        // Assert
        expect(textSpan.text, 'Hello');
        expect(
          textSpan.style.toString(),
          const TextStyle(
            color: Colors.red,
            fontFamily: 'Arial',
            package: 'sheets',
            fontSize: 13.3,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            letterSpacing: 0,
            decoration: TextDecoration.none,
          ).toString(),
        );
      });
    });
  });
}

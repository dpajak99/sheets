import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/patterns/linear_string_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('Tests of LinearStringPatternMatcher', () {
    group('Tests of LinearStringPatternMatcher.detect()', () {
      test('Should [return null] when [values list is empty]', () {
        // Arrange
        LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
        List<CellProperties> values = <CellProperties>[];

        // Act
        LinearStringPattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain inconsistent integer positions]', () {
        // Arrange
        LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '1 Text'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: 'Text 2'),
            style: CellStyle(),
          ),
        ];

        // Act
        LinearStringPattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain no integers]', () {
        // Arrange
        LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: 'Text'),
            style: CellStyle(),
          ),
        ];

        // Act
        LinearStringPattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return LinearStringPattern] when [values contain valid left-positioned integers]', () {
        // Arrange
        LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '1 Text'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2 Text'),
            style: CellStyle(),
          ),
        ];

        // Act
        LinearStringPattern? actualPattern = matcher.detect(values);

        // Assert
        LinearStringPattern expectedPattern = LinearStringPattern(
          direction: HorizontalDirection.left,
          lastIntegerValue: 2,
          steps: <int>[1],
          values: <String>[' Text', ' Text'],
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });

      test('Should [return LinearStringPattern] when [values contain valid right-positioned integers]', () {
        // Arrange
        LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: 'Text 1'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: 'Text 2'),
            style: CellStyle(),
          ),
        ];

        // Act
        LinearStringPattern? actualPattern = matcher.detect(values);

        // Assert
        LinearStringPattern expectedPattern = LinearStringPattern(
          direction: HorizontalDirection.right,
          lastIntegerValue: 2,
          steps: <int>[1],
          values: <String>['Text ', 'Text '],
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });
    });
  });

  group('Tests of LinearStringPattern', () {
    group('Tests of LinearStringPattern.apply()', () {
      test('Should [fill cells with string sequence] based on [steps and lastIntegerValue] (left-positioned)', () {
        // Arrange
        LinearStringPattern pattern = LinearStringPattern(
          direction: HorizontalDirection.left,
          lastIntegerValue: 1,
          steps: <int>[1],
          values: <String>[' Text'],
        );

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '1 Text'),
            style: CellStyle(),
          ),
        ];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
        ];

        // Act
        List<CellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2 Text'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: '3 Text'),
            style: CellStyle(),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });

      test('Should [fill cells with string sequence] based on [steps and lastIntegerValue] (right-positioned)', () {
        // Arrange
        LinearStringPattern pattern = LinearStringPattern(
          direction: HorizontalDirection.right,
          lastIntegerValue: 1,
          steps: <int>[1],
          values: <String>['Text '],
        );

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: 'Text 1'),
            style: CellStyle(),
          ),
        ];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
        ];

        // Act
        List<CellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: 'Text 2'),
            style: CellStyle(),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });
    });
  });
}

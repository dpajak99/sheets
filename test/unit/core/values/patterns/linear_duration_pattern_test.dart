import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/linear_duration_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('Tests of LinearDurationPatternMatcher', () {
    group('Tests of LinearDurationPatternMatcher.detect()', () {
      test('Should [return null] when [values list is empty]', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<CellProperties> values = <CellProperties>[];

        // Act
        DurationSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain non-duration formats]', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: 'text'),
            style: CellStyle(
              valueFormat: SheetStringFormat(),
            ),
          ),
        ];

        // Act
        DurationSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return DurationSequencePattern] when [values contain valid duration formats] (single step)', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '01:00:00'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '02:00:00'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        // Act
        DurationSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        DurationSequencePattern expectedPattern = DurationSequencePattern(
          steps: <Duration>[const Duration(hours: 1)],
          lastDuration: const Duration(hours: 2),
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });

      test('Should [return DurationSequencePattern] when [values contain valid duration formats] (multi steps)', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '01:00:00'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '03:00:00'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: '06:00:00'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        // Act
        DurationSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        DurationSequencePattern expectedPattern = DurationSequencePattern(
          steps: <Duration>[
            const Duration(hours: 2),
            const Duration(hours: 3),
          ],
          lastDuration: const Duration(hours: 6),
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });
    });
  });

  group('Tests of DurationSequencePattern', () {
    group('Tests of DurationSequencePattern.apply()', () {
      test('Should [fill cells with duration sequence] based on [steps and lastDuration]', () {
        // Arrange
        DurationSequencePattern pattern = DurationSequencePattern(
          steps: <Duration>[const Duration(hours: 1)],
          lastDuration: const Duration(hours: 1),
        );

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '01:00:00'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        // Act
        List<CellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2:00:00.000000'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: '3:00:00.000000'),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });

      test('Should [preserve styles from baseCells] when [filling cells]', () {
        // Arrange
        DurationSequencePattern pattern = DurationSequencePattern(
          steps: <Duration>[const Duration(hours: 1)],
          lastDuration: const Duration(hours: 1),
        );

        CellProperties baseProperties = CellProperties(
          index: CellIndex.zero,
          value: SheetRichText.single(text: '01:00:00', style: SheetTextSpanStyle(color: Colors.red)),
          style: CellStyle(
            valueFormat: SheetDurationFormat.withoutMilliseconds(),
          ),
        );

        List<CellProperties> baseCells = <CellProperties>[baseProperties];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        // Act
        List<CellProperties> actualFilledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2:00:00.000000', style: SheetTextSpanStyle(color: Colors.red)),
            style: CellStyle(
              valueFormat: SheetDurationFormat.withoutMilliseconds(),
            ),
          ),
        ];

        expect(actualFilledCells, expectedFilledCells);
      });
    });
  });
}

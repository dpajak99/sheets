import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/linear_date_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/text_rotation.dart';

void main() {
  group('Tests of LinearDatePatternMatcher', () {
    group('Tests of LinearDatePatternMatcher.detect()', () {
      test('Should [return null] when [values list is empty]', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<CellProperties> values = <CellProperties>[];

        // Act
        DateSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain non-date formats]', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: 'text'),
            style: CellStyle(
              valueFormat: SheetStringFormat(),
            ),
          ),
        ];

        // Act
        DateSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return DateSequencePattern] when [values contain valid date formats] (single step)', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: '2023-11-01'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: '2023-11-02'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
        ];

        // Act
        DateSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        DateSequencePattern expectedPattern = DateSequencePattern(
          steps: <Duration>[const Duration(days: 1)],
          lastDate: DateTime(2023, 11, 2),
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });

      test('Should [return DateSequencePattern] when [values contain valid date formats] (multi steps)', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: '2023-11-01'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: '2023-11-03'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: '2023-11-06'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
        ];

        // Act
        DateSequencePattern? actualPattern = matcher.detect(values);

        // Assert
        DateSequencePattern expectedPattern = DateSequencePattern(
          steps: <Duration>[
            const Duration(days: 2),
            const Duration(days: 3),
          ],
          lastDate: DateTime(2023, 11, 6),
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });
    });
  });

  group('Tests of DateSequencePattern', () {
    group('Tests of DateSequencePattern.apply()', () {
      test('Should [fill cells with date sequence] based on [steps and lastDate]', () {
        // Arrange
        DateSequencePattern pattern = DateSequencePattern(
          steps: <Duration>[const Duration(days: 1)],
          lastDate: DateTime(2023, 11),
        );

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: '2023-11-01'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
        ];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
        ];

        // Act
        List<CellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2023-11-02 00:00:00.000'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: '2023-11-03 00:00:00.000'),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
            ),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });

      test('Should [preserve styles from baseCells] when [filling cells]', () {
        // Arrange
        DateSequencePattern pattern = DateSequencePattern(
          steps: <Duration>[const Duration(days: 1)],
          lastDate: DateTime(2023, 11),
        );

        CellProperties baseProperties = CellProperties(
          index: CellIndex.zero,
          value: SheetRichText.single(text: '2023-11-01', style: SheetTextSpanStyle(color: Colors.red)),
          style: CellStyle(
            valueFormat: SheetDateFormat('yyyy-MM-dd'),
            rotation: TextRotation.angleDown,
          ),
        );

        List<CellProperties> baseCells = <CellProperties>[baseProperties];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '', style: SheetTextSpanStyle(color: Colors.red)),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
              rotation: TextRotation.angleDown,
            ),
          ),
        ];

        // Act
        List<CellProperties> actualFilledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2023-11-02 00:00:00.000', style: SheetTextSpanStyle(color: Colors.red)),
            style: CellStyle(
              valueFormat: SheetDateFormat('yyyy-MM-dd'),
              rotation: TextRotation.angleDown,
            ),
          ),
        ];

        expect(actualFilledCells, expectedFilledCells);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/linear_numeric_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('Tests of LinearNumericPatternMatcher', () {
    group('Tests of LinearNumericPatternMatcher.detect()', () {
      test('Should [return null] when [values list is empty]', () {
        // Arrange
        LinearNumericPatternMatcher matcher = LinearNumericPatternMatcher();
        List<CellProperties> values = <CellProperties>[];

        // Act
        LinearNumericPattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain non-numeric formats]', () {
        // Arrange
        LinearNumericPatternMatcher matcher = LinearNumericPatternMatcher();
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
        LinearNumericPattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return LinearNumericPattern] when [values contain valid numeric formats] (single step)', () {
        // Arrange
        LinearNumericPatternMatcher matcher = LinearNumericPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '1'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        // Act
        LinearNumericPattern? actualPattern = matcher.detect(values);

        // Assert
        LinearNumericPattern expectedPattern = LinearNumericPattern(
          steps: <num>[1],
          lastNumValue: 2,
          precision: 1,
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });

      test('Should [return LinearNumericPattern] when [values contain valid numeric formats] (multi steps)', () {
        // Arrange
        LinearNumericPatternMatcher matcher = LinearNumericPatternMatcher();
        List<CellProperties> values = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '1'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '3'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: '6'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        // Act
        LinearNumericPattern? actualPattern = matcher.detect(values);

        // Assert
        LinearNumericPattern expectedPattern = LinearNumericPattern(
          steps: <num>[2, 3],
          lastNumValue: 6,
          precision: 1,
        );

        expect(actualPattern, isNotNull);
        expect(actualPattern?.steps, expectedPattern.steps);
        expect(actualPattern?.lastValue, expectedPattern.lastValue);
      });
    });
  });

  group('Tests of LinearNumericPattern', () {
    group('Tests of LinearNumericPattern.apply()', () {
      test('Should [fill cells with numeric sequence] based on [steps and lastNumValue]', () {
        // Arrange
        LinearNumericPattern pattern = LinearNumericPattern(
          steps: <num>[1],
          lastNumValue: 1,
          precision: 0,
        );

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: '1'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        // Act
        List<CellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: '3'),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });

      test('Should [preserve styles from baseCells] when [filling cells]', () {
        // Arrange
        LinearNumericPattern pattern = LinearNumericPattern(
          steps: <num>[1],
          lastNumValue: 1,
          precision: 0,
        );

        CellProperties baseProperties = CellProperties(
          index: CellIndex.zero,
          value: SheetRichText.single(text: '1', style: SheetTextSpanStyle(color: Colors.red)),
          style: CellStyle(
            valueFormat: SheetNumberFormat.decimalPattern(),
          ),
        );

        List<CellProperties> baseCells = <CellProperties>[baseProperties];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        // Act
        List<CellProperties> actualFilledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: '2', style: SheetTextSpanStyle(color: Colors.red)),
            style: CellStyle(
              valueFormat: SheetNumberFormat.decimalPattern(),
            ),
          ),
        ];

        expect(actualFilledCells, expectedFilledCells);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/linear_date_pattern.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/text_rotation.dart';

void main() {
  group('Tests of LinearDatePatternMatcher', () {
    group('Tests of LinearDatePatternMatcher.detect()', () {
      test('Should [return null] when [values list is empty]', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain non-date formats]', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: 'text'),
              style: CellStyle(
                valueFormat: SheetStringFormat(),
              ),
            ),
          ),
        ];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return DateSequencePattern] when [values contain valid date formats] (single step)', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-01'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-02'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
        ];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        ValuePattern expectedPattern = DateSequencePattern(
          steps: <Duration>[const Duration(days: 1)],
          lastDate: DateTime(2023, 11, 2),
        );

        expect(actualPattern, expectedPattern);
      });

      test('Should [return DateSequencePattern] when [values contain valid date formats] (multi steps)', () {
        // Arrange
        LinearDatePatternMatcher matcher = LinearDatePatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-01'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-03'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-06'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
        ];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        ValuePattern expectedPattern = DateSequencePattern(
          steps: <Duration>[
            const Duration(days: 2),
            const Duration(days: 3),
          ],
          lastDate: DateTime(2023, 11, 6),
        );

        expect(actualPattern, expectedPattern);
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

        List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-01'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
        ];

        List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
        ];

        // Act
        List<IndexedCellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-02 00:00:00.000'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-03 00:00:00.000'),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
              ),
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
          value: SheetRichText.single(text: '2023-11-01', style: const TextStyle(color: Colors.red)),
          style: CellStyle(
            valueFormat: SheetDateFormat('yyyy-MM-dd'),
            rotation: TextRotation.angleDown,
          ),
        );

        List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
          IndexedCellProperties(index: CellIndex.zero, properties: baseProperties),
        ];

        List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '', style: const TextStyle(color: Colors.red)),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
                rotation: TextRotation.angleDown,
              ),
            ),
          ),
        ];

        // Act
        List<IndexedCellProperties> actualFilledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '2023-11-02 00:00:00.000', style: const TextStyle(color: Colors.red)),
              style: CellStyle(
                valueFormat: SheetDateFormat('yyyy-MM-dd'),
                rotation: TextRotation.angleDown,
              ),
            ),
          ),
        ];

        expect(actualFilledCells, expectedFilledCells);
      });
    });
  });
}

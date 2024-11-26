import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/linear_duration_pattern.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

void main() {
  group('Tests of LinearDurationPatternMatcher', () {
    group('Tests of LinearDurationPatternMatcher.detect()', () {
      test('Should [return null] when [values list is empty]', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        expect(actualPattern, isNull);
      });

      test('Should [return null] when [values contain non-duration formats]', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.zero,
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

      test('Should [return DurationSequencePattern] when [values contain valid duration formats] (single step)', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.zero,
            properties: CellProperties(
              value: SheetRichText.single(text: '01:00:00'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '02:00:00'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
        ];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        ValuePattern expectedPattern = DurationSequencePattern(
          steps: <Duration>[const Duration(hours: 1)],
          lastDuration: const Duration(hours: 2),
        );

        expect(actualPattern, expectedPattern);
      });

      test('Should [return DurationSequencePattern] when [values contain valid duration formats] (multi steps)', () {
        // Arrange
        LinearDurationPatternMatcher matcher = LinearDurationPatternMatcher();
        List<IndexedCellProperties> values = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.zero,
            properties: CellProperties(
              value: SheetRichText.single(text: '01:00:00'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '03:00:00'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '06:00:00'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
        ];

        // Act
        ValuePattern? actualPattern = matcher.detect(values);

        // Assert
        ValuePattern expectedPattern = DurationSequencePattern(
          steps: <Duration>[
            const Duration(hours: 2),
            const Duration(hours: 3),
          ],
          lastDuration: const Duration(hours: 6),
        );

        expect(actualPattern, expectedPattern);
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

        List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.zero,
            properties: CellProperties(
              value: SheetRichText.single(text: '01:00:00'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
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
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
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
              value: SheetRichText.single(text: '2:00:00.000000'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: '3:00:00.000000'),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
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
          value: SheetRichText.single(text: '01:00:00', style: const TextStyle(color: Colors.red)),
          style: CellStyle(
            valueFormat: SheetDurationFormat.withoutMilliseconds(),
          ),
        );

        List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
          IndexedCellProperties(index: CellIndex.zero, properties: baseProperties),
        ];

        List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
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
              value: SheetRichText.single(text: '2:00:00.000000', style: const TextStyle(color: Colors.red)),
              style: CellStyle(
                valueFormat: SheetDurationFormat.withoutMilliseconds(),
              ),
            ),
          ),
        ];

        expect(actualFilledCells, expectedFilledCells);
      });
    });
  });
}

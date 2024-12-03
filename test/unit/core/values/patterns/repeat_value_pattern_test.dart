import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/patterns/repeat_value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/text_rotation.dart';

void main() {
  group('Tests of RepeatValuePattern', () {
    group('Tests of RepeatValuePattern.apply()', () {
      test('Should [repeat base cell values] across fill cells', () {
        // Arrange
        RepeatValuePattern pattern = RepeatValuePattern();

        List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.zero,
            properties: CellProperties(
              value: SheetRichText.single(text: 'Base 1'),
              style: CellStyle(),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: 'Base 2'),
              style: CellStyle(),
            ),
          ),
        ];

        List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(3, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(4, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(),
            ),
          ),
        ];

        // Act
        List<IndexedCellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(2, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: 'Base 1'),
              style: CellStyle(),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(3, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: 'Base 2'),
              style: CellStyle(),
            ),
          ),
          IndexedCellProperties(
            index: CellIndex.raw(4, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: 'Base 1'),
              style: CellStyle(),
            ),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });

      test('Should [preserve styles from baseCells] when repeating values', () {
        // Arrange
        RepeatValuePattern pattern = RepeatValuePattern();

        CellStyle baseStyle = CellStyle(
          rotation: TextRotation.angleDown,
        );

        List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(0, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: 'Base 1', style: const TextStyle(color: Colors.red)),
              style: baseStyle,
            ),
          ),
        ];

        List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
          IndexedCellProperties(
            index: CellIndex.raw(1, 0),
            properties: CellProperties(
              value: SheetRichText.single(text: ''),
              style: CellStyle(),
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
              value: SheetRichText.single(text: 'Base 1', style: const TextStyle(color: Colors.red)),
              style: baseStyle,
            ),
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });
    });
  });
}

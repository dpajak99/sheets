import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/patterns/repeat_value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/text_rotation.dart';

void main() {
  group('Tests of RepeatValuePattern', () {
    group('Tests of RepeatValuePattern.apply()', () {
      test('Should [repeat base cell values] across fill cells', () {
        // Arrange
        RepeatValuePattern pattern = RepeatValuePattern();

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.zero,
            value: SheetRichText.single(text: 'Base 1'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(1, 0),
            value: SheetRichText.single(text: 'Base 2'),
            style: CellStyle(),
          ),
        ];

        List<CellProperties> fillCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(3, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(4, 0),
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
        ];

        // Act
        List<CellProperties> filledCells = pattern.apply(baseCells, fillCells);

        // Assert
        List<CellProperties> expectedFilledCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(2, 0),
            value: SheetRichText.single(text: 'Base 1'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(3, 0),
            value: SheetRichText.single(text: 'Base 2'),
            style: CellStyle(),
          ),
          CellProperties(
            index: CellIndex.raw(4, 0),
            value: SheetRichText.single(text: 'Base 1'),
            style: CellStyle(),
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

        List<CellProperties> baseCells = <CellProperties>[
          CellProperties(
            index: CellIndex.raw(0, 0),
            value: SheetRichText.single(text: 'Base 1', style: SheetTextSpanStyle(color: Colors.red)),
            style: baseStyle,
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
            value: SheetRichText.single(text: 'Base 1', style: SheetTextSpanStyle(color: Colors.red)),
            style: baseStyle,
          ),
        ];

        expect(filledCells, expectedFilledCells);
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/auto_fill_engine.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/patterns/linear_numeric_pattern.dart';
import 'package:sheets/core/values/patterns/repeat_value_pattern.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/direction.dart';

void main() {
  group('Tests of PatternDetector', () {
    test('Should [detect LinearNumericPattern] when [numeric values are provided]', () {
      // Arrange
      PatternDetector detector = PatternDetector();
      List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(1, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: '1'),
            style: CellStyle(),
          ),
        ),
        IndexedCellProperties(
          index: CellIndex.raw(1, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: '2'),
            style: CellStyle(),
          ),
        ),
      ];

      // Act
      ValuePattern pattern = detector.detectPattern(baseCells);

      // Assert
      expect(pattern, isA<LinearNumericPattern>());
    });

    test('Should [detect RepeatValuePattern] when [no specific pattern is matched]', () {
      // Arrange
      PatternDetector detector = PatternDetector();
      List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(0, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: 'text'),
            style: CellStyle(),
          ),
        ),
      ];

      // Act
      ValuePattern pattern = detector.detectPattern(baseCells);

      // Assert
      expect(pattern, isA<RepeatValuePattern>());
    });
  });

  group('Tests of AutoFillEngine', () {
    test('Should [resolve vertically] with numeric pattern', () {
      // Arrange
      List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(0, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: '1'),
            style: CellStyle(),
          ),
        ),
        IndexedCellProperties(
          index: CellIndex.raw(1, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: '2'),
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
      ];

      AutoFillEngine engine = AutoFillEngine(Direction.bottom, baseCells, fillCells);

      // Act
      List<IndexedCellProperties> filledCells = engine.resolve();

      // Assert
      List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(2, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: '3.0'),
            style: CellStyle(),
          ),
        ),
        IndexedCellProperties(
          index: CellIndex.raw(3, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: '4.0'),
            style: CellStyle(),
          ),
        ),
      ];

      expect(filledCells, expectedFilledCells);
    });

    test('Should [resolve horizontally] with repeat pattern', () {
      // Arrange
      List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(0, 0),
          properties: CellProperties(
            value: SheetRichText.single(text: 'Hello'),
            style: CellStyle(),
          ),
        ),
      ];

      List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(0, 1),
          properties: CellProperties(
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
        ),
        IndexedCellProperties(
          index: CellIndex.raw(0, 2),
          properties: CellProperties(
            value: SheetRichText.single(text: ''),
            style: CellStyle(),
          ),
        ),
      ];

      AutoFillEngine engine = AutoFillEngine(Direction.right, baseCells, fillCells);

      // Act
      List<IndexedCellProperties> filledCells = engine.resolve();

      // Assert
      List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
        IndexedCellProperties(
          index: CellIndex.raw(0, 1),
          properties: CellProperties(
            value: SheetRichText.single(text: 'Hello'),
            style: CellStyle(),
          ),
        ),
        IndexedCellProperties(
          index: CellIndex.raw(0, 2),
          properties: CellProperties(
            value: SheetRichText.single(text: 'Hello'),
            style: CellStyle(),
          ),
        ),
      ];

      expect(filledCells, expectedFilledCells);
    });
  });
}

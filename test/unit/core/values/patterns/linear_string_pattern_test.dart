// import 'package:flutter_test/flutter_test.dart';
// import 'package:sheets/core/cell_properties.dart';
// import 'package:sheets/core/sheet_index.dart';
// import 'package:sheets/core/sheet_style.dart';
// import 'package:sheets/core/values/patterns/linear_string_pattern.dart';
// import 'package:sheets/core/values/patterns/value_pattern.dart';
// import 'package:sheets/core/values/sheet_text_span.dart';
//
// void main() {
//   group('Tests of LinearStringPatternMatcher', () {
//     group('Tests of LinearStringPatternMatcher.detect()', () {
//       test('Should [return null] when [values list is empty]', () {
//         // Arrange
//         LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
//         List<IndexedCellProperties> values = <IndexedCellProperties>[];
//
//         // Act
//         ValuePattern? actualPattern = matcher.detect(values);
//
//         // Assert
//         expect(actualPattern, isNull);
//       });
//
//       test('Should [return null] when [values contain inconsistent integer positions]', () {
//         // Arrange
//         LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
//         List<IndexedCellProperties> values = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.zero,
//             properties: CellProperties(
//               value: SheetRichText.single(text: '1 Text'),
//               style: CellStyle(),
//             ),
//           ),
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: 'Text 2'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         // Act
//         ValuePattern? actualPattern = matcher.detect(values);
//
//         // Assert
//         expect(actualPattern, isNull);
//       });
//
//       test('Should [return null] when [values contain no integers]', () {
//         // Arrange
//         LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
//         List<IndexedCellProperties> values = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.zero,
//             properties: CellProperties(
//               value: SheetRichText.single(text: 'Text'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         // Act
//         ValuePattern? actualPattern = matcher.detect(values);
//
//         // Assert
//         expect(actualPattern, isNull);
//       });
//
//       test('Should [return LinearStringPattern] when [values contain valid left-positioned integers]', () {
//         // Arrange
//         LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
//         List<IndexedCellProperties> values = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.zero,
//             properties: CellProperties(
//               value: SheetRichText.single(text: '1 Text'),
//               style: CellStyle(),
//             ),
//           ),
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: '2 Text'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         // Act
//         ValuePattern? actualPattern = matcher.detect(values);
//
//         // Assert
//         ValuePattern expectedPattern = LinearStringPattern(
//           HorizontalDirection.left,
//           2,
//           <int>[1],
//           <String>[' Text', ' Text'],
//         );
//
//         expect(actualPattern, expectedPattern);
//       });
//
//       test('Should [return LinearStringPattern] when [values contain valid right-positioned integers]', () {
//         // Arrange
//         LinearStringPatternMatcher matcher = LinearStringPatternMatcher();
//         List<IndexedCellProperties> values = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.zero,
//             properties: CellProperties(
//               value: SheetRichText.single(text: 'Text 1'),
//               style: CellStyle(),
//             ),
//           ),
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: 'Text 2'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         // Act
//         ValuePattern? actualPattern = matcher.detect(values);
//
//         // Assert
//         ValuePattern expectedPattern = LinearStringPattern(
//           HorizontalDirection.right,
//           2,
//           <int>[1],
//           <String>['Text ', 'Text '],
//         );
//
//         expect(actualPattern, expectedPattern);
//       });
//     });
//   });
//
//   group('Tests of LinearStringPattern', () {
//     group('Tests of LinearStringPattern.apply()', () {
//       test('Should [fill cells with string sequence] based on [steps and lastIntegerValue] (left-positioned)', () {
//         // Arrange
//         LinearStringPattern pattern = LinearStringPattern(
//           HorizontalDirection.left,
//           1,
//           <int>[1],
//           <String>[' Text'],
//         );
//
//         List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.zero,
//             properties: CellProperties(
//               value: SheetRichText.single(text: '1 Text'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: ''),
//               style: CellStyle(),
//             ),
//           ),
//           IndexedCellProperties(
//             index: CellIndex.raw(2, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: ''),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         // Act
//         List<IndexedCellProperties> filledCells = pattern.apply(baseCells, fillCells);
//
//         // Assert
//         List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: '2 Text'),
//               style: CellStyle(),
//             ),
//           ),
//           IndexedCellProperties(
//             index: CellIndex.raw(2, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: '3 Text'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         expect(filledCells, expectedFilledCells);
//       });
//
//       test('Should [fill cells with string sequence] based on [steps and lastIntegerValue] (right-positioned)', () {
//         // Arrange
//         LinearStringPattern pattern = LinearStringPattern(
//           HorizontalDirection.right,
//           1,
//           <int>[1],
//           <String>['Text '],
//         );
//
//         List<IndexedCellProperties> baseCells = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.zero,
//             properties: CellProperties(
//               value: SheetRichText.single(text: 'Text 1'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         List<IndexedCellProperties> fillCells = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: ''),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         // Act
//         List<IndexedCellProperties> filledCells = pattern.apply(baseCells, fillCells);
//
//         // Assert
//         List<IndexedCellProperties> expectedFilledCells = <IndexedCellProperties>[
//           IndexedCellProperties(
//             index: CellIndex.raw(1, 0),
//             properties: CellProperties(
//               value: SheetRichText.single(text: 'Text 2'),
//               style: CellStyle(),
//             ),
//           ),
//         ];
//
//         expect(filledCells, expectedFilledCells);
//       });
//     });
//   });
// }

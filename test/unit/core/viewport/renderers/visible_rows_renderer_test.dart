// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sheets/core/scroll/sheet_scroll_position.dart';
// import 'package:sheets/core/sheet_data.dart';
// import 'package:sheets/core/sheet_index.dart';
// import 'package:sheets/core/sheet_style.dart';
// import 'package:sheets/core/viewport/renderers/visible_rows_renderer.dart';
// import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
// import 'package:sheets/core/viewport/viewport_item.dart';
// import 'package:sheets/utils/directional_values.dart';
//
// void main() {
//   group('Tests of VisibleRowsRenderer.build()', () {
//     test('Should [return list of visible rows] when [viewport and scroll position are set]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
//       SheetDataManager properties = SheetDataManager(
//         data: SheetData(
//           columnCount: 0,
//           rowCount: 10,
//           customRowStyles: <RowIndex, RowStyle>{
//             for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 40), // All rows are 40.0 height
//           },
//         ),
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 0.0, // Vertical scroll position
//         SheetScrollPosition()..offset = 0.0, // Horizontal scroll position
//       );
//
//       VisibleRowsRenderer renderer = VisibleRowsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportRow> visibleRows = renderer.build();
//
//       // Assert
//       List<ViewportRow> expectedRows = <ViewportRow>[
//         ViewportRow(index: RowIndex(0), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 24, 46, 64)),
//         ViewportRow(index: RowIndex(1), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 65, 46, 105)),
//         ViewportRow(index: RowIndex(2), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 106, 46, 146)),
//         ViewportRow(index: RowIndex(3), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 147, 46, 187)),
//         ViewportRow(index: RowIndex(4), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 188, 46, 228)),
//         ViewportRow(index: RowIndex(5), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 229, 46, 269)),
//         ViewportRow(index: RowIndex(6), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 270, 46, 310)),
//         ViewportRow(index: RowIndex(7), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 311, 46, 351)),
//         ViewportRow(index: RowIndex(8), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 352, 46, 392)),
//         ViewportRow(index: RowIndex(9), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 393, 46, 433))
//       ];
//
//       expect(visibleRows, expectedRows);
//     });
//
//     test('Should [handle vertical scrolling] when [scroll position is not zero]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
//       SheetDataManager properties = SheetDataManager(
//         data: SheetData(
//           columnCount: 0,
//           rowCount: 10,
//           customRowStyles: <RowIndex, RowStyle>{
//             for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 50), // All rows are 50.0 height
//           },
//         ),
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 75.0, // Vertical scroll position
//         SheetScrollPosition()..offset = 0.0, // Horizontal scroll position
//       );
//
//       VisibleRowsRenderer renderer = VisibleRowsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportRow> visibleRows = renderer.build();
//
//       // Assert
//       List<ViewportRow> expectedRows = <ViewportRow>[
//         ViewportRow(index: RowIndex(1), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 0, 46, 50)),
//         ViewportRow(index: RowIndex(2), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 51, 46, 101)),
//         ViewportRow(index: RowIndex(3), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 102, 46, 152)),
//         ViewportRow(index: RowIndex(4), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 153, 46, 203)),
//         ViewportRow(index: RowIndex(5), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 204, 46, 254)),
//         ViewportRow(index: RowIndex(6), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 255, 46, 305)),
//         ViewportRow(index: RowIndex(7), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 306, 46, 356)),
//         ViewportRow(index: RowIndex(8), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 357, 46, 407)),
//       ];
//
//       expect(visibleRows, expectedRows);
//     });
//
//     test('Should [return list with first row only] when [no rows fit in the viewport]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 90));
//       SheetDataManager properties = SheetDataManager(
//         data: SheetData(
//           columnCount: 0,
//           rowCount: 5,
//           customRowStyles: <RowIndex, RowStyle>{
//             for (int i = 0; i < 5; i++) RowIndex(i): RowStyle(height: 100),
//           },
//         ),
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 0.0,
//         SheetScrollPosition()..offset = 0.0,
//       );
//
//       VisibleRowsRenderer renderer = VisibleRowsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportRow> visibleRows = renderer.build();
//
//       // Assert
//       List<ViewportRow> expectedRows = <ViewportRow>[
//         ViewportRow(index: RowIndex(0), style: RowStyle(height: 100), rect: const BorderRect.fromLTRB(0, 24, 46, 124)),
//       ];
//
//       expect(visibleRows, expectedRows);
//     });
//
//     test('Should [return correct rows] when [scrolled to middle of rows]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
//       SheetDataManager properties = SheetDataManager(
//         data: SheetData(
//           columnCount: 0,
//           rowCount: 10,
//           customRowStyles: <RowIndex, RowStyle>{
//             for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 50),
//           },
//         ),
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 200.0, // Scroll to skip first 4 rows (4 * 50.0)
//         SheetScrollPosition()..offset = 0.0,
//       );
//
//       VisibleRowsRenderer renderer = VisibleRowsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportRow> visibleRows = renderer.build();
//
//       // Assert
//       List<ViewportRow> expectedRows = <ViewportRow>[
//         ViewportRow(index: RowIndex(3), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, -23, 46, 27)),
//         ViewportRow(index: RowIndex(4), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 28, 46, 78)),
//         ViewportRow(index: RowIndex(5), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 79, 46, 129)),
//         ViewportRow(index: RowIndex(6), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 130, 46, 180)),
//         ViewportRow(index: RowIndex(7), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 181, 46, 231)),
//         ViewportRow(index: RowIndex(8), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 232, 46, 282)),
//         ViewportRow(index: RowIndex(9), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 283, 46, 333))
//       ];
//
//       expect(visibleRows, expectedRows);
//     });
//   });
// }

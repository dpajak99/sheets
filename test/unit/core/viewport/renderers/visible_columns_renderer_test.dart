// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sheets/core/scroll/sheet_scroll_position.dart';
// import 'package:sheets/core/sheet_index.dart';
// import 'package:sheets/core/sheet_properties.dart';
// import 'package:sheets/core/viewport/renderers/visible_columns_renderer.dart';
// import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
// import 'package:sheets/core/viewport/viewport_item.dart';
// import 'package:sheets/utils/directional_values.dart';
//
// void main() {
//   group('Tests of VisibleColumnsRenderer.build()', () {
//     test('Should [return list of visible columns] when [viewport and scroll position are set]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
//       SheetProperties properties = SheetProperties(
//         columnCount: 10,
//         rowCount: 0,
//         customColumnStyles: <ColumnIndex, ColumnStyle>{
//           for (int i = 0; i < 10; i++) ColumnIndex(i): ColumnStyle(width: 60),
//         },
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 0.0, // Vertical scroll position
//         SheetScrollPosition()..offset = 0.0, // Horizontal scroll position
//       );
//
//       VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportColumn> visibleColumns = renderer.build();
//
//       // Assert
//       List<ViewportColumn> expectedColumns = <ViewportColumn>[
//         ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(46, 0, 106, 24)),
//         ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(106, 0, 166, 24)),
//         ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(166, 0, 226, 24)),
//         ViewportColumn(index: ColumnIndex(3), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(226, 0, 286, 24)),
//         ViewportColumn(index: ColumnIndex(4), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(286, 0, 346, 24)),
//       ];
//
//       expect(visibleColumns, expectedColumns);
//     });
//
//     test('Should [handle horizontal scrolling] when [scroll position is not zero]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
//       SheetProperties properties = SheetProperties(
//         columnCount: 10,
//         rowCount: 0,
//         customColumnStyles: <ColumnIndex, ColumnStyle>{
//           for (int i = 0; i < 10; i++) ColumnIndex(i): ColumnStyle(width: 50),
//         },
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 0.0, // Vertical scroll position
//         SheetScrollPosition()..offset = 75.0, // Horizontal scroll position
//       );
//
//       VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportColumn> visibleColumns = renderer.build();
//
//       // Assert
//       List<ViewportColumn> expectedColumns = <ViewportColumn>[
//         ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(21, 0, 71, 24)),
//         ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(71, 0, 121, 24)),
//         ViewportColumn(index: ColumnIndex(3), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(121, 0, 171, 24)),
//         ViewportColumn(index: ColumnIndex(4), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(171, 0, 221, 24)),
//         ViewportColumn(index: ColumnIndex(5), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(221, 0, 271, 24)),
//         ViewportColumn(index: ColumnIndex(6), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(271, 0, 321, 24))
//       ];
//
//       expect(visibleColumns, expectedColumns);
//     });
//
//     test('Should [return list with first column only] when [no columns fit in the viewport]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 50, 200)); // Only row headers width
//       SheetProperties properties = SheetProperties(
//         columnCount: 5,
//         rowCount: 0,
//         customColumnStyles: <ColumnIndex, ColumnStyle>{
//           for (int i = 0; i < 5; i++) ColumnIndex(i): ColumnStyle(width: 100),
//         },
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 0.0,
//         SheetScrollPosition()..offset = 0.0,
//       );
//
//       VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportColumn> visibleColumns = renderer.build();
//
//       // Assert
//       List<ViewportColumn> expectedColumns = <ViewportColumn>[
//         ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 100), rect: const Rect.fromLTRB(46, 0, 146, 24))
//       ];
//
//       expect(visibleColumns, expectedColumns);
//     });
//
//     test('Should [return correct columns] when [scrolled to middle of columns]', () {
//       // Arrange
//       SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
//       SheetProperties properties = SheetProperties(
//         columnCount: 10,
//         rowCount: 0,
//         customColumnStyles: <ColumnIndex, ColumnStyle>{
//           for (int i = 0; i < 10; i++) ColumnIndex(i): ColumnStyle(width: 50),
//         },
//       );
//       DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
//         SheetScrollPosition()..offset = 0.0,
//         SheetScrollPosition()..offset = 200.0, // Scroll to skip first 4 columns (4 * 50.0)
//       );
//
//       VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
//         viewportRect: viewportRect,
//         properties: properties,
//         scrollPosition: scrollPosition,
//       );
//
//       // Act
//       List<ViewportColumn> visibleColumns = renderer.build();
//
//       // Assert
//       List<ViewportColumn> expectedColumns = <ViewportColumn>[
//         ViewportColumn(index: ColumnIndex(4), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(46, 0, 96, 24)),
//         ViewportColumn(index: ColumnIndex(5), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(96, 0, 146, 24)),
//         ViewportColumn(index: ColumnIndex(6), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(146, 0, 196, 24)),
//         ViewportColumn(index: ColumnIndex(7), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(196, 0, 246, 24)),
//         ViewportColumn(index: ColumnIndex(8), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(246, 0, 296, 24)),
//         ViewportColumn(index: ColumnIndex(9), style: ColumnStyle(width: 50), rect: const Rect.fromLTRB(296, 0, 346, 24))
//       ];
//
//       expect(visibleColumns, expectedColumns);
//     });
//   });
// }

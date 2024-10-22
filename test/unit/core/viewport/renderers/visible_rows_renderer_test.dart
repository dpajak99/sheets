import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/renderers/visible_rows_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/utils/directional_values.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:flutter/material.dart';

void main() {
  group('Tests of VisibleRowsRenderer.build()', () {
    test('Should [return list of visible rows] when [viewport and scroll position are set]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
      SheetProperties properties = SheetProperties(
        columnCount: 0,
        rowCount: 10,
        customRowStyles: <RowIndex, RowStyle>{
          for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 40), // All rows are 40.0 height
        },
      );
      DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
        SheetScrollPosition()..offset = 0.0, // Vertical scroll position
        SheetScrollPosition()..offset = 0.0, // Horizontal scroll position
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        properties: properties,
        scrollPosition: scrollPosition,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(0), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 24, 46, 64)),
        ViewportRow(index: RowIndex(1), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 64, 46, 104)),
        ViewportRow(index: RowIndex(2), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 104, 46, 144)),
        ViewportRow(index: RowIndex(3), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 144, 46, 184)),
        ViewportRow(index: RowIndex(4), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 184, 46, 224)),
        ViewportRow(index: RowIndex(5), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 224, 46, 264)),
        ViewportRow(index: RowIndex(6), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 264, 46, 304)),
        ViewportRow(index: RowIndex(7), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 304, 46, 344)),
        ViewportRow(index: RowIndex(8), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 344, 46, 384)),
        ViewportRow(index: RowIndex(9), style: RowStyle(height: 40), rect: const Rect.fromLTRB(0, 384, 46, 424))
      ];

      expect(visibleRows, expectedRows);
    });

    test('Should [handle vertical scrolling] when [scroll position is not zero]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
      SheetProperties properties = SheetProperties(
        columnCount: 0,
        rowCount: 10,
        customRowStyles: <RowIndex, RowStyle>{
          for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 50), // All rows are 50.0 height
        },
      );
      DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
        SheetScrollPosition()..offset = 75.0, // Vertical scroll position
        SheetScrollPosition()..offset = 0.0, // Horizontal scroll position
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        properties: properties,
        scrollPosition: scrollPosition,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(1), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, -1, 46, 49)),
        ViewportRow(index: RowIndex(2), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 49, 46, 99)),
        ViewportRow(index: RowIndex(3), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 99, 46, 149)),
        ViewportRow(index: RowIndex(4), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 149, 46, 199)),
        ViewportRow(index: RowIndex(5), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 199, 46, 249)),
        ViewportRow(index: RowIndex(6), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 249, 46, 299)),
        ViewportRow(index: RowIndex(7), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 299, 46, 349)),
        ViewportRow(index: RowIndex(8), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 349, 46, 399)),
        ViewportRow(index: RowIndex(9), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 399, 46, 449))
      ];

      expect(visibleRows, expectedRows);
    });

    test('Should [return list with first row only] when [no rows fit in the viewport]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 90));
      SheetProperties properties = SheetProperties(
        columnCount: 0,
        rowCount: 5,
        customRowStyles: <RowIndex, RowStyle>{
          for (int i = 0; i < 5; i++) RowIndex(i): RowStyle(height: 100),
        },
      );
      DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
        SheetScrollPosition()..offset = 0.0,
        SheetScrollPosition()..offset = 0.0,
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        properties: properties,
        scrollPosition: scrollPosition,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(0), style: RowStyle(height: 100), rect: const Rect.fromLTRB(0, 24, 46, 124)),
      ];

      expect(visibleRows, expectedRows);
    });

    test('Should [return correct rows] when [scrolled to middle of rows]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
      SheetProperties properties = SheetProperties(
        columnCount: 0,
        rowCount: 10,
        customRowStyles: <RowIndex, RowStyle>{
          for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 50),
        },
      );
      DirectionalValues<SheetScrollPosition> scrollPosition = DirectionalValues<SheetScrollPosition>(
        SheetScrollPosition()..offset = 200.0, // Scroll to skip first 4 rows (4 * 50.0)
        SheetScrollPosition()..offset = 0.0,
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        properties: properties,
        scrollPosition: scrollPosition,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(4), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 24, 46, 74)),
        ViewportRow(index: RowIndex(5), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 74, 46, 124)),
        ViewportRow(index: RowIndex(6), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 124, 46, 174)),
        ViewportRow(index: RowIndex(7), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 174, 46, 224)),
        ViewportRow(index: RowIndex(8), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 224, 46, 274)),
        ViewportRow(index: RowIndex(9), style: RowStyle(height: 50), rect: const Rect.fromLTRB(0, 274, 46, 324))
      ];

      expect(visibleRows, expectedRows);
    });
  });
}

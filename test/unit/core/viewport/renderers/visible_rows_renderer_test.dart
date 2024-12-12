import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/renderers/visible_rows_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

void main() {
  group('Tests of VisibleRowsRenderer.build()', () {
    test('Should [return list of visible rows] when [viewport and scroll position are set]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
      SheetData data = SheetData(
        columnCount: 0,
        rowCount: 10,
        customRowStyles: <RowIndex, RowStyle>{
          for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 40), // All rows are 40.0 height
        },
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 0,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(0), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 25, 46, 65)),
        ViewportRow(index: RowIndex(1), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 66, 46, 106)),
        ViewportRow(index: RowIndex(2), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 107, 46, 147)),
        ViewportRow(index: RowIndex(3), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 148, 46, 188)),
        ViewportRow(index: RowIndex(4), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 189, 46, 229)),
        ViewportRow(index: RowIndex(5), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 230, 46, 270)),
        ViewportRow(index: RowIndex(6), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 271, 46, 311)),
        ViewportRow(index: RowIndex(7), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 312, 46, 352)),
        ViewportRow(index: RowIndex(8), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 353, 46, 393)),
        ViewportRow(index: RowIndex(9), style: RowStyle(height: 40), rect: const BorderRect.fromLTRB(0, 394, 46, 434))
      ];

      expect(visibleRows, expectedRows);
    });

    test('Should [handle vertical scrolling] when [scroll position is not zero]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
      SheetData data = SheetData(
          columnCount: 0,
          rowCount: 10,
          customRowStyles: <RowIndex, RowStyle>{
            for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 50), // All rows are 50.0 height
          },
      );


      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 75,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(1), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 1, 46, 51)),
        ViewportRow(index: RowIndex(2), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 52, 46, 102)),
        ViewportRow(index: RowIndex(3), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 103, 46, 153)),
        ViewportRow(index: RowIndex(4), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 154, 46, 204)),
        ViewportRow(index: RowIndex(5), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 205, 46, 255)),
        ViewportRow(index: RowIndex(6), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 256, 46, 306)),
        ViewportRow(index: RowIndex(7), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 307, 46, 357)),
        ViewportRow(index: RowIndex(8), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 358, 46, 408)),
      ];

      expect(visibleRows, expectedRows);
    });

    test('Should [return list with first row only] when [no rows fit in the viewport]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 90));
      SheetData data = SheetData(
          columnCount: 0,
          rowCount: 5,
          customRowStyles: <RowIndex, RowStyle>{
            for (int i = 0; i < 5; i++) RowIndex(i): RowStyle(height: 100),
          },
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 0,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(0), style: RowStyle(height: 100), rect: const BorderRect.fromLTRB(0, 25, 46, 125)),
      ];

      expect(visibleRows, expectedRows);
    });

    test('Should [return correct rows] when [scrolled to middle of rows]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 400));
      SheetData data = SheetData(
          columnCount: 0,
          rowCount: 10,
          customRowStyles: <RowIndex, RowStyle>{
            for (int i = 0; i < 10; i++) RowIndex(i): RowStyle(height: 50),
          },
      );

      VisibleRowsRenderer renderer = VisibleRowsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 200,
      );

      // Act
      List<ViewportRow> visibleRows = renderer.build();

      // Assert
      List<ViewportRow> expectedRows = <ViewportRow>[
        ViewportRow(index: RowIndex(3), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, -22, 46, 28)),
        ViewportRow(index: RowIndex(4), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 29, 46, 79)),
        ViewportRow(index: RowIndex(5), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 80, 46, 130)),
        ViewportRow(index: RowIndex(6), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 131, 46, 181)),
        ViewportRow(index: RowIndex(7), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 182, 46, 232)),
        ViewportRow(index: RowIndex(8), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 233, 46, 283)),
        ViewportRow(index: RowIndex(9), style: RowStyle(height: 50), rect: const BorderRect.fromLTRB(0, 284, 46, 334))
      ];

      expect(visibleRows, expectedRows);
    });
  });
}

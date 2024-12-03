import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/renderers/visible_columns_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

void main() {
  group('Tests of VisibleColumnsRenderer.build()', () {
    test('Should [return list of visible columns] when [viewport and scroll position are set]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
      SheetData data = SheetData(
        columnCount: 10,
        rowCount: 0,
        customColumnStyles: <ColumnIndex, ColumnStyle>{
          for (int i = 0; i < 10; i++) ColumnIndex(i): ColumnStyle(width: 60),
        },
      );

      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 0,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(46, 0, 106, 24)),
        ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(107, 0, 167, 24)),
        ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(168, 0, 228, 24)),
        ViewportColumn(index: ColumnIndex(3), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(229, 0, 289, 24)),
        ViewportColumn(index: ColumnIndex(4), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(290, 0, 350, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });

    test('Should [handle horizontal scrolling] when [scroll position is not zero]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
      SheetData data = SheetData(
          columnCount: 10,
          rowCount: 0,
          customColumnStyles: <ColumnIndex, ColumnStyle>{
            for (int i = 0; i < 10; i++) ColumnIndex(i): ColumnStyle(width: 50),
          },
      );
      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 75,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(22, 0, 72, 24)),
        ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(73, 0, 123, 24)),
        ViewportColumn(index: ColumnIndex(3), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(124, 0, 174, 24)),
        ViewportColumn(index: ColumnIndex(4), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(175, 0, 225, 24)),
        ViewportColumn(index: ColumnIndex(5), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(226, 0, 276, 24)),
        ViewportColumn(index: ColumnIndex(6), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(277, 0, 327, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });

    test('Should [return list with first column only] when [no columns fit in the viewport]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 50, 200)); // Only row headers width
      SheetData data = SheetData(
          columnCount: 5,
          rowCount: 0,
          customColumnStyles: <ColumnIndex, ColumnStyle>{
            for (int i = 0; i < 5; i++) ColumnIndex(i): ColumnStyle(width: 100),
          },
      );

      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 0,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 100), rect: const BorderRect.fromLTRB(46, 0, 146, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });

    test('Should [return correct columns] when [scrolled to middle of columns]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
      SheetData data =  SheetData(
          columnCount: 10,
          rowCount: 0,
          customColumnStyles: <ColumnIndex, ColumnStyle>{
            for (int i = 0; i < 10; i++) ColumnIndex(i): ColumnStyle(width: 50),
          },
      );

      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        data: data,
        scrollOffset: 200,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(3), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(-1, 0, 49, 24)),
        ViewportColumn(index: ColumnIndex(4), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(50, 0, 100, 24)),
        ViewportColumn(index: ColumnIndex(5), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(101, 0, 151, 24)),
        ViewportColumn(index: ColumnIndex(6), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(152, 0, 202, 24)),
        ViewportColumn(index: ColumnIndex(7), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(203, 0, 253, 24)),
        ViewportColumn(index: ColumnIndex(8), style: ColumnStyle(width: 50), rect: const BorderRect.fromLTRB(254, 0, 304, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });
  });
}

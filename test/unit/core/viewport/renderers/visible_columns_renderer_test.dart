import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/renderers/visible_columns_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

void main() {
  group('Tests of VisibleColumnsRenderer.build()', () {
    test('Should [return list of visible columns] when [viewport and scroll position are set]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
      Worksheet worksheet = Worksheet(
        cols: 10,
        rows: 0,
        columnConfigs: <ColumnIndex, ColumnConfig>{
          for (int i = 0; i < 10; i++) ColumnIndex(i): const ColumnConfig(width: 60),
        },
      );

      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        worksheet: worksheet,
        scrollOffset: 0,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(0), config: const ColumnConfig(width: 60), rect: const BorderRect.fromLTRB(47, 0, 107, 24)),
        ViewportColumn(index: ColumnIndex(1), config: const ColumnConfig(width: 60), rect: const BorderRect.fromLTRB(108, 0, 168, 24)),
        ViewportColumn(index: ColumnIndex(2), config: const ColumnConfig(width: 60), rect: const BorderRect.fromLTRB(169, 0, 229, 24)),
        ViewportColumn(index: ColumnIndex(3), config: const ColumnConfig(width: 60), rect: const BorderRect.fromLTRB(230, 0, 290, 24)),
        ViewportColumn(index: ColumnIndex(4), config: const ColumnConfig(width: 60), rect: const BorderRect.fromLTRB(291, 0, 351, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });

    test('Should [handle horizontal scrolling] when [scroll position is not zero]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
      Worksheet worksheet = Worksheet(
          cols: 10,
          rows: 0,
          columnConfigs: <ColumnIndex, ColumnConfig>{
            for (int i = 0; i < 10; i++) ColumnIndex(i): const ColumnConfig(width: 50),
          },
      );
      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        worksheet: worksheet,
        scrollOffset: 75,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(1), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(23, 0, 73, 24)),
        ViewportColumn(index: ColumnIndex(2), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(74, 0, 124, 24)),
        ViewportColumn(index: ColumnIndex(3), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(125, 0, 175, 24)),
        ViewportColumn(index: ColumnIndex(4), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(176, 0, 226, 24)),
        ViewportColumn(index: ColumnIndex(5), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(227, 0, 277, 24)),
        ViewportColumn(index: ColumnIndex(6), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(278, 0, 328, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });

    test('Should [return list with first column only] when [no columns fit in the viewport]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 50, 200)); // Only row headers width
      Worksheet worksheet = Worksheet(
          cols: 5,
          rows: 0,
          columnConfigs: <ColumnIndex, ColumnConfig>{
            for (int i = 0; i < 5; i++) ColumnIndex(i): const ColumnConfig(),
          },
      );

      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        worksheet: worksheet,
        scrollOffset: 0,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(0), config: const ColumnConfig(), rect: const BorderRect.fromLTRB(47, 0, 147, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });

    test('Should [return correct columns] when [scrolled to middle of columns]', () {
      // Arrange
      SheetViewportRect viewportRect = SheetViewportRect(const Rect.fromLTWH(0, 0, 300, 200));
      Worksheet worksheet =  Worksheet(
          cols: 10,
          rows: 0,
          columnConfigs: <ColumnIndex, ColumnConfig>{
            for (int i = 0; i < 10; i++) ColumnIndex(i): const ColumnConfig(width: 50),
          },
      );

      VisibleColumnsRenderer renderer = VisibleColumnsRenderer(
        viewportRect: viewportRect,
        worksheet: worksheet,
        scrollOffset: 200,
      );

      // Act
      List<ViewportColumn> visibleColumns = renderer.build();

      // Assert
      List<ViewportColumn> expectedColumns = <ViewportColumn>[
        ViewportColumn(index: ColumnIndex(3), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(0, 0, 50, 24)),
        ViewportColumn(index: ColumnIndex(4), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(51, 0, 101, 24)),
        ViewportColumn(index: ColumnIndex(5), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(102, 0, 152, 24)),
        ViewportColumn(index: ColumnIndex(6), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(153, 0, 203, 24)),
        ViewportColumn(index: ColumnIndex(7), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(204, 0, 254, 24)),
        ViewportColumn(index: ColumnIndex(8), config: const ColumnConfig(width: 50), rect: const BorderRect.fromLTRB(255, 0, 305, 24))
      ];

      expect(visibleColumns, expectedColumns);
    });
  });
}

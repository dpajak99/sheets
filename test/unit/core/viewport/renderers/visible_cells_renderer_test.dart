import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/viewport/renderers/visible_cells_renderer.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

void main() {
  group('Tests of VisibleCellsRenderer.build()', () {
    test('Should [return list of visible cells] when [given lists of visible rows and columns]', () {
      // Arrange
      // Create mock visible rows
      List<ViewportRow> visibleRows = List<ViewportRow>.generate(3, (int i) {
        return ViewportRow(
          index: RowIndex(i),
          style: RowStyle(height: 20),
          rect: Rect.fromLTWH(0, 30.0 + i * 20.0, 50, 20),
        );
      });

      // Create mock visible columns
      List<ViewportColumn> visibleColumns = List<ViewportColumn>.generate(3, (int i) {
        return ViewportColumn(
          index: ColumnIndex(i),
          style: ColumnStyle(width: 60),
          rect: Rect.fromLTWH(50.0 + i * 60.0, 0, 60, 30),
        );
      });

      VisibleCellsRenderer renderer = VisibleCellsRenderer(
        visibleRows: visibleRows,
        visibleColumns: visibleColumns,
      );

      // Act
      List<ViewportCell> visibleCells = renderer.build();

      // Assert
      List<ViewportCell> expectedCells = <ViewportCell>[
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(50, 0, 110, 30)),
          ViewportRow(index: RowIndex(0), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 30, 50, 50)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(110, 0, 170, 30)),
          ViewportRow(index: RowIndex(0), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 30, 50, 50)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(170, 0, 230, 30)),
          ViewportRow(index: RowIndex(0), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 30, 50, 50)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(50, 0, 110, 30)),
          ViewportRow(index: RowIndex(1), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 50, 50, 70)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(110, 0, 170, 30)),
          ViewportRow(index: RowIndex(1), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 50, 50, 70)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(170, 0, 230, 30)),
          ViewportRow(index: RowIndex(1), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 50, 50, 70)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(50, 0, 110, 30)),
          ViewportRow(index: RowIndex(2), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 70, 50, 90)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(110, 0, 170, 30)),
          ViewportRow(index: RowIndex(2), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 70, 50, 90)),
        ),
        ViewportCell.fromColumnRow(
          ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const Rect.fromLTRB(170, 0, 230, 30)),
          ViewportRow(index: RowIndex(2), style: RowStyle(height: 20), rect: const Rect.fromLTRB(0, 70, 50, 90)),
        ),
      ];

      expect(visibleCells, expectedCells);
    });

    test('Should [return empty list] when [no visible rows or columns]', () {
      // Arrange
      VisibleCellsRenderer renderer = VisibleCellsRenderer(
        visibleRows: <ViewportRow>[],
        visibleColumns: <ViewportColumn>[],
      );

      // Act
      List<ViewportCell> visibleCells = renderer.build();

      // Assert
      List<ViewportCell> expectedCells = <ViewportCell>[];

      expect(visibleCells, expectedCells);
    });
  });
}

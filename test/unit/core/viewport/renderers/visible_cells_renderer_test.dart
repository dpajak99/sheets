import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
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
          rect: BorderRect.fromLTWH(0, 30.0 + i * 20.0, 50, 20),
        );
      });

      // Create mock visible columns
      List<ViewportColumn> visibleColumns = List<ViewportColumn>.generate(3, (int i) {
        return ViewportColumn(
          index: ColumnIndex(i),
          style: ColumnStyle(width: 60),
          rect: BorderRect.fromLTWH(50.0 + i * 60.0, 0, 60, 30),
        );
      });

      VisibleCellsRenderer renderer = VisibleCellsRenderer(visibleRows: visibleRows, visibleColumns: visibleColumns);
      SheetData data = SheetData(columnCount: 3, rowCount: 3);

      // Act
      List<ViewportCell> visibleCells = renderer.build(data);

      // Assert
      List<ViewportCell> expectedCells = <ViewportCell>[
        // @formatter:off
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(50, 0, 110, 30)),
          row: ViewportRow(index: RowIndex(0), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 30, 50, 50)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(110, 0, 170, 30)),
          row: ViewportRow(index: RowIndex(0), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 30, 50, 50)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(170, 0, 230, 30)),
          row: ViewportRow(index: RowIndex(0), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 30, 50, 50)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(50, 0, 110, 30)),
          row: ViewportRow(index: RowIndex(1), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 50, 50, 70)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(110, 0, 170, 30)),
          row: ViewportRow(index: RowIndex(1), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 50, 50, 70)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(170, 0, 230, 30)),
          row: ViewportRow(index: RowIndex(1), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 50, 50, 70)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(0), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(50, 0, 110, 30)),
          row: ViewportRow(index: RowIndex(2), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 70, 50, 90)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(1), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(110, 0, 170, 30)),
          row: ViewportRow(index: RowIndex(2), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 70, 50, 90)),
        ),
        ViewportCell(
          column: ViewportColumn(index: ColumnIndex(2), style: ColumnStyle(width: 60), rect: const BorderRect.fromLTRB(170, 0, 230, 30)),
          row: ViewportRow(index: RowIndex(2), style: RowStyle(height: 20), rect: const BorderRect.fromLTRB(0, 70, 50, 90)),
        ),
        // @formatter:on
      ];

      expect(visibleCells, expectedCells);
    });

    test('Should [return empty list] when [no visible rows or columns]', () {
      // Arrange
      VisibleCellsRenderer renderer = VisibleCellsRenderer(
        visibleRows: <ViewportRow>[],
        visibleColumns: <ViewportColumn>[],
      );
      SheetData data = SheetData(columnCount: 0, rowCount: 0);

      // Act
      List<ViewportCell> visibleCells = renderer.build(data);

      // Assert
      List<ViewportCell> expectedCells = <ViewportCell>[];

      expect(visibleCells, expectedCells);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/renderers/visible_cells_renderer.dart';
import 'package:sheets/core/viewport/renderers/visible_columns_renderer.dart';
import 'package:sheets/core/viewport/renderers/visible_rows_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_data.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';

class SheetViewportContentManager {
  SheetViewportContentManager(this._worksheet) : _contentData = SheetViewportContentData();

  final SheetViewportContentData _contentData;
  final Worksheet _worksheet;

  void rebuild(SheetViewportRect viewportRect, Offset scrollOffset) {
    List<ViewportRow> rows = _calculateRows(viewportRect, scrollOffset.dy);
    List<ViewportColumn> columns = _calculateColumns(viewportRect, scrollOffset.dx);
    List<ViewportCell> cells = _calculateCells(rows, columns);

    _contentData.update(rows, columns, cells);
  }

  List<ViewportRow> get rows => _contentData.rows;

  List<ViewportColumn> get columns => _contentData.columns;

  List<ViewportCell> get cells => _contentData.cells;

  List<ViewportItem> get all => _contentData.all;

  bool containsCell(CellIndex cellIndex) {
    return _contentData.containsCell(cellIndex.toRealIndex(
      cols: _worksheet.cols,
      rows: _worksheet.rows,
    ));
  }

  ClosestVisible<ViewportCell> findCellOrClosest(CellIndex cellIndex) {
    return _contentData.findCellOrClosest(_worksheet, cellIndex.toRealIndex(
      cols: _worksheet.cols,
      rows: _worksheet.rows,
    ));
  }

  ViewportCell? findCell(CellIndex cellIndex) {
    return _contentData.findCell(_worksheet, cellIndex.toRealIndex(
      cols: _worksheet.cols,
      rows: _worksheet.rows,
    ));
  }

  ViewportItem? findAnyByOffset(Offset mousePosition) => _contentData.findAnyByOffset(mousePosition);

  ClosestVisible<ViewportCell> findClosestCell(CellIndex cellIndex) {
    return _contentData.findClosestCell(_worksheet, cellIndex.toRealIndex(
      cols: _worksheet.cols,
      rows: _worksheet.rows,
    ));
  }

  List<ViewportRow> _calculateRows(SheetViewportRect viewportRect, double scrollOffset) {
    return VisibleRowsRenderer(worksheet: _worksheet, viewportRect: viewportRect, scrollOffset: scrollOffset).build();
  }

  List<ViewportColumn> _calculateColumns(SheetViewportRect viewportRect, double scrollOffset) {
    return VisibleColumnsRenderer(worksheet: _worksheet, viewportRect: viewportRect, scrollOffset: scrollOffset).build();
  }

  List<ViewportCell> _calculateCells(List<ViewportRow> visibleRows, List<ViewportColumn> visibleColumns) {
    return VisibleCellsRenderer(visibleRows: visibleRows, visibleColumns: visibleColumns).build(_worksheet);
  }
}

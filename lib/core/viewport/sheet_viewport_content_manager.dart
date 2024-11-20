import 'package:flutter/material.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/renderers/visible_cells_renderer.dart';
import 'package:sheets/core/viewport/renderers/visible_columns_renderer.dart';
import 'package:sheets/core/viewport/renderers/visible_rows_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_data.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/directional_values.dart';

class SheetViewportContentManager extends ChangeNotifier {
  SheetViewportContentManager(this._dataManager) : _data = SheetViewportContentData();

  final SheetViewportContentData _data;
  final SheetDataManager _dataManager;

  void rebuild(SheetViewportRect viewportRect, DirectionalValues<SheetScrollPosition> scrollPosition) {
    List<ViewportRow> rows = _calculateRows(viewportRect, scrollPosition);
    List<ViewportColumn> columns = _calculateColumns(viewportRect, scrollPosition);
    List<ViewportCell> cells = _calculateCells(rows, columns);

    _data.update(rows, columns, cells);
    notifyListeners();
  }

  List<ViewportRow> get rows => _data.rows;

  List<ViewportColumn> get columns => _data.columns;

  List<ViewportCell> get cells => _data.cells;

  List<ViewportItem> get all => _data.all;

  bool containsCell(CellIndex cellIndex) {
    return _data.containsCell(cellIndex.toRealIndex(
      columnCount: _dataManager.columnCount,
      rowCount: _dataManager.rowCount,
    ));
  }

  ClosestVisible<ViewportCell> findCellOrClosest(CellIndex cellIndex) {
    return _data.findCellOrClosest(cellIndex.toRealIndex(
      columnCount: _dataManager.columnCount,
      rowCount: _dataManager.rowCount,
    ));
  }

  ViewportCell? findCell(CellIndex cellIndex) {
    return _data.findCell(cellIndex.toRealIndex(
      columnCount: _dataManager.columnCount,
      rowCount: _dataManager.rowCount,
    ));
  }

  ViewportItem? findAnyByOffset(Offset mousePosition) => _data.findAnyByOffset(mousePosition);

  ClosestVisible<ViewportCell> findClosestCell(CellIndex cellIndex) {
    return _data.findClosestCell(cellIndex.toRealIndex(
      columnCount: _dataManager.columnCount,
      rowCount: _dataManager.rowCount,
    ));
  }

  List<ViewportRow> _calculateRows(SheetViewportRect viewportRect, DirectionalValues<SheetScrollPosition> scrollPosition) {
    return VisibleRowsRenderer(properties: _dataManager, viewportRect: viewportRect, scrollPosition: scrollPosition).build();
  }

  List<ViewportColumn> _calculateColumns(SheetViewportRect viewportRect, DirectionalValues<SheetScrollPosition> scrollPosition) {
    return VisibleColumnsRenderer(properties: _dataManager, viewportRect: viewportRect, scrollPosition: scrollPosition).build();
  }

  List<ViewportCell> _calculateCells(List<ViewportRow> visibleRows, List<ViewportColumn> visibleColumns) {
    return VisibleCellsRenderer(visibleRows: visibleRows, visibleColumns: visibleColumns).build(_dataManager);
  }
}

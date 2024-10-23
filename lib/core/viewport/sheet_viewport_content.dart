import 'package:flutter/material.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/viewport/renderers/visible_cells_renderer.dart';
import 'package:sheets/core/viewport/renderers/visible_columns_renderer.dart';
import 'package:sheets/core/viewport/renderers/visible_rows_renderer.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_data.dart';
import 'package:sheets/core/viewport/sheet_viewport_rect.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/closest_visible.dart';
import 'package:sheets/utils/directional_values.dart';

class SheetViewportContent extends ChangeNotifier {
  final SheetViewportContentData _data = SheetViewportContentData();
  late SheetProperties _properties;

  void applyProperties(SheetProperties properties) {
    _properties = properties;
  }

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

  bool containsCell(CellIndex cellIndex) => _data.containsCell(cellIndex.toRealIndex(_properties));

  ClosestVisible<ViewportCell> findCellOrClosest(CellIndex cellIndex) {
    return _data.findCellOrClosest(cellIndex.toRealIndex(_properties));
  }

  ViewportCell? findCell(CellIndex cellIndex) => _data.findCell(cellIndex.toRealIndex(_properties));

  ViewportItem? findAnyByOffset(Offset mousePosition) => _data.findAnyByOffset(mousePosition);

  ClosestVisible<ViewportCell> findClosestCell(CellIndex cellIndex) => _data.findClosestCell(cellIndex.toRealIndex(_properties));

  List<ViewportRow> _calculateRows(SheetViewportRect viewportRect, DirectionalValues<SheetScrollPosition> scrollPosition) {
    return VisibleRowsRenderer(properties: _properties, viewportRect: viewportRect, scrollPosition: scrollPosition).build();
  }

  List<ViewportColumn> _calculateColumns(SheetViewportRect viewportRect, DirectionalValues<SheetScrollPosition> scrollPosition) {
    return VisibleColumnsRenderer(properties: _properties, viewportRect: viewportRect, scrollPosition: scrollPosition).build();
  }

  List<ViewportCell> _calculateCells(List<ViewportRow> visibleRows, List<ViewportColumn> visibleColumns) {
    return VisibleCellsRenderer(visibleRows: visibleRows, visibleColumns: visibleColumns).build();
  }
}

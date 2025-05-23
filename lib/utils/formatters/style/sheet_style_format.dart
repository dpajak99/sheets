import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/border_edge.dart';
import 'package:sheets/utils/border_edges.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';

abstract class SheetStyleFormatIntent extends StyleFormatIntent {
  SheetStyleFormatIntent();

  SheetStyleFormatAction<SheetStyleFormatIntent> createAction();
}

abstract class SheetStyleFormatAction<I extends SheetStyleFormatIntent> extends StyleFormatAction<I> {
  SheetStyleFormatAction({required super.intent});

  void format(WorksheetData data);
}

// Border
class SetBorderIntent extends SheetStyleFormatIntent {
  SetBorderIntent({
    required this.edges,
    required this.selectedCells,
    required this.borderSide,
  });

  final BorderEdges edges;
  final List<CellIndex> selectedCells;
  final BorderSide borderSide;

  @override
  SetBorderAction createAction() {
    return SetBorderAction(intent: this);
  }
}

class SetBorderAction extends SheetStyleFormatAction<SetBorderIntent> {
  SetBorderAction({required super.intent});

  @override
  void format(WorksheetData data) {
    switch (intent.edges) {
      case BorderEdges.all:
        _applyBorders(data, <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left});
      case BorderEdges.clear:
        _clearBorders(data);
      case BorderEdges.inner:
        _applyInnerBorders(data, horizontal: true, vertical: true);
      case BorderEdges.horizontal:
        _applyHorizontalBorders(data);
      case BorderEdges.vertical:
        _applyVerticalBorders(data);
      case BorderEdges.left:
        _applyBorders(data, <BorderEdge>{BorderEdge.left}, entireSelection: true);
      case BorderEdges.right:
        _applyBorders(data, <BorderEdge>{BorderEdge.right}, entireSelection: true);
      case BorderEdges.bottom:
        _applyBorders(data, <BorderEdge>{BorderEdge.bottom}, entireSelection: true);
      case BorderEdges.top:
        _applyBorders(data, <BorderEdge>{BorderEdge.top}, entireSelection: true);
      case BorderEdges.outer:
        _applyOuterBorders(data);
    }
  }

  void _applyHorizontalBorders(WorksheetData data) {
    RowIndex topRow = _getTopmostRow();
    RowIndex bottomRow = _getBottommostRow();

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.row == topRow)) {
      _updateCellBorder(data, cellIndex, <BorderEdge>{BorderEdge.top}, isAdding: true);
    }

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.row == bottomRow)) {
      _updateCellBorder(data, cellIndex, <BorderEdge>{BorderEdge.bottom}, isAdding: true);
    }

    _applyInnerBorders(data, horizontal: true);
  }

  void _applyVerticalBorders(WorksheetData data) {
    ColumnIndex leftColumn = _getLeftmostColumn();
    ColumnIndex rightColumn = _getRightmostColumn();

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.column == leftColumn)) {
      _updateCellBorder(data, cellIndex, <BorderEdge>{BorderEdge.left}, isAdding: true);
    }

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.column == rightColumn)) {
      _updateCellBorder(data, cellIndex, <BorderEdge>{BorderEdge.right}, isAdding: true);
    }

    _applyInnerBorders(data, vertical: true);
  }

  void _applyBorders(WorksheetData data, Set<BorderEdge> edges, {bool entireSelection = false}) {
    if (entireSelection) {
      Set<CellIndex> cellsToUpdate = _getEdgeCells(edges);
      for (CellIndex cellIndex in cellsToUpdate) {
        _updateCellBorder(data, cellIndex, edges, isAdding: true);
      }
    } else {
      for (CellIndex cellIndex in intent.selectedCells) {
        _updateCellBorder(data, cellIndex, edges, isAdding: true);
      }
    }
  }

  void _clearBorders(WorksheetData data) {
    for (CellIndex cellIndex in intent.selectedCells) {
      Set<BorderEdge> edges = <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left};
      _clearCellBorder(data, cellIndex, edges, isAdding: false);
    }
  }

  void _applyInnerBorders(WorksheetData data, {bool horizontal = false, bool vertical = false}) {
    for (CellIndex cellIndex in intent.selectedCells) {
      Set<BorderEdge> internalEdges = _getInternalEdges(cellIndex, horizontal: horizontal, vertical: vertical);
      _updateCellBorder(data, cellIndex, internalEdges, isAdding: true);
    }
  }

  void _applyOuterBorders(WorksheetData data) {
    for (CellIndex cellIndex in intent.selectedCells) {
      Set<BorderEdge> outerEdges = _getOuterEdges(cellIndex);
      if (outerEdges.isNotEmpty) {
        _updateCellBorder(data, cellIndex, outerEdges, isAdding: true);
      }
    }
  }

  Set<BorderEdge> _getInternalEdges(CellIndex cellIndex, {bool horizontal = true, bool vertical = true}) {
    Set<BorderEdge> internalEdges = <BorderEdge>{};

    if (horizontal) {
      if (intent.selectedCells.contains(CellIndex(row: cellIndex.row - 1, column: cellIndex.column))) {
        internalEdges.add(BorderEdge.top);
      }
      if (intent.selectedCells.contains(CellIndex(row: cellIndex.row + 1, column: cellIndex.column))) {
        internalEdges.add(BorderEdge.bottom);
      }
    }

    if (vertical) {
      if (intent.selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column - 1))) {
        internalEdges.add(BorderEdge.left);
      }
      if (intent.selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column + 1))) {
        internalEdges.add(BorderEdge.right);
      }
    }

    return internalEdges;
  }

  Set<BorderEdge> _getOuterEdges(CellIndex cellIndex) {
    Set<BorderEdge> outerEdges = <BorderEdge>{};

    if (!intent.selectedCells.contains(CellIndex(row: cellIndex.row - 1, column: cellIndex.column))) {
      outerEdges.add(BorderEdge.top);
    }
    if (!intent.selectedCells.contains(CellIndex(row: cellIndex.row + 1, column: cellIndex.column))) {
      outerEdges.add(BorderEdge.bottom);
    }
    if (!intent.selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column - 1))) {
      outerEdges.add(BorderEdge.left);
    }
    if (!intent.selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column + 1))) {
      outerEdges.add(BorderEdge.right);
    }

    return outerEdges;
  }

  Set<CellIndex> _getEdgeCells(Set<BorderEdge> edges) {
    Set<CellIndex> cells = <CellIndex>{};

    if (edges.contains(BorderEdge.top)) {
      RowIndex topRow = _getTopmostRow();
      cells.addAll(intent.selectedCells.where((CellIndex c) => c.row == topRow));
    }
    if (edges.contains(BorderEdge.bottom)) {
      RowIndex bottomRow = _getBottommostRow();
      cells.addAll(intent.selectedCells.where((CellIndex c) => c.row == bottomRow));
    }
    if (edges.contains(BorderEdge.left)) {
      ColumnIndex leftColumn = _getLeftmostColumn();
      cells.addAll(intent.selectedCells.where((CellIndex c) => c.column == leftColumn));
    }
    if (edges.contains(BorderEdge.right)) {
      ColumnIndex rightColumn = _getRightmostColumn();
      cells.addAll(intent.selectedCells.where((CellIndex c) => c.column == rightColumn));
    }

    return cells;
  }

  RowIndex _getTopmostRow() => intent.selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a < b ? a : b);

  RowIndex _getBottommostRow() =>
      intent.selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a > b ? a : b);

  ColumnIndex _getLeftmostColumn() =>
      intent.selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a < b ? a : b);

  ColumnIndex _getRightmostColumn() =>
      intent.selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a > b ? a : b);

  void _updateCellBorder(WorksheetData data, CellIndex cellIndex, Set<BorderEdge> edges, {required bool isAdding}) {
    CellProperties cellProperties = data.cells.get(cellIndex);
    Border currentBorder = cellProperties.style.border ?? const Border();

    Border newBorder = Border(
      top: edges.contains(BorderEdge.top) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.top,
      right: edges.contains(BorderEdge.right) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.right,
      bottom: edges.contains(BorderEdge.bottom) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.bottom,
      left: edges.contains(BorderEdge.left) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.left,
    );

    data.cells.setStyle(cellIndex, cellProperties.style.copyWith(border: newBorder));
  }

  void _clearCellBorder(WorksheetData data, CellIndex cellIndex, Set<BorderEdge> edges, {required bool isAdding}) {
    _updateCellBorder(data, cellIndex, edges, isAdding: false);

    for (BorderEdge edge in edges) {
      CellIndex? adjacentIndex = _getAdjacentCellIndex(data, cellIndex, edge);
      if (adjacentIndex != null) {
        CellProperties adjacentCell = data.cells.get(adjacentIndex);
        Border adjacentBorder = adjacentCell.style.border ?? const Border();

        Border updatedAdjacentBorder = Border(
          top: edge.opposite == BorderEdge.top ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.top,
          right: edge.opposite == BorderEdge.right ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.right,
          bottom: edge.opposite == BorderEdge.bottom ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.bottom,
          left: edge.opposite == BorderEdge.left ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.left,
        );

        data.cells.setStyle(adjacentIndex, adjacentCell.style.copyWith(border: updatedAdjacentBorder));
      }
    }
  }

  CellIndex? _getAdjacentCellIndex(WorksheetData data, CellIndex cellIndex, BorderEdge edge) {
    int maxRow = data.rowCount - 1;
    int maxColumn = data.columnCount - 1;

    switch (edge) {
      case BorderEdge.top:
        return cellIndex.row.value > 0 ? CellIndex(row: cellIndex.row - 1, column: cellIndex.column) : null;
      case BorderEdge.bottom:
        return cellIndex.row.value < maxRow ? CellIndex(row: cellIndex.row + 1, column: cellIndex.column) : null;
      case BorderEdge.left:
        return cellIndex.column.value > 0 ? CellIndex(row: cellIndex.row, column: cellIndex.column - 1) : null;
      case BorderEdge.right:
        return cellIndex.column.value < maxColumn ? CellIndex(row: cellIndex.row, column: cellIndex.column + 1) : null;
    }
  }
}

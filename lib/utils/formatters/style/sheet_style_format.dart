import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/utils/border_edge.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_border_button.dart';

abstract class SheetStyleFormatIntent extends StyleFormatIntent {
  SheetStyleFormatIntent();

  SheetStyleFormatAction<SheetStyleFormatIntent> createAction();
}

abstract class SheetStyleFormatAction<I extends SheetStyleFormatIntent> extends StyleFormatAction<I> {
  SheetStyleFormatAction({required super.intent});

  void format(SheetProperties properties);
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
  SheetStyleFormatAction<SetBorderIntent> createAction() {
    return SetBorderAction(intent: this);
  }
}

class SetBorderAction extends SheetStyleFormatAction<SetBorderIntent> {
  SetBorderAction({required super.intent});

  @override
  void format(SheetProperties properties) {
    switch (intent.edges) {
      case BorderEdges.all:
        _applyBorders(properties, <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left});
      case BorderEdges.clear:
        _clearBorders(properties);
      case BorderEdges.inner:
        _applyInnerBorders(properties, horizontal: true, vertical: true);
      case BorderEdges.horizontal:
        _applyHorizontalBorders(properties);
      case BorderEdges.vertical:
        _applyVerticalBorders(properties);
      case BorderEdges.left:
        _applyBorders(properties, <BorderEdge>{BorderEdge.left}, entireSelection: true);
      case BorderEdges.right:
        _applyBorders(properties, <BorderEdge>{BorderEdge.right}, entireSelection: true);
      case BorderEdges.bottom:
        _applyBorders(properties, <BorderEdge>{BorderEdge.bottom}, entireSelection: true);
      case BorderEdges.top:
        _applyBorders(properties, <BorderEdge>{BorderEdge.top}, entireSelection: true);
      case BorderEdges.outer:
        _applyOuterBorders(properties);
    }
  }

  void _applyHorizontalBorders(SheetProperties properties) {
    RowIndex topRow = _getTopmostRow();
    RowIndex bottomRow = _getBottommostRow();

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.row == topRow)) {
      _updateCellBorder(properties, cellIndex, <BorderEdge>{BorderEdge.top}, isAdding: true);
    }

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.row == bottomRow)) {
      _updateCellBorder(properties, cellIndex, <BorderEdge>{BorderEdge.bottom}, isAdding: true);
    }

    _applyInnerBorders(properties, horizontal: true);
  }

  void _applyVerticalBorders(SheetProperties properties) {
    ColumnIndex leftColumn = _getLeftmostColumn();
    ColumnIndex rightColumn = _getRightmostColumn();

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.column == leftColumn)) {
      _updateCellBorder(properties, cellIndex, <BorderEdge>{BorderEdge.left}, isAdding: true);
    }

    for (CellIndex cellIndex in intent.selectedCells.where((CellIndex c) => c.column == rightColumn)) {
      _updateCellBorder(properties, cellIndex, <BorderEdge>{BorderEdge.right}, isAdding: true);
    }

    _applyInnerBorders(properties, vertical: true);
  }

  void _applyBorders(SheetProperties properties, Set<BorderEdge> edges, {bool entireSelection = false}) {
    if (entireSelection) {
      Set<CellIndex> cellsToUpdate = _getEdgeCells(edges);
      for (CellIndex cellIndex in cellsToUpdate) {
        _updateCellBorder(properties, cellIndex, edges, isAdding: true);
      }
    } else {
      for (CellIndex cellIndex in intent.selectedCells) {
        _updateCellBorder(properties, cellIndex, edges, isAdding: true);
      }
    }
  }

  void _clearBorders(SheetProperties properties) {
    for (CellIndex cellIndex in intent.selectedCells) {
      Set<BorderEdge> edges = <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left};
      _updateCellBorder(properties, cellIndex, edges, isAdding: false);
    }
  }

  void _applyInnerBorders(SheetProperties properties, {bool horizontal = false, bool vertical = false}) {
    for (CellIndex cellIndex in intent.selectedCells) {
      Set<BorderEdge> internalEdges = _getInternalEdges(cellIndex, horizontal: horizontal, vertical: vertical);
      _updateCellBorder(properties, cellIndex, internalEdges, isAdding: true);
    }
  }

  void _applyOuterBorders(SheetProperties properties) {
    for (CellIndex cellIndex in intent.selectedCells) {
      Set<BorderEdge> outerEdges = _getOuterEdges(cellIndex);
      if (outerEdges.isNotEmpty) {
        _updateCellBorder(properties, cellIndex, outerEdges, isAdding: true);
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

  RowIndex _getBottommostRow() => intent.selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a > b ? a : b);

  ColumnIndex _getLeftmostColumn() =>
      intent.selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a < b ? a : b);

  ColumnIndex _getRightmostColumn() =>
      intent.selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a > b ? a : b);

  void _updateCellBorder(SheetProperties properties, CellIndex cellIndex, Set<BorderEdge> edges, {required bool isAdding}) {
    CellProperties cellProperties = properties.getCellProperties(cellIndex);
    Border currentBorder = cellProperties.style.border ?? const Border();

    Border newBorder = Border(
      top: edges.contains(BorderEdge.top) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.top,
      right: edges.contains(BorderEdge.right) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.right,
      bottom: edges.contains(BorderEdge.bottom) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.bottom,
      left: edges.contains(BorderEdge.left) ? (isAdding ? intent.borderSide : BorderSide.none) : currentBorder.left,
    );

    properties.setCellStyle(cellIndex, cellProperties.style.copyWith(border: newBorder));

    for (BorderEdge edge in edges) {
      CellIndex? adjacentIndex = _getAdjacentCellIndex(properties, cellIndex, edge);
      if (adjacentIndex != null) {
        CellProperties adjacentCell = properties.getCellProperties(adjacentIndex);
        BorderEdge oppositeEdge = _getOppositeEdge(edge);
        Border adjacentBorder = adjacentCell.style.border ?? const Border();

        Border updatedAdjacentBorder = Border(
          top: oppositeEdge == BorderEdge.top ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.top,
          right: oppositeEdge == BorderEdge.right ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.right,
          bottom: oppositeEdge == BorderEdge.bottom ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.bottom,
          left: oppositeEdge == BorderEdge.left ? (isAdding ? intent.borderSide : BorderSide.none) : adjacentBorder.left,
        );

        properties.setCellStyle(adjacentIndex, adjacentCell.style.copyWith(border: updatedAdjacentBorder));
      }
    }
  }

  BorderEdge _getOppositeEdge(BorderEdge edge) {
    switch (edge) {
      case BorderEdge.top:
        return BorderEdge.bottom;
      case BorderEdge.bottom:
        return BorderEdge.top;
      case BorderEdge.left:
        return BorderEdge.right;
      case BorderEdge.right:
        return BorderEdge.left;
    }
  }

  CellIndex? _getAdjacentCellIndex(SheetProperties properties, CellIndex cellIndex, BorderEdge edge) {
    int maxRow = properties.rowCount - 1;
    int maxColumn = properties.columnCount - 1;

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
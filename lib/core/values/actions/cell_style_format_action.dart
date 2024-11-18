import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_border_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

abstract class FormatAction with EquatableMixin {
  FormatAction({this.autoresize = false});

  final bool autoresize;
}

abstract class CellStyleFormatAction extends FormatAction {
  CellStyleFormatAction();

  void format(CellStyle previousCellStyle);
}

class UpdateHorizontalTextAlignAction extends CellStyleFormatAction {
  UpdateHorizontalTextAlignAction(this.textAlign);

  final TextAlign textAlign;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.textAlign = textAlign;
  }

  @override
  List<Object?> get props => <Object?>[textAlign];
}

class UpdateVerticalTextAlignAction extends CellStyleFormatAction {
  UpdateVerticalTextAlignAction(this.textVerticalAlign);

  final TextVerticalAlign textVerticalAlign;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.textVerticalAlign = textVerticalAlign;
  }

  @override
  List<Object?> get props => <Object?>[textVerticalAlign];
}

class UpdateBackgroundColorAction extends CellStyleFormatAction {
  UpdateBackgroundColorAction(this.color);

  final Color color;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.backgroundColor = color;
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateValueFormatAction extends CellStyleFormatAction {
  UpdateValueFormatAction(this.valueFormat);

  final SheetValueFormat valueFormat;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.valueFormat = valueFormat;
  }

  @override
  List<Object?> get props => <Object?>[valueFormat];
}

abstract class FullFormatAction extends FormatAction {
  void format(SheetProperties sheetProperties);
}

enum BorderEdge { top, right, bottom, left }

class UpdateBorderFormatAction extends FullFormatAction {
  UpdateBorderFormatAction({
    required this.borderEdges,
    required this.selectedCells,
    required this.borderSide,
  });

  final BorderEdges borderEdges;
  final List<CellIndex> selectedCells;
  final BorderSide borderSide;

  @override
  void format(SheetProperties sheetProperties) {
    switch (borderEdges) {
      case BorderEdges.all:
        _applyBorders(sheetProperties, <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left});
      case BorderEdges.clear:
        _clearBorders(sheetProperties);
      case BorderEdges.inner:
        _applyInnerBorders(sheetProperties, horizontal: true, vertical: true);
      case BorderEdges.horizontal:
        _applyHorizontalBorders(sheetProperties);
      case BorderEdges.vertical:
        _applyVerticalBorders(sheetProperties);
      case BorderEdges.left:
        _applyBorders(sheetProperties, <BorderEdge>{BorderEdge.left}, entireSelection: true);
      case BorderEdges.right:
        _applyBorders(sheetProperties, <BorderEdge>{BorderEdge.right}, entireSelection: true);
      case BorderEdges.bottom:
        _applyBorders(sheetProperties, <BorderEdge>{BorderEdge.bottom}, entireSelection: true);
      case BorderEdges.top:
        _applyBorders(sheetProperties, <BorderEdge>{BorderEdge.top}, entireSelection: true);
      case BorderEdges.outer:
        _applyOuterBorders(sheetProperties);
    }
  }

  void _applyHorizontalBorders(SheetProperties sheetProperties) {
    RowIndex topRow = _getTopmostRow();
    RowIndex bottomRow = _getBottommostRow();

    for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.row == topRow)) {
      _updateCellBorder(sheetProperties, cellIndex, <BorderEdge>{BorderEdge.top}, isAdding: true);
    }

    for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.row == bottomRow)) {
      _updateCellBorder(sheetProperties, cellIndex, <BorderEdge>{BorderEdge.bottom}, isAdding: true);
    }

    _applyInnerBorders(sheetProperties, horizontal: true);
  }

  void _applyVerticalBorders(SheetProperties sheetProperties) {
    ColumnIndex leftColumn = _getLeftmostColumn();
    ColumnIndex rightColumn = _getRightmostColumn();

    for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.column == leftColumn)) {
      _updateCellBorder(sheetProperties, cellIndex, <BorderEdge>{BorderEdge.left}, isAdding: true);
    }

    for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.column == rightColumn)) {
      _updateCellBorder(sheetProperties, cellIndex, <BorderEdge>{BorderEdge.right}, isAdding: true);
    }

    _applyInnerBorders(sheetProperties, vertical: true);
  }

  void _applyBorders(SheetProperties sheetProperties, Set<BorderEdge> edges, {bool entireSelection = false}) {
    if (entireSelection) {
      Set<CellIndex> cellsToUpdate = _getEdgeCells(edges);
      for (CellIndex cellIndex in cellsToUpdate) {
        _updateCellBorder(sheetProperties, cellIndex, edges, isAdding: true);
      }
    } else {
      for (CellIndex cellIndex in selectedCells) {
        _updateCellBorder(sheetProperties, cellIndex, edges, isAdding: true);
      }
    }
  }

  void _clearBorders(SheetProperties sheetProperties) {
    for (CellIndex cellIndex in selectedCells) {
      Set<BorderEdge> edges = <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left};
      _updateCellBorder(sheetProperties, cellIndex, edges, isAdding: false);
    }
  }

  void _applyInnerBorders(SheetProperties sheetProperties, {bool horizontal = false, bool vertical = false}) {
    for (CellIndex cellIndex in selectedCells) {
      Set<BorderEdge> internalEdges = _getInternalEdges(cellIndex, horizontal: horizontal, vertical: vertical);
      _updateCellBorder(sheetProperties, cellIndex, internalEdges, isAdding: true);
    }
  }

  void _applyOuterBorders(SheetProperties sheetProperties) {
    for (CellIndex cellIndex in selectedCells) {
      Set<BorderEdge> outerEdges = _getOuterEdges(cellIndex);
      if (outerEdges.isNotEmpty) {
        _updateCellBorder(sheetProperties, cellIndex, outerEdges, isAdding: true);
      }
    }
  }

  Set<BorderEdge> _getInternalEdges(CellIndex cellIndex, {bool horizontal = true, bool vertical = true}) {
    Set<BorderEdge> internalEdges = <BorderEdge>{};

    if (horizontal) {
      if (selectedCells.contains(CellIndex(row: cellIndex.row - 1, column: cellIndex.column))) {
        internalEdges.add(BorderEdge.top);
      }
      if (selectedCells.contains(CellIndex(row: cellIndex.row + 1, column: cellIndex.column))) {
        internalEdges.add(BorderEdge.bottom);
      }
    }

    if (vertical) {
      if (selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column - 1))) {
        internalEdges.add(BorderEdge.left);
      }
      if (selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column + 1))) {
        internalEdges.add(BorderEdge.right);
      }
    }

    return internalEdges;
  }

  Set<BorderEdge> _getOuterEdges(CellIndex cellIndex) {
    Set<BorderEdge> outerEdges = <BorderEdge>{};

    if (!selectedCells.contains(CellIndex(row: cellIndex.row - 1, column: cellIndex.column))) {
      outerEdges.add(BorderEdge.top);
    }
    if (!selectedCells.contains(CellIndex(row: cellIndex.row + 1, column: cellIndex.column))) {
      outerEdges.add(BorderEdge.bottom);
    }
    if (!selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column - 1))) {
      outerEdges.add(BorderEdge.left);
    }
    if (!selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column + 1))) {
      outerEdges.add(BorderEdge.right);
    }

    return outerEdges;
  }

  Set<CellIndex> _getEdgeCells(Set<BorderEdge> edges) {
    Set<CellIndex> cells = <CellIndex>{};

    if (edges.contains(BorderEdge.top)) {
      RowIndex topRow = _getTopmostRow();
      cells.addAll(selectedCells.where((CellIndex c) => c.row == topRow));
    }
    if (edges.contains(BorderEdge.bottom)) {
      RowIndex bottomRow = _getBottommostRow();
      cells.addAll(selectedCells.where((CellIndex c) => c.row == bottomRow));
    }
    if (edges.contains(BorderEdge.left)) {
      ColumnIndex leftColumn = _getLeftmostColumn();
      cells.addAll(selectedCells.where((CellIndex c) => c.column == leftColumn));
    }
    if (edges.contains(BorderEdge.right)) {
      ColumnIndex rightColumn = _getRightmostColumn();
      cells.addAll(selectedCells.where((CellIndex c) => c.column == rightColumn));
    }

    return cells;
  }

  RowIndex _getTopmostRow() => selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a < b ? a : b);

  RowIndex _getBottommostRow() => selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a > b ? a : b);

  ColumnIndex _getLeftmostColumn() =>
      selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a < b ? a : b);

  ColumnIndex _getRightmostColumn() =>
      selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a > b ? a : b);

  void _updateCellBorder(SheetProperties sheetProperties, CellIndex cellIndex, Set<BorderEdge> edges, {required bool isAdding}) {
    CellProperties cellProperties = sheetProperties.getCellProperties(cellIndex);
    Border currentBorder = cellProperties.style.border ?? const Border();

    Border newBorder = Border(
      top: edges.contains(BorderEdge.top) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.top,
      right: edges.contains(BorderEdge.right) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.right,
      bottom: edges.contains(BorderEdge.bottom) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.bottom,
      left: edges.contains(BorderEdge.left) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.left,
    );

    cellProperties.style.border = newBorder;

    for (BorderEdge edge in edges) {
      CellIndex? adjacentIndex = _getAdjacentCellIndex(sheetProperties, cellIndex, edge);
      if (adjacentIndex != null) {
        CellProperties adjacentCell = sheetProperties.getCellProperties(adjacentIndex);
        BorderEdge oppositeEdge = _getOppositeEdge(edge);
        Border adjacentBorder = adjacentCell.style.border ?? const Border();

        Border updatedAdjacentBorder = Border(
          top: oppositeEdge == BorderEdge.top ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.top,
          right: oppositeEdge == BorderEdge.right ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.right,
          bottom: oppositeEdge == BorderEdge.bottom ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.bottom,
          left: oppositeEdge == BorderEdge.left ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.left,
        );

        adjacentCell.style.border = updatedAdjacentBorder;
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

  CellIndex? _getAdjacentCellIndex(SheetProperties sheetProperties, CellIndex cellIndex, BorderEdge edge) {
    int maxRow = sheetProperties.rowCount - 1;
    int maxColumn = sheetProperties.columnCount - 1;

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

  @override
  List<Object?> get props => <Object?>[borderEdges, selectedCells, borderSide];
}

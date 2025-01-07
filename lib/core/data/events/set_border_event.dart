// import 'package:flutter/material.dart';
// import 'package:sheets/core/data/events/sheet_data_event.dart';
// import 'package:sheets/core/data/worksheet.dart';
// import 'package:sheets/core/sheet_index.dart';
// import 'package:sheets/utils/border_edge.dart';
// import 'package:sheets/utils/border_edges.dart';
//
// // Border
// class SetBorderIntent extends SheetDataEvent {
//   SetBorderIntent({
//     required this.edges,
//     required this.selectedCells,
//     required this.borderSide,
//   });
//
//   final BorderEdges edges;
//   final List<CellIndex> selectedCells;
//   final BorderSide borderSide;
//
//   void format(Worksheet worksheet) {
//     switch (edges) {
//       case BorderEdges.all:
//         _applyBorders(worksheet, <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left});
//       case BorderEdges.clear:
//         _clearBorders(worksheet);
//       case BorderEdges.inner:
//         _applyInnerBorders(worksheet, horizontal: true, vertical: true);
//       case BorderEdges.horizontal:
//         _applyHorizontalBorders(worksheet);
//       case BorderEdges.vertical:
//         _applyVerticalBorders(worksheet);
//       case BorderEdges.left:
//         _applyBorders(worksheet, <BorderEdge>{BorderEdge.left}, entireSelection: true);
//       case BorderEdges.right:
//         _applyBorders(worksheet, <BorderEdge>{BorderEdge.right}, entireSelection: true);
//       case BorderEdges.bottom:
//         _applyBorders(worksheet, <BorderEdge>{BorderEdge.bottom}, entireSelection: true);
//       case BorderEdges.top:
//         _applyBorders(worksheet, <BorderEdge>{BorderEdge.top}, entireSelection: true);
//       case BorderEdges.outer:
//         _applyOuterBorders(worksheet);
//     }
//   }
//
//   void _applyHorizontalBorders(Worksheet worksheet) {
//     RowIndex topRow = _getTopmostRow();
//     RowIndex bottomRow = _getBottommostRow();
//
//     for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.row == topRow)) {
//       _updateCellBorder(worksheet, cellIndex, <BorderEdge>{BorderEdge.top}, isAdding: true);
//     }
//
//     for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.row == bottomRow)) {
//       _updateCellBorder(worksheet, cellIndex, <BorderEdge>{BorderEdge.bottom}, isAdding: true);
//     }
//
//     _applyInnerBorders(worksheet, horizontal: true);
//   }
//
//   void _applyVerticalBorders(Worksheet worksheet) {
//     ColumnIndex leftColumn = _getLeftmostColumn();
//     ColumnIndex rightColumn = _getRightmostColumn();
//
//     for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.column == leftColumn)) {
//       _updateCellBorder(worksheet, cellIndex, <BorderEdge>{BorderEdge.left}, isAdding: true);
//     }
//
//     for (CellIndex cellIndex in selectedCells.where((CellIndex c) => c.column == rightColumn)) {
//       _updateCellBorder(worksheet, cellIndex, <BorderEdge>{BorderEdge.right}, isAdding: true);
//     }
//
//     _applyInnerBorders(worksheet, vertical: true);
//   }
//
//   void _applyBorders(Worksheet worksheet, Set<BorderEdge> edges, {bool entireSelection = false}) {
//     if (entireSelection) {
//       Set<CellIndex> cellsToUpdate = _getEdgeCells(edges);
//       for (CellIndex cellIndex in cellsToUpdate) {
//         _updateCellBorder(worksheet, cellIndex, edges, isAdding: true);
//       }
//     } else {
//       for (CellIndex cellIndex in selectedCells) {
//         _updateCellBorder(worksheet, cellIndex, edges, isAdding: true);
//       }
//     }
//   }
//
//   void _clearBorders(Worksheet worksheet) {
//     for (CellIndex cellIndex in selectedCells) {
//       Set<BorderEdge> edges = <BorderEdge>{BorderEdge.top, BorderEdge.right, BorderEdge.bottom, BorderEdge.left};
//       _clearCellBorder(worksheet, cellIndex, edges, isAdding: false);
//     }
//   }
//
//   void _applyInnerBorders(Worksheet worksheet, {bool horizontal = false, bool vertical = false}) {
//     for (CellIndex cellIndex in selectedCells) {
//       Set<BorderEdge> internalEdges = _getInternalEdges(cellIndex, horizontal: horizontal, vertical: vertical);
//       _updateCellBorder(worksheet, cellIndex, internalEdges, isAdding: true);
//     }
//   }
//
//   void _applyOuterBorders(Worksheet worksheet) {
//     for (CellIndex cellIndex in selectedCells) {
//       Set<BorderEdge> outerEdges = _getOuterEdges(cellIndex);
//       if (outerEdges.isNotEmpty) {
//         _updateCellBorder(worksheet, cellIndex, outerEdges, isAdding: true);
//       }
//     }
//   }
//
//   Set<BorderEdge> _getInternalEdges(CellIndex cellIndex, {bool horizontal = true, bool vertical = true}) {
//     Set<BorderEdge> internalEdges = <BorderEdge>{};
//
//     if (horizontal) {
//       if (selectedCells.contains(CellIndex(row: cellIndex.row - 1, column: cellIndex.column))) {
//         internalEdges.add(BorderEdge.top);
//       }
//       if (selectedCells.contains(CellIndex(row: cellIndex.row + 1, column: cellIndex.column))) {
//         internalEdges.add(BorderEdge.bottom);
//       }
//     }
//
//     if (vertical) {
//       if (selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column - 1))) {
//         internalEdges.add(BorderEdge.left);
//       }
//       if (selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column + 1))) {
//         internalEdges.add(BorderEdge.right);
//       }
//     }
//
//     return internalEdges;
//   }
//
//   Set<BorderEdge> _getOuterEdges(CellIndex cellIndex) {
//     Set<BorderEdge> outerEdges = <BorderEdge>{};
//
//     if (!selectedCells.contains(CellIndex(row: cellIndex.row - 1, column: cellIndex.column))) {
//       outerEdges.add(BorderEdge.top);
//     }
//     if (!selectedCells.contains(CellIndex(row: cellIndex.row + 1, column: cellIndex.column))) {
//       outerEdges.add(BorderEdge.bottom);
//     }
//     if (!selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column - 1))) {
//       outerEdges.add(BorderEdge.left);
//     }
//     if (!selectedCells.contains(CellIndex(row: cellIndex.row, column: cellIndex.column + 1))) {
//       outerEdges.add(BorderEdge.right);
//     }
//
//     return outerEdges;
//   }
//
//   Set<CellIndex> _getEdgeCells(Set<BorderEdge> edges) {
//     Set<CellIndex> cells = <CellIndex>{};
//
//     if (edges.contains(BorderEdge.top)) {
//       RowIndex topRow = _getTopmostRow();
//       cells.addAll(selectedCells.where((CellIndex c) => c.row == topRow));
//     }
//     if (edges.contains(BorderEdge.bottom)) {
//       RowIndex bottomRow = _getBottommostRow();
//       cells.addAll(selectedCells.where((CellIndex c) => c.row == bottomRow));
//     }
//     if (edges.contains(BorderEdge.left)) {
//       ColumnIndex leftColumn = _getLeftmostColumn();
//       cells.addAll(selectedCells.where((CellIndex c) => c.column == leftColumn));
//     }
//     if (edges.contains(BorderEdge.right)) {
//       ColumnIndex rightColumn = _getRightmostColumn();
//       cells.addAll(selectedCells.where((CellIndex c) => c.column == rightColumn));
//     }
//
//     return cells;
//   }
//
//   RowIndex _getTopmostRow() => selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a < b ? a : b);
//
//   RowIndex _getBottommostRow() => selectedCells.map((CellIndex c) => c.row).reduce((RowIndex a, RowIndex b) => a > b ? a : b);
//
//   ColumnIndex _getLeftmostColumn() =>
//       selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a < b ? a : b);
//
//   ColumnIndex _getRightmostColumn() =>
//       selectedCells.map((CellIndex c) => c.column).reduce((ColumnIndex a, ColumnIndex b) => a > b ? a : b);
//
//   void _updateCellBorder(Worksheet worksheet, CellIndex cellIndex, Set<BorderEdge> edges, {required bool isAdding}) {
//     CellProperties cellProperties = worksheet.getCell(cellIndex);
//     Border currentBorder = cellProperties.style.border ?? const Border();
//
//     Border newBorder = Border(
//       top: edges.contains(BorderEdge.top) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.top,
//       right: edges.contains(BorderEdge.right) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.right,
//       bottom: edges.contains(BorderEdge.bottom) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.bottom,
//       left: edges.contains(BorderEdge.left) ? (isAdding ? borderSide : BorderSide.none) : currentBorder.left,
//     );
//
//     setCellStyle(worksheet, cellIndex, (CellStyle cellStyle) => cellStyle.copyWith(border: newBorder));
//   }
//
//   void _clearCellBorder(Worksheet worksheet, CellIndex cellIndex, Set<BorderEdge> edges, {required bool isAdding}) {
//     _updateCellBorder(worksheet, cellIndex, edges, isAdding: false);
//
//     for (BorderEdge edge in edges) {
//       CellIndex? adjacentIndex = _getAdjacentCellIndex(worksheet, cellIndex, edge);
//       if (adjacentIndex != null) {
//         CellProperties adjacentCell = worksheet.getCell(adjacentIndex);
//         Border adjacentBorder = adjacentCell.style.border ?? const Border();
//
//         Border updatedAdjacentBorder = Border(
//           top: edge.opposite == BorderEdge.top ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.top,
//           right: edge.opposite == BorderEdge.right ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.right,
//           bottom: edge.opposite == BorderEdge.bottom ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.bottom,
//           left: edge.opposite == BorderEdge.left ? (isAdding ? borderSide : BorderSide.none) : adjacentBorder.left,
//         );
//
//         setCellStyle(worksheet, cellIndex, (CellStyle cellStyle) => cellStyle.copyWith(border: updatedAdjacentBorder));
//       }
//     }
//   }
//
//   CellIndex? _getAdjacentCellIndex(Worksheet worksheet, CellIndex cellIndex, BorderEdge edge) {
//     int maxRow = worksheet.rows - 1;
//     int maxColumn = worksheet.cols - 1;
//
//     switch (edge) {
//       case BorderEdge.top:
//         return cellIndex.row.value > 0 ? CellIndex(row: cellIndex.row - 1, column: cellIndex.column) : null;
//       case BorderEdge.bottom:
//         return cellIndex.row.value < maxRow ? CellIndex(row: cellIndex.row + 1, column: cellIndex.column) : null;
//       case BorderEdge.left:
//         return cellIndex.column.value > 0 ? CellIndex(row: cellIndex.row, column: cellIndex.column - 1) : null;
//       case BorderEdge.right:
//         return cellIndex.column.value < maxColumn ? CellIndex(row: cellIndex.row, column: cellIndex.column + 1) : null;
//     }
//   }
// }

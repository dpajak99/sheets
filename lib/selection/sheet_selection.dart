import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/selection_status.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_viewport_delegate.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';

abstract class SheetSelection with EquatableMixin {
  final bool _completed;
  late SheetProperties sheetProperties;

  void applyProperties(SheetProperties properties) {
    sheetProperties = properties;
  }

  SheetSelection({required bool completed}) : _completed = completed;

  bool get isCompleted => _completed;

  CellIndex get start;

  CellIndex get end;

  CellIndex get trueStart {
    if (start == CellIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (start.columnIndex == ColumnIndex.max) {
      return CellIndex(rowIndex: start.rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (start.rowIndex == RowIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: start.columnIndex);
    } else {
      return start;
    }
  }

  CellIndex get trueEnd {
    if (end == CellIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (end.columnIndex == ColumnIndex.max) {
      return CellIndex(rowIndex: end.rowIndex, columnIndex: ColumnIndex(sheetProperties.columnCount - 1));
    } else if (end.rowIndex == RowIndex.max) {
      return CellIndex(rowIndex: RowIndex(sheetProperties.rowCount - 1), columnIndex: end.columnIndex);
    } else {
      return end;
    }
  }

  CellIndex get mainCell => trueStart;

  Set<CellIndex> get selectedCells;

  SelectionCellCorners? get selectionCellCorners;

  SelectionStatus isColumnSelected(ColumnIndex columnIndex);

  SelectionStatus isRowSelected(RowIndex rowIndex);

  bool containsCell(CellIndex cellIndex);

  SheetSelection complete() => this;

  String stringifySelection();

  SheetSelectionRenderer createRenderer(SheetViewportDelegate viewportDelegate);

  bool contains(CellIndex cellIndex) {
    SelectionCellCorners? corners = selectionCellCorners;
    if (corners == null) return selectedCells.contains(cellIndex);

    return corners.contains(cellIndex);
  }

  SheetSelection modifyEnd(CellIndex cellIndex, {required bool completed});

  SheetSelection append(SheetSelection appendedSelection) {
    return SheetMultiSelection(
      mergedSelections: [this, appendedSelection],
      mainCell: appendedSelection.mainCell,
    );
  }

  bool containsSelection(SheetSelection nestedSelection);

  List<SheetSelection> subtract(SheetSelection subtractedSelection);

  SheetSelection simplify() => this;
}


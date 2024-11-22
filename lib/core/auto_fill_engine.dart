import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/patterns/linear_date_pattern.dart';
import 'package:sheets/core/values/patterns/linear_duration_pattern.dart';
import 'package:sheets/core/values/patterns/linear_numeric_pattern.dart';
import 'package:sheets/core/values/patterns/linear_string_pattern.dart';
import 'package:sheets/core/values/patterns/repeat_value_pattern.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/utils/direction.dart';

class AutoFillEngine {
  AutoFillEngine(this.fillDirection, this._baseCells, this._fillCells);

  final Direction fillDirection;
  final List<IndexedCellProperties> _baseCells;
  final List<IndexedCellProperties> _fillCells;

  Future<void> resolve(SheetController controller) async {
    PatternDetector detector = PatternDetector();

    List<IndexedCellProperties> updatedCells = <IndexedCellProperties>[];
    if (fillDirection.isVertical) {
      Map<ColumnIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByColumns();
      for (MapEntry<ColumnIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
        List<IndexedCellProperties> propertiesToFill = fillDirection == Direction.top
            ? cells.value.toList().reversed.toList() //
            : cells.value.toList();

        ValuePattern pattern = detector.detectPattern(propertiesToFill);
        List<IndexedCellProperties> columnFillCells = _fillCells.whereColumn(cells.key);

        if (fillDirection == Direction.top) {
          updatedCells = pattern.apply(propertiesToFill, columnFillCells.reversed.toList());
        } else {
          updatedCells = pattern.apply(propertiesToFill, columnFillCells);
        }
      }
    } else if (fillDirection.isHorizontal) {
      Map<RowIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByRows();
      for (MapEntry<RowIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
        List<IndexedCellProperties> propertiesToFill = fillDirection == Direction.left
            ? cells.value.toList().reversed.toList() //
            : cells.value.toList();

        ValuePattern pattern = detector.detectPattern(propertiesToFill);
        List<IndexedCellProperties> rowFillCells = _fillCells.whereRow(cells.key);

        if (fillDirection == Direction.left) {
          updatedCells = pattern.apply(propertiesToFill, rowFillCells.reversed.toList());
        } else {
          updatedCells = pattern.apply(propertiesToFill, rowFillCells);
        }
      }
    }

    controller.dataManager.write((SheetData data) => data.setCellsProperties(updatedCells));
  }

  Map<ColumnIndex, Map<CellIndex, CellProperties>> groupByColumns(Map<CellIndex, CellProperties> cells) {
    Map<ColumnIndex, Map<CellIndex, CellProperties>> groupedCells = <ColumnIndex, Map<CellIndex, CellProperties>>{};
    for (MapEntry<CellIndex, CellProperties> cellEntry in cells.entries) {
      ColumnIndex columnIndex = cellEntry.key.column;
      groupedCells[columnIndex] ??= <CellIndex, CellProperties>{};
      groupedCells[columnIndex]![cellEntry.key]= cellEntry.value;
    }
    return groupedCells;
  }

  Map<RowIndex, Map<CellIndex, CellProperties>> groupByRows(Map<CellIndex, CellProperties> cells) {
    Map<RowIndex, Map<CellIndex, CellProperties>> groupedCells = <RowIndex, Map<CellIndex, CellProperties>>{};
    for (MapEntry<CellIndex, CellProperties> cellEntry in cells.entries) {
      RowIndex rowIndex = cellEntry.key.row;
      groupedCells[rowIndex] ??= <CellIndex, CellProperties>{};
      groupedCells[rowIndex]![cellEntry.key] = cellEntry.value;
    }
    return groupedCells;
  }
}

class PatternDetector {
  final List<ValuePatternMatcher> matchers = <ValuePatternMatcher>[
    LinearStringPatternMatcher(),
    LinearNumericPatternMatcher(),
    LinearDatePatternMatcher(),
    LinearDurationPatternMatcher(),
  ];

  ValuePattern detectPattern(List<IndexedCellProperties> baseCells) {
    for (ValuePatternMatcher matcher in matchers) {
      ValuePattern? pattern = matcher.detect(baseCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatValuePattern();
  }
}

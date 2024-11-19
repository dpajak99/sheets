import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
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
  final Map<CellIndex, CellProperties> _baseCells;
  final Map<CellIndex, CellProperties> _fillCells;

  Future<void> resolve(SheetController controller) async {
    PatternDetector detector = PatternDetector();

    if (fillDirection.isVertical) {
      Map<ColumnIndex, List<CellProperties>> groupedBaseCells = groupByColumns(_baseCells);
      for (MapEntry<ColumnIndex, List<CellProperties>> cells in groupedBaseCells.entries) {
        ValuePattern pattern = fillDirection == Direction.top
            ? detector.detectPattern(cells.value.reversed.toList()) //
            : detector.detectPattern(cells.value);

        List<CellProperties> columnFillCells = _fillCells.entries.where((MapEntry<CellIndex, CellProperties> cell) {
          return cell.key.column == cells.key;
        }).map((MapEntry<CellIndex, CellProperties> cell) => cell.value).toList();

        if (fillDirection == Direction.top) {
          pattern.apply(cells.value, columnFillCells.reversed.toList());
        } else {
          pattern.apply(cells.value, columnFillCells);
        }
      }
    } else if (fillDirection.isHorizontal) {
      Map<RowIndex, List<CellProperties>> groupedBaseCells = groupByRows(_baseCells);
      for (MapEntry<RowIndex, List<CellProperties>> cells in groupedBaseCells.entries) {
        ValuePattern pattern = fillDirection == Direction.left
            ? detector.detectPattern(cells.value.reversed.toList()) //
            : detector.detectPattern(cells.value);

        List<CellProperties> rowFillCells = _fillCells.entries.where((MapEntry<CellIndex, CellProperties> cell) {
          return cell.key.row == cells.key;
        }).map((MapEntry<CellIndex, CellProperties> cell) => cell.value).toList();

        if (fillDirection == Direction.left) {
          pattern.apply(cells.value, rowFillCells.reversed.toList());
        } else {
          pattern.apply(cells.value, rowFillCells);
        }
      }
    }

    controller.dataManager.write((SheetData data) => data.setCellsProperties(_fillCells));
  }

  Map<ColumnIndex, List<CellProperties>> groupByColumns(Map<CellIndex, CellProperties> cells) {
    Map<ColumnIndex, List<CellProperties>> groupedCells = <ColumnIndex, List<CellProperties>>{};
    for (MapEntry<CellIndex, CellProperties> cellEntry in cells.entries) {
      ColumnIndex columnIndex = cellEntry.key.column;
      groupedCells[columnIndex] ??= <CellProperties>[];
      groupedCells[columnIndex]!.add(cellEntry.value);
    }
    return groupedCells;
  }

  Map<RowIndex, List<CellProperties>> groupByRows(Map<CellIndex, CellProperties> cells) {
    Map<RowIndex, List<CellProperties>> groupedCells = <RowIndex, List<CellProperties>>{};
    for (MapEntry<CellIndex, CellProperties> cellEntry in cells.entries) {
      RowIndex rowIndex = cellEntry.key.row;
      groupedCells[rowIndex] ??= <CellProperties>[];
      groupedCells[rowIndex]!.add(cellEntry.value);
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

  ValuePattern detectPattern(List<CellProperties> baseCells) {
    for (ValuePatternMatcher matcher in matchers) {
      ValuePattern? pattern = matcher.detect(baseCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatValuePattern();
  }
}

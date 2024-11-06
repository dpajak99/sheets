import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/pattern.dart';
import 'package:sheets/core/values/pattern_matcher.dart';
import 'package:sheets/core/values/patterns/date_sequence_pattern.dart';
import 'package:sheets/core/values/patterns/linear_numeric_pattern.dart';
import 'package:sheets/core/values/patterns/linear_string_pattern.dart';
import 'package:sheets/utils/direction.dart';

class AutoFillEngine {
  AutoFillEngine(this.fillDirection, this._baseCells, this._fillCells);

  final Direction fillDirection;
  final List<CellProperties> _baseCells;
  final List<CellProperties> _fillCells;

  Future<void> resolve(SheetController controller) async {
    PatternDetector detector = PatternDetector();

    if (fillDirection == Direction.top || fillDirection == Direction.bottom) {
      Map<ColumnIndex, List<CellProperties>> groupedBaseCells = groupByColumns(_baseCells);
      for (MapEntry<ColumnIndex, List<CellProperties>> cells in groupedBaseCells.entries) {
        ValuePattern pattern = fillDirection == Direction.top
            ? detector.detectPattern(cells.value.reversed.toList()) //
            : detector.detectPattern(cells.value);

        List<CellProperties> columnFillCells = _fillCells.where((CellProperties cell) => cell.index.column == cells.key).toList();
        if (fillDirection == Direction.top) {
          pattern.apply(cells.value, columnFillCells.reversed.toList());
        } else {
          pattern.apply(cells.value, columnFillCells);
        }
      }
    } else {
      Map<RowIndex, List<CellProperties>> groupedBaseCells = groupByRows(_baseCells);
      for (MapEntry<RowIndex, List<CellProperties>> cells in groupedBaseCells.entries) {
        ValuePattern pattern = fillDirection == Direction.left
            ? detector.detectPattern(cells.value.reversed.toList()) //
            : detector.detectPattern(cells.value);

        List<CellProperties> rowFillCells = _fillCells.where((CellProperties cell) => cell.index.row == cells.key).toList();
        if (fillDirection == Direction.left) {
          pattern.apply(cells.value, rowFillCells.reversed.toList());
        } else {
          pattern.apply(cells.value, rowFillCells);
        }
      }
    }

    controller.properties.setCellsProperties(_fillCells);
  }

  Map<ColumnIndex, List<CellProperties>> groupByColumns(List<CellProperties> cells) {
    Map<ColumnIndex, List<CellProperties>> groupedCells = <ColumnIndex, List<CellProperties>>{};
    for (CellProperties cell in cells) {
      ColumnIndex columnIndex = cell.index.column;
      if (!groupedCells.containsKey(columnIndex)) {
        groupedCells[columnIndex] = <CellProperties>[];
      }
      groupedCells[columnIndex]!.add(cell);
    }
    return groupedCells;
  }

  Map<RowIndex, List<CellProperties>> groupByRows(List<CellProperties> cells) {
    Map<RowIndex, List<CellProperties>> groupedCells = <RowIndex, List<CellProperties>>{};
    for (CellProperties cell in cells) {
      RowIndex rowIndex = cell.index.row;
      if (!groupedCells.containsKey(rowIndex)) {
        groupedCells[rowIndex] = <CellProperties>[];
      }
      groupedCells[rowIndex]!.add(cell);
    }
    return groupedCells;
  }
}

class PatternDetector {
  final List<PatternMatcher> matchers = <PatternMatcher>[
    LinearStringPatternMatcher(),
    LinearNumericPatternMatcher(),
    DateSequencePatternMatcher(),
    // DurationSequencePatternMatcher(),
    // Add more matchers here
  ];

  ValuePattern detectPattern(List<CellProperties> baseCells) {
    for (PatternMatcher matcher in matchers) {
      ValuePattern? pattern = matcher.detect(baseCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatPattern();
  }
}

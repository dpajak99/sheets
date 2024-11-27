import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/patterns/linear_date_pattern.dart';
import 'package:sheets/core/values/patterns/linear_duration_pattern.dart';
import 'package:sheets/core/values/patterns/linear_numeric_pattern.dart';
import 'package:sheets/core/values/patterns/linear_string_pattern.dart';
import 'package:sheets/core/values/patterns/repeat_value_pattern.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/utils/direction.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

class AutoFillEngine {
  AutoFillEngine(this.data, this.fillDirection, this._baseCells, this._fillCells);

  final SheetData data;
  final Direction fillDirection;
  final List<IndexedCellProperties> _baseCells;
  final List<IndexedCellProperties> _fillCells;

  void resolve() {
    if (fillDirection.isVertical) {
       _fillCellsVertical();
    } else {
       _fillCellsHorizontal();
    }
  }

  void _fillCellsVertical() {
    Map<ColumnIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByColumns();
    for (MapEntry<ColumnIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
      print('Fill cells for column: ${cells.key.value}');
      bool reversed = fillDirection == Direction.top;
      List<IndexedCellProperties> patternCells = cells.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = _fillCells.whereColumn(cells.key).maybeReverse(reversed);

      ValuePattern pattern = _detectPattern(patternCells);
      pattern.apply(fillDirection, data, patternCells, fillCells);
    }
  }

  void _fillCellsHorizontal() {
    Map<RowIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByRows();
    for (MapEntry<RowIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
      bool reversed = fillDirection == Direction.left;
      List<IndexedCellProperties> patternCells = cells.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = _fillCells.whereRow(cells.key).maybeReverse(reversed);

      ValuePattern pattern = _detectPattern(patternCells);
      pattern.apply(fillDirection, data, patternCells, fillCells);
    }
  }

  ValuePattern _detectPattern(List<IndexedCellProperties> cells) {
    PatternDetector detector = PatternDetector();

    List<IndexedCellProperties> propertiesToFill = fillDirection == Direction.top
        ? cells.toList().reversed.toList() //
        : cells.toList();

    ValuePattern pattern = detector.detectPattern(propertiesToFill);
    return pattern;
  }
}

class PatternDetector {
  final List<ValuePatternMatcher> matchers = <ValuePatternMatcher>[
    LinearNumericPatternMatcher(),
    LinearDatePatternMatcher(),
    LinearDurationPatternMatcher(),
    LinearStringPatternMatcher(),
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

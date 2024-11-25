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
    if (fillDirection.isVertical) {
      List<IndexedCellProperties> filledCells = _getVerticallyFilledCells();
      controller.dataManager.write((SheetData data) => data.setCellsProperties(filledCells));
    } else if (fillDirection.isHorizontal) {
      List<IndexedCellProperties> filledCells = _getHorizontallyFilledCells();
      controller.dataManager.write((SheetData data) => data.setCellsProperties(filledCells));
    }
  }

  List<IndexedCellProperties> _getVerticallyFilledCells() {
    List<IndexedCellProperties> filledCells = <IndexedCellProperties>[];

    Map<ColumnIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByColumns();
    for (MapEntry<ColumnIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
      bool reversed = fillDirection == Direction.top;
      List<IndexedCellProperties> patternCells = cells.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = _fillCells.whereColumn(cells.key).maybeReverse(reversed);

      ValuePattern pattern = _detectPattern(patternCells);
      filledCells.addAll(pattern.apply(patternCells, fillCells));
    }
    return filledCells;
  }

  List<IndexedCellProperties> _getHorizontallyFilledCells() {
    List<IndexedCellProperties> filledCells = <IndexedCellProperties>[];

    Map<RowIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByRows();
    for (MapEntry<RowIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
      bool reversed = fillDirection == Direction.left;
      List<IndexedCellProperties> patternCells = cells.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = _fillCells.whereRow(cells.key).maybeReverse(reversed);

      ValuePattern pattern = _detectPattern(patternCells);
      filledCells.addAll(pattern.apply(patternCells, fillCells));
    }
    return filledCells;
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

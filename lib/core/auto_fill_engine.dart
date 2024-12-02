import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data.dart';
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
    bool reversed = fillDirection == Direction.top;
    CellsMergePattern cellMergePattern = CellsMergePattern(
      fillDirection: fillDirection,
      data: data,
      reversed: reversed,
      rangeStart: _baseCells.first.startIndex,
      rangeEnd: _baseCells.last.endIndex,
    );
    Map<ColumnIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByColumns();

    for (MapEntry<ColumnIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
      List<IndexedCellProperties> patternCells = cells.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = _fillCells.whereColumn(cells.key).maybeReverse(reversed);

      cellMergePattern.apply(patternCells, fillCells);
    }

    // ValuePattern<dynamic, dynamic> pattern = _detectPattern(patternCells);
    // pattern.apply(data, patternCells, fillCells);
  }

  void _fillCellsHorizontal() {
    bool reversed = fillDirection == Direction.left;
    CellsMergePattern stylePattern = CellsMergePattern(
      fillDirection: fillDirection,
      data: data,
      reversed: reversed,
      rangeStart: _baseCells.first.startIndex,
      rangeEnd: _baseCells.last.endIndex,
    );
    Map<RowIndex, List<IndexedCellProperties>> groupedBaseCells = _baseCells.groupByRows();

    for (MapEntry<RowIndex, List<IndexedCellProperties>> cells in groupedBaseCells.entries) {
      List<IndexedCellProperties> patternCells = cells.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = _fillCells.whereRow(cells.key).maybeReverse(reversed);

      stylePattern.apply(patternCells, fillCells);
    }

    // ValuePattern<dynamic, dynamic> pattern = _detectPattern(patternCells);
    // pattern.apply(data, patternCells, fillCells);
  }

  ValuePattern<dynamic, dynamic> _detectPattern(List<IndexedCellProperties> cells) {
    PatternDetector detector = PatternDetector();

    List<IndexedCellProperties> propertiesToFill = fillDirection == Direction.top
        ? cells.toList().reversed.toList() //
        : cells.toList();

    ValuePattern<dynamic, dynamic> pattern = detector.detectPattern(propertiesToFill);
    return pattern;
  }

}

class CellsMergePattern {
  CellsMergePattern({
    required this.fillDirection,
    required this.data,
    required this.reversed,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final CellIndex rangeStart;
  final CellIndex rangeEnd;
  final Direction fillDirection;
  final SheetData data;
  final bool reversed;

  List<CellIndex> completedCells = <CellIndex>[];

  void apply(List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    int templateIndex = 0;
    List<IndexedCellProperties> unprocessedFillCells = List<IndexedCellProperties>.from(fillCells);

    while (unprocessedFillCells.isNotEmpty) {
      IndexedCellProperties templateProperties = baseCells[templateIndex % baseCells.length];
      IndexedCellProperties fillProperties = unprocessedFillCells.removeAt(0);

      CellMergeStatus templateMergeStatus = templateProperties.properties.mergeStatus;
      if (templateMergeStatus is! MergedCell) {
        templateIndex++;
        continue;
      }

      if (completedCells.contains(fillProperties.index)) {
        continue;
      }

      int dxDiff = fillProperties.index.column.value - templateProperties.index.column.value;
      int dyDiff = fillProperties.index.row.value - templateProperties.index.row.value;

      if(reversed) {
        dxDiff -= fillDirection.isHorizontal ? templateMergeStatus.width : 0;
        dyDiff -= fillDirection.isVertical ? templateMergeStatus.height : 0;
      }

      MergedCell newMergeStatus = templateMergeStatus.move(dx: dxDiff, dy: dyDiff);

      bool withinBaseRange = newMergeStatus.contains(rangeStart) || newMergeStatus.contains(rangeEnd);
      if (withinBaseRange) {
        continue;
      }

      for (CellIndex index in newMergeStatus.mergedCells) {
        unprocessedFillCells.removeWhere((IndexedCellProperties cell) => cell.index == index);
      }

      data.mergeCells(newMergeStatus.mergedCells);
      completedCells.addAll(newMergeStatus.mergedCells);
      templateIndex++;
    }
  }
}

class PatternDetector {
  final List<ValuePatternMatcher> matchers = <ValuePatternMatcher>[
    LinearNumericPatternMatcher(),
    LinearDatePatternMatcher(),
    LinearDurationPatternMatcher(),
    LinearStringPatternMatcher(),
  ];

  ValuePattern<dynamic, dynamic> detectPattern(List<IndexedCellProperties> baseCells) {
    for (ValuePatternMatcher matcher in matchers) {
      ValuePattern<dynamic, dynamic>? pattern = matcher.detect(baseCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatValuePattern();
  }
}

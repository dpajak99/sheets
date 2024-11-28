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
import 'package:sheets/utils/extensions/cell_index_extensions.dart';

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

    print('Base cells: ${_baseCells.map((e) => '${e.index.runtimeType}-${e.index}').toList()}');

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

    Map<String, Set<IndexedCellProperties>> templateRanges = <String, Set<IndexedCellProperties>>{};
    Map<String, List<IndexedCellProperties>> fillRanges = <String, List<IndexedCellProperties>>{};

    while (unprocessedFillCells.isNotEmpty) {
      IndexedCellProperties template = baseCells[templateIndex % baseCells.length];
      IndexedCellProperties target = unprocessedFillCells.removeAt(0);

      CellMergeStatus templateMergeStatus = template.properties.mergeStatus;
      if (templateMergeStatus is! MergedCell) {
        templateRanges.putIfAbsent('1x1', () => <IndexedCellProperties>{}).add(template);
        fillRanges.putIfAbsent('1x1', () => <IndexedCellProperties>[]).add(target);
        templateIndex++;
        continue;
      }

      if (completedCells.contains(target.index)) {
        continue;
      }

      int dxDiff = target.index.column.value - template.index.column.value;
      int dyDiff = target.index.row.value - template.index.row.value;

      MergedCell movedMergeStatus = fillDirection.isHorizontal
          ? templateMergeStatus.moveHorizontal(dx: dxDiff, reverse: reversed) //
          : templateMergeStatus.moveVertical(dy: dyDiff, reverse: reversed);

      bool withinBaseRange = movedMergeStatus.contains(rangeStart) || movedMergeStatus.contains(rangeEnd);
      if (withinBaseRange) {
        continue;
      }

      for (CellIndex index in movedMergeStatus.mergedCells) {
        unprocessedFillCells.removeWhere((IndexedCellProperties cell) => cell.index == index);
      }

      data.mergeCells(movedMergeStatus.mergedCells);
      completedCells.addAll(movedMergeStatus.mergedCells);
      templateIndex++;

      templateRanges.putIfAbsent(movedMergeStatus.id, () => <IndexedCellProperties>{}).add(template);
      fillRanges.putIfAbsent(movedMergeStatus.id, () => <IndexedCellProperties>[]).add(IndexedCellProperties(index: movedMergeStatus.start, properties: data.getCellProperties(movedMergeStatus.start)));
    }

    for(MapEntry<String, List<IndexedCellProperties>> fillRange in fillRanges.entries) {
      List<IndexedCellProperties> patternCells = templateRanges[fillRange.key]!.toList();
      ValuePattern<dynamic, dynamic> pattern = _detectPattern(patternCells);
      pattern.apply(data, patternCells, fillRange.value);
    }
  }

  ValuePattern<dynamic, dynamic> _detectPattern(List<IndexedCellProperties> cells) {
    PatternDetector detector = PatternDetector();

    List<IndexedCellProperties> propertiesToFill = reversed
        ? cells.toList().reversed.toList() //
        : cells.toList();

    ValuePattern<dynamic, dynamic> pattern = detector.detectPattern(propertiesToFill);
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

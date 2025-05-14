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
  AutoFillEngine(
    this.data,
    this.fillDirection,
    this._patternCells,
    this._cellsToFill,
  );

  final WorksheetData data;
  final Direction fillDirection;
  final List<IndexedCellProperties> _patternCells;
  final List<IndexedCellProperties> _cellsToFill;

  void resolve() {
    bool reversed = fillDirection.isReversed;
    _PatternApplier cellMergePattern = _PatternApplier(
      fillDirection: fillDirection,
      data: data,
      reversed: reversed,
      rangeStart: _patternCells.first.startIndex,
      rangeEnd: _patternCells.last.endIndex,
    );

    if (fillDirection.isVertical) {
      Map<ColumnIndex, List<IndexedCellProperties>> groupedPatternCells = _patternCells.groupByColumns();
      _fillCells(groupedPatternCells, _cellsToFill.whereColumn, cellMergePattern);
    } else {
      Map<RowIndex, List<IndexedCellProperties>> groupedPatternCells = _patternCells.groupByRows();
      _fillCells(groupedPatternCells, _cellsToFill.whereRow, cellMergePattern);
    }
  }

  void _fillCells<T>(
    Map<T, List<IndexedCellProperties>> groupedPatternCells,
    List<IndexedCellProperties> Function(T key) getFillCellsForKey,
    _PatternApplier patternApplier,
  ) {
    bool reversed = fillDirection.isReversed;

    for (MapEntry<T, List<IndexedCellProperties>> entry in groupedPatternCells.entries) {
      List<IndexedCellProperties> patternCells = entry.value.maybeReverse(reversed);
      List<IndexedCellProperties> fillCells = getFillCellsForKey(entry.key).maybeReverse(reversed);

      patternApplier.apply(patternCells, fillCells);
    }
  }
}

class _PatternApplier {
  _PatternApplier({
    required this.fillDirection,
    required this.data,
    required this.reversed,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final CellIndex rangeStart;
  final CellIndex rangeEnd;
  final Direction fillDirection;
  final WorksheetData data;
  final bool reversed;

  final Set<CellIndex> completedCells = <CellIndex>{};

  void apply(List<IndexedCellProperties> patternCells, List<IndexedCellProperties> cellsToFill) {
    int templateIndex = 0;
    List<IndexedCellProperties> unprocessedFillCells = List<IndexedCellProperties>.from(cellsToFill);

    Map<String, Set<IndexedCellProperties>> templateRanges = <String, Set<IndexedCellProperties>>{};
    Map<String, List<IndexedCellProperties>> fillRanges = <String, List<IndexedCellProperties>>{};

    while (unprocessedFillCells.isNotEmpty) {
      IndexedCellProperties baseCell = patternCells[templateIndex % patternCells.length];
      IndexedCellProperties targetCell = unprocessedFillCells.removeAt(0);
      CellMergeStatus baseMergeStatus = baseCell.properties.mergeStatus;

      if (completedCells.contains(targetCell.index)) {
        continue;
      }

      if (baseMergeStatus is! MergedCell) {
        _handleUnmergedTemplateCell(baseCell, targetCell, templateRanges, fillRanges);
        templateIndex++;
        continue;
      }

      bool success = _handleMergedTemplateCell(
        baseCell,
        targetCell,
        baseMergeStatus,
        unprocessedFillCells,
        templateRanges,
        fillRanges,
      );
      if (success) {
        templateIndex++;
      }
    }

    _applyPatterns(templateRanges, fillRanges);
  }

  void _handleUnmergedTemplateCell(
    IndexedCellProperties baseCell,
    IndexedCellProperties targetCell,
    Map<String, Set<IndexedCellProperties>> templateRanges,
    Map<String, List<IndexedCellProperties>> fillRanges,
  ) {
    const String unmergedKey = '1x1';
    templateRanges.putIfAbsent(unmergedKey, () => <IndexedCellProperties>{}).add(baseCell);
    fillRanges.putIfAbsent(unmergedKey, () => <IndexedCellProperties>[]).add(targetCell);
  }

  bool _handleMergedTemplateCell(
    IndexedCellProperties baseCell,
    IndexedCellProperties targetCell,
    MergedCell baseMergeStatus,
    List<IndexedCellProperties> unprocessedFillCells,
    Map<String, Set<IndexedCellProperties>> templateRanges,
    Map<String, List<IndexedCellProperties>> fillRanges,
  ) {
    int dxDiff = targetCell.index.column.value - baseCell.index.column.value;
    int dyDiff = targetCell.index.row.value - baseCell.index.row.value;

    MergedCell movedMergeStatus = fillDirection.isHorizontal
        ? baseMergeStatus.moveHorizontal(dx: dxDiff, reverse: reversed)
        : baseMergeStatus.moveVertical(dy: dyDiff, reverse: reversed);

    if (movedMergeStatus.contains(rangeStart) || movedMergeStatus.contains(rangeEnd)) {
      return false;
    }

    for (CellIndex index in movedMergeStatus.mergedCells) {
      unprocessedFillCells.removeWhere((IndexedCellProperties cell) => cell.index == index);
      completedCells.add(index);
    }

    data.cells.merge(movedMergeStatus.mergedCells);

    String key = movedMergeStatus.id;
    templateRanges.putIfAbsent(key, () => <IndexedCellProperties>{}).add(baseCell);
    fillRanges.putIfAbsent(key, () => <IndexedCellProperties>[]).add(
          IndexedCellProperties(
            index: movedMergeStatus.start,
            properties: data.cells.get(movedMergeStatus.start),
          ),
        );

    return true;
  }

  void _applyPatterns(
    Map<String, Set<IndexedCellProperties>> templateRanges,
    Map<String, List<IndexedCellProperties>> fillRanges,
  ) {
    for (MapEntry<String, List<IndexedCellProperties>> fillRangeEntry in fillRanges.entries) {
      String key = fillRangeEntry.key;
      List<IndexedCellProperties> patternCells = templateRanges[key]!.toList();
      ValuePattern<dynamic, dynamic> pattern = _detectPattern(patternCells);
      List<IndexedCellProperties> filledCells = pattern.apply( patternCells, fillRangeEntry.value);
      data.cells.setAll(filledCells);
    }
  }

  ValuePattern<dynamic, dynamic> _detectPattern(List<IndexedCellProperties> cells) {
    PatternDetector detector = PatternDetector();
    List<IndexedCellProperties> propertiesToFill = reversed ? cells.reversed.toList() : cells;

    return detector.detectPattern(propertiesToFill);
  }
}

class PatternDetector {
  final List<ValuePatternMatcher> matchers = <ValuePatternMatcher>[
    LinearNumericPatternMatcher(),
    LinearDatePatternMatcher(),
    LinearDurationPatternMatcher(),
    LinearStringPatternMatcher(),
  ];

  ValuePattern<dynamic, dynamic> detectPattern(List<IndexedCellProperties> patternCells) {
    for (ValuePatternMatcher matcher in matchers) {
      ValuePattern<dynamic, dynamic>? pattern = matcher.detect(patternCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatValuePattern();
  }
}

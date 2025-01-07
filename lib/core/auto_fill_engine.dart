import 'package:sheets/core/data/worksheet.dart';
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
    this.worksheet,
    this.fillDirection,
    this._patternCells,
    this._cellsToFill,
  );

  final Worksheet worksheet;
  final Direction fillDirection;
  final List<CellProperties> _patternCells;
  final List<CellProperties> _cellsToFill;

  void resolve() {
    bool reversed = fillDirection.isReversed;
    _PatternApplier cellMergePattern = _PatternApplier(
      fillDirection: fillDirection,
      worksheet: worksheet,
      reversed: reversed,
      rangeStart: _patternCells.first.startIndex,
      rangeEnd: _patternCells.last.endIndex,
    );

    if (fillDirection.isVertical) {
      Map<ColumnIndex, List<CellProperties>> groupedPatternCells = _patternCells.groupByColumns();
      _fillCells(groupedPatternCells, _cellsToFill.whereColumn, cellMergePattern);
    } else {
      Map<RowIndex, List<CellProperties>> groupedPatternCells = _patternCells.groupByRows();
      _fillCells(groupedPatternCells, _cellsToFill.whereRow, cellMergePattern);
    }
  }

  void _fillCells<T>(
    Map<T, List<CellProperties>> groupedPatternCells,
    List<CellProperties> Function(T key) getFillCellsForKey,
    _PatternApplier patternApplier,
  ) {
    bool reversed = fillDirection.isReversed;

    for (MapEntry<T, List<CellProperties>> entry in groupedPatternCells.entries) {
      List<CellProperties> patternCells = entry.value.maybeReverse(reversed);
      List<CellProperties> fillCells = getFillCellsForKey(entry.key).maybeReverse(reversed);

      patternApplier.apply(patternCells, fillCells);
    }
  }
}

class _PatternApplier {
  _PatternApplier({
    required this.fillDirection,
    required this.worksheet,
    required this.reversed,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final CellIndex rangeStart;
  final CellIndex rangeEnd;
  final Direction fillDirection;
  final Worksheet worksheet;
  final bool reversed;

  final Set<CellIndex> completedCells = <CellIndex>{};

  void apply(List<CellProperties> patternCells, List<CellProperties> cellsToFill) {
    int templateIndex = 0;
    List<CellProperties> unprocessedFillCells = List<CellProperties>.from(cellsToFill);

    Map<String, Set<CellProperties>> templateRanges = <String, Set<CellProperties>>{};
    Map<String, List<CellProperties>> fillRanges = <String, List<CellProperties>>{};

    while (unprocessedFillCells.isNotEmpty) {
      CellProperties baseCell = patternCells[templateIndex % patternCells.length];
      CellProperties targetCell = unprocessedFillCells.removeAt(0);
      CellMergeStatus baseMergeStatus = baseCell.mergeStatus;

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
    CellProperties baseCell,
    CellProperties targetCell,
    Map<String, Set<CellProperties>> templateRanges,
    Map<String, List<CellProperties>> fillRanges,
  ) {
    const String unmergedKey = '1x1';
    templateRanges.putIfAbsent(unmergedKey, () => <CellProperties>{}).add(baseCell);
    fillRanges.putIfAbsent(unmergedKey, () => <CellProperties>[]).add(targetCell);
  }

  bool _handleMergedTemplateCell(
    CellProperties baseCell,
    CellProperties targetCell,
    MergedCell baseMergeStatus,
    List<CellProperties> unprocessedFillCells,
    Map<String, Set<CellProperties>> templateRanges,
    Map<String, List<CellProperties>> fillRanges,
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
      unprocessedFillCells.removeWhere((CellProperties cell) => cell.index == index);
      completedCells.add(index);
    }

    worksheet.dispatchEvent(MergeCellsEvent(cells: movedMergeStatus.mergedCells));

    String key = movedMergeStatus.id;
    templateRanges.putIfAbsent(key, () => <CellProperties>{}).add(baseCell);
    fillRanges.putIfAbsent(key, () => <CellProperties>[]).add(worksheet.getCell(movedMergeStatus.start));

    return true;
  }

  void _applyPatterns(
    Map<String, Set<CellProperties>> templateRanges,
    Map<String, List<CellProperties>> fillRanges,
  ) {
    for (MapEntry<String, List<CellProperties>> fillRangeEntry in fillRanges.entries) {
      String key = fillRangeEntry.key;
      List<CellProperties> patternCells = templateRanges[key]!.toList();
      ValuePattern<dynamic, dynamic> pattern = _detectPattern(patternCells);
      List<CellProperties> filledCells = pattern.apply(patternCells, fillRangeEntry.value);
      worksheet.dispatchEvent(InsertCellsEvent(filledCells));
    }
  }

  ValuePattern<dynamic, dynamic> _detectPattern(List<CellProperties> cells) {
    PatternDetector detector = PatternDetector();
    List<CellProperties> propertiesToFill = reversed ? cells.reversed.toList() : cells;

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

  ValuePattern<dynamic, dynamic> detectPattern(List<CellProperties> patternCells) {
    for (ValuePatternMatcher matcher in matchers) {
      ValuePattern<dynamic, dynamic>? pattern = matcher.detect(patternCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatValuePattern();
  }
}

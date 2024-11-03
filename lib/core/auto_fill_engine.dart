import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_controller.dart';

class AutoFillEngine {
  AutoFillEngine(this._baseCells, this._fillCells);

  final List<CellProperties> _baseCells;
  final List<CellProperties> _fillCells;

  Future<void> resolve(SheetController controller) async {
    PatternDetector detector = PatternDetector();
    Pattern pattern = detector.detectPattern(_baseCells);

    pattern.apply(_baseCells, _fillCells);

    controller.properties.setCellsProperties(_fillCells);
  }
}

class PatternDetector {
  final List<PatternMatcher> matchers = <PatternMatcher>[
    LinearNumericPatternMatcher(),
    DateSequencePatternMatcher(),
    DurationSequencePatternMatcher(),
    // Add more matchers here
  ];

  Pattern detectPattern(List<CellProperties> baseCells) {
    for (PatternMatcher matcher in matchers) {
      Pattern? pattern = matcher.detect(baseCells);
      if (pattern != null) {
        return pattern;
      }
    }
    return RepeatPattern();
  }
}

abstract class PatternMatcher {
  Pattern? detect(List<CellProperties> baseCells);
}

class DurationSequencePatternMatcher implements PatternMatcher {
  @override
  Pattern? detect(List<CellProperties> baseCells) {
    if (baseCells.length < 2) {
      return null;
    }

    CellValue firstValue = baseCells[0].value;
    CellValue secondValue = baseCells[1].value;

    if (firstValue is DurationCellValue && secondValue is DurationCellValue) {
      Duration step = secondValue.value - firstValue.value;

      for (int i = 0; i < baseCells.length; i++) {
        Duration expectedDuration = firstValue.value + step * i;
        DurationCellValue currentValue = baseCells[i].value as DurationCellValue;
        if (currentValue.value != expectedDuration) {
          return null;
        }
      }
      return DurationSequencePattern(step);
    }
    return null;
  }
}

class DateSequencePatternMatcher implements PatternMatcher {
  @override
  Pattern? detect(List<CellProperties> baseCells) {
    if (baseCells.length < 2) {
      return null;
    }

    CellValue firstValue = baseCells[0].value;
    CellValue secondValue = baseCells[1].value;

    if (firstValue is DateCellValue && secondValue is DateCellValue) {
      Duration step = secondValue.value.difference(firstValue.value);

      for (int i = 0; i < baseCells.length; i++) {
        DateTime expectedDate = firstValue.value.add(step * i);
        DateCellValue currentValue = baseCells[i].value as DateCellValue;
        if (currentValue.value != expectedDate) {
          return null;
        }
      }
      return DateSequencePattern(step);
    }
    return null;
  }
}

class LinearNumericPatternMatcher implements PatternMatcher {
  @override
  Pattern? detect(List<CellProperties> baseCells) {
    if (baseCells.length < 2) {
      return null;
    }

    CellValue firstValue = baseCells[0].value;
    CellValue secondValue = baseCells[1].value;

    if (firstValue is NumericCellValue && secondValue is NumericCellValue) {
      double step = secondValue.value - firstValue.value;

      for (int i = 0; i < baseCells.length; i++) {
        double expectedValue = firstValue.value + i * step;
        NumericCellValue currentValue = baseCells[i].value as NumericCellValue;
        if (currentValue.value != expectedValue) {
          return null;
        }
      }
      return LinearNumericPattern(step);
    }
    return null;
  }
}

abstract class Pattern {
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells);
}

class DurationSequencePattern implements Pattern {
  DurationSequencePattern(this.step);

  final Duration step;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    DurationCellValue lastValue = baseCells.last.value as DurationCellValue;
    for (int i = 0; i < fillCells.length; i++) {
      Duration newDuration = lastValue.value + step * (i + 1);
      fillCells[i].value = DurationCellValue(newDuration);
    }
  }
}

class DateSequencePattern implements Pattern {
  DateSequencePattern(this.step);

  final Duration step;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    DateCellValue lastValue = baseCells.last.value as DateCellValue;
    for (int i = 0; i < fillCells.length; i++) {
      DateTime newDate = lastValue.value.add(step * (i + 1));
      fillCells[i].value = DateCellValue(newDate);
    }
  }
}

class LinearNumericPattern implements Pattern {
  LinearNumericPattern(this.step);

  final double step;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    NumericCellValue lastValue = baseCells.last.value as NumericCellValue;
    for (int i = 0; i < fillCells.length; i++) {
      double newValue = lastValue.value + (i + 1) * step;
      fillCells[i].value = NumericCellValue(newValue);
    }
  }
}

class RepeatPattern implements Pattern {
  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    int baseLength = baseCells.length;
    for (int i = 0; i < fillCells.length; i++) {
      CellValue value = baseCells[i % baseLength].value;
      fillCells[i].value = value;
    }
  }
}

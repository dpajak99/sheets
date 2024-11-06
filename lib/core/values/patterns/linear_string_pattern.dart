import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/cell_value.dart';
import 'package:sheets/core/values/pattern.dart';
import 'package:sheets/core/values/pattern_matcher.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/values/value_utils.dart';

class LinearStringPatternMatcher implements PatternMatcher {
  @override
  ValuePattern? detect(List<CellProperties> baseCells) {
    // Attempt to segment all string cell values
    List<SegmentedStringCellValue>? segmentedValues = _segmentCellValues(baseCells);
    if (segmentedValues == null || segmentedValues.isEmpty) {
      return null;
    }

    // Check if all integers are at the same position (start or end)
    HorizontalDirection expectedPosition = segmentedValues.first.integer.position;
    if (!_areIntegerPositionsConsistent(segmentedValues, expectedPosition)) {
      return null;
    }

    // Calculate steps between integers and collect text values
    List<int> steps = _calculateSteps(segmentedValues);
    if (steps.isEmpty) {
      return null;
    }

    List<String> textValues = segmentedValues
        .take(segmentedValues.length)
        .map((SegmentedStringCellValue segmentedValue) => segmentedValue.text)
        .toList();

    // Get the last integer value
    int lastIntegerValue = int.parse(segmentedValues.last.integer.value);

    return LinearStringPattern(
      expectedPosition,
      lastIntegerValue,
      steps,
      textValues,
    );
  }

  List<SegmentedStringCellValue>? _segmentCellValues(List<CellProperties> baseCells) {
    List<SegmentedStringCellValue> segmentedValues = <SegmentedStringCellValue>[];

    for (CellProperties cell in baseCells) {
      CellValue cellValue = cell.value;
      if (cellValue is! StringCellValue) {
        return null;
      }

      SegmentedStringCellValue? segmentedValue = ValueUtils.getSegmentedStringCellValue(cellValue.rawText);
      if (segmentedValue == null) {
        return null;
      }

      segmentedValues.add(segmentedValue);
    }

    return segmentedValues;
  }

  bool _areIntegerPositionsConsistent(
    List<SegmentedStringCellValue> segmentedValues,
    HorizontalDirection expectedPosition,
  ) {
    return segmentedValues.every(
      (SegmentedStringCellValue segmentedValue) => segmentedValue.integer.position == expectedPosition,
    );
  }

  List<int> _calculateSteps(List<SegmentedStringCellValue> segmentedValues) {
    List<int> steps = <int>[];

    for (int i = 0; i < segmentedValues.length - 1; i++) {
      int currentInt = int.parse(segmentedValues[i].integer.value);
      int nextInt = int.parse(segmentedValues[i + 1].integer.value);
      steps.add(nextInt - currentInt);
    }

    while (steps.isNotEmpty && steps.first == 0) {
      steps.removeAt(0);
    }

    if (steps.isEmpty) {
      return <int>[1];
    } else {
      return steps;
    }
  }
}

class LinearStringPattern implements ValuePattern {
  LinearStringPattern(this.direction, this.lastIntegerValue, this.steps, this.values);

  final HorizontalDirection direction;
  final int lastIntegerValue;
  final List<int> steps;
  final List<String> values;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    int lastIntegerValue = this.lastIntegerValue;

    for (int i = 0; i < fillCells.length; i++) {
      int step = steps[i % steps.length];
      String value = values[i % values.length];
      int newIntegerValue = lastIntegerValue + step;
      lastIntegerValue = newIntegerValue;

      String newTextValue;
      if (direction == HorizontalDirection.left) {
        newTextValue = '${newIntegerValue.abs()}$value';
      } else {
        newTextValue = '$value${newIntegerValue.abs()}';
      }

      MainSheetTextSpan templateSpan = baseCells[i % baseCells.length].value.span;
      MainSheetTextSpan newSpan = templateSpan.withText(newTextValue);
      fillCells[i].value = StringCellValue(newSpan);
    }
  }
}

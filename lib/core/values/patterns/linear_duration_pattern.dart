import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearDurationPatternMatcher implements ValuePatternMatcher {
  @override
  ValuePattern? detect(List<IndexedCellProperties> values) {
    try {
      List<Duration> durationValues = _parseDurationValues(values);
      List<Duration> steps = _calculateSteps(durationValues);
      if (steps.isEmpty) {
        return null;
      }

      Duration lastDuration = durationValues.last;
      return DurationSequencePattern(steps, lastDuration);
    } catch (e) {
      return null;
    }
  }

  List<Duration> _parseDurationValues(List<IndexedCellProperties> values) {
    return values.map((IndexedCellProperties cell) {
      SheetValueFormat format = cell.properties.visibleValueFormat;
      if (format is SheetDurationFormat) {
        return format.toDuration(cell.properties.value.toPlainText());
      } else {
        throw ArgumentError('Invalid format: $format');
      }
    }).toList();
  }

  List<Duration> _calculateSteps(List<Duration> values) {
    List<Duration> steps = <Duration>[];

    for (int i = 0; i < values.length - 1; i++) {
      Duration currentDuration = values[i];
      Duration nextDuration = values[i + 1];
      steps.add(nextDuration - currentDuration);
    }

    while (steps.isNotEmpty && steps.first == Duration.zero) {
      steps.removeAt(0);
    }

    if (steps.isEmpty) {
      return <Duration>[const Duration(days: 1)];
    } else {
      return steps;
    }
  }
}

class DurationSequencePattern implements ValuePattern {
  DurationSequencePattern(this.steps, this.lastDuration);

  final List<Duration> steps;
  final Duration lastDuration;

  @override
  List<IndexedCellProperties> apply(List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    Duration lastDuration = this.lastDuration;

    for (int i = 0; i < fillCells.length; i++) {
      IndexedCellProperties templateProperties = baseCells[i];
      IndexedCellProperties fillProperties = fillCells[i];

      Duration step = steps[i % steps.length];
      Duration newDurationValue = lastDuration + step;
      lastDuration = newDurationValue;

      SheetRichText previousRichText = templateProperties.properties.value;
      SheetRichText updatedRichText = previousRichText.withText(newDurationValue.toString());

      fillCells[i] = fillProperties.copyWith(
        properties: fillProperties.properties.copyWith(
          value: updatedRichText,
          style: templateProperties.properties.style,
        ),
      );
    }

    return fillCells;
  }
}

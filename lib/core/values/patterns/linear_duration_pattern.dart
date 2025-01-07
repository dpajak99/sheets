import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearDurationPatternMatcher implements ValuePatternMatcher {
  @override
  DurationSequencePattern? detect(List<CellProperties> values) {
    try {
      List<Duration> durationValues = _parseDurationValues(values);
      List<Duration> steps = _calculateSteps(durationValues);
      if (steps.isEmpty) {
        return null;
      }

      Duration lastDuration = durationValues.last;
      return DurationSequencePattern(steps: steps, lastDuration: lastDuration);
    } catch (e) {
      return null;
    }
  }

  List<Duration> _parseDurationValues(List<CellProperties> values) {
    return values.map((CellProperties cell) {
      SheetValueFormat format = cell.visibleValueFormat;
      if (format is SheetDurationFormat) {
        return format.toDuration(cell.value.toPlainText());
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

class DurationSequencePattern extends ValuePattern<Duration, Duration> {
  DurationSequencePattern({
    required super.steps,
    required Duration lastDuration,
  }) : super(lastValue: lastDuration);

  @override
  Duration calculateNewValue(int index, CellProperties templateProperties, Duration lastValue, Duration? step) {
    return lastValue + step!;
  }

  @override
  SheetRichText formatValue(SheetRichText previousRichText, Duration value) {
    return previousRichText.withText(value.toString());
  }

  @override
  void updateState(Duration newValue) {
    lastValue = newValue;
  }
}

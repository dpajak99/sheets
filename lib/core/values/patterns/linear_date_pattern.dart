import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/direction.dart';

class LinearDatePatternMatcher implements ValuePatternMatcher {
  @override
  ValuePattern? detect(List<IndexedCellProperties> values) {
    try {
      List<DateTime> dateValues = _parseDateValues(values);
      List<Duration> steps = _calculateSteps(dateValues);
      if (steps.isEmpty) {
        return null;
      }

      DateTime lastDate = dateValues.last;
      return DateSequencePattern(steps: steps, lastDate: lastDate);
    } catch (e) {
      return null;
    }
  }

  List<DateTime> _parseDateValues(List<IndexedCellProperties> values) {
    return values.map((IndexedCellProperties cell) {
      SheetValueFormat format = cell.properties.visibleValueFormat;
      if (format is SheetDateFormat) {
        return format.toDate(cell.properties.value.toPlainText());
      } else {
        throw ArgumentError('Invalid format: $format');
      }
    }).toList();
  }

  List<Duration> _calculateSteps(List<DateTime> values) {
    List<Duration> steps = <Duration>[];

    for (int i = 0; i < values.length - 1; i++) {
      DateTime currentDate = values[i];
      DateTime nextDate = values[i + 1];
      steps.add(nextDate.difference(currentDate));
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

class DateSequencePattern extends ValuePattern<DateTime, Duration> {
  DateSequencePattern({
    required super.steps,
    required DateTime lastDate,
  }) : super(lastValue: lastDate);

  @override
  DateTime calculateNewValue(int index, CellProperties templateProperties, DateTime lastValue, Duration? step) {
    return lastValue.add(step!);
  }

  @override
  SheetRichText formatValue(SheetRichText previousRichText, DateTime value) {
    return previousRichText.withText(value.toString());
  }

  @override
  void updateState(DateTime newValue) {
    lastValue = newValue;
  }
}

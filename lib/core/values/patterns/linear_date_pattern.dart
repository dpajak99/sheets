import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearDatePatternMatcher implements ValuePatternMatcher {
  @override
  ValuePattern? detect(List<CellProperties> values) {
    try {
      List<DateTime> dateValues = _parseDateValues(values);
      List<Duration> steps = _calculateSteps(dateValues);
      if (steps.isEmpty) {
        return null;
      }

      DateTime lastDate = dateValues.last;
      return DateSequencePattern(steps, lastDate);
    } catch (e) {
      return null;
    }
  }

  List<DateTime> _parseDateValues(List<CellProperties> values) {
    return values.map((CellProperties cell) {
      SheetValueFormat format = cell.visibleValueFormat;
      if (format is SheetDateFormat) {
        return format.toDate(cell.value.toPlainText());
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

class DateSequencePattern implements ValuePattern {
  DateSequencePattern(this.steps, this.lastDate);

  final List<Duration> steps;
  final DateTime lastDate;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    DateTime lastDate = this.lastDate;

    for (int i = 0; i < fillCells.length; i++) {
      Duration step = steps[i % steps.length];
      DateTime newDateTimeValue = lastDate.add(step);
      lastDate = newDateTimeValue;

      SheetRichText previousRichText = baseCells[i % baseCells.length].value;
      SheetRichText updatedRichText = previousRichText.withText(newDateTimeValue.toString());

      CellProperties cellProperties = fillCells[i];
      fillCells[i] = cellProperties.copyWith(
        value: updatedRichText,
        style: baseCells[i % steps.length].style,
      );
    }
  }
}

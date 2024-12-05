import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearNumericPatternMatcher implements ValuePatternMatcher {
  @override
  LinearNumericPattern? detect(List<IndexedCellProperties> values) {
    try {
      List<num> numericValues = _parseNumericValues(values);
      List<num> steps = _calculateSteps(numericValues);

      if (steps.isEmpty) {
        return null;
      }
      num lastNumValue = numericValues.last;

      List<String> numParts = lastNumValue.toString().split('.');
      bool hasFloat = !numParts[1].split('').every((String char) => char == '0');
      int precision = hasFloat ? numParts[1].length : 0;
      return LinearNumericPattern(steps: steps, lastNumValue: lastNumValue, precision: precision);
    } catch (e) {
      return null;
    }
  }
  List<num> _parseNumericValues(List<IndexedCellProperties> values) {
    return values.map((IndexedCellProperties cell) {
      SheetValueFormat format = cell.properties.visibleValueFormat;
      if (format is SheetNumberFormat) {
        return format.toNumber(cell.properties.value.toPlainText());
      } else {
        throw ArgumentError('Invalid format: $format');
      }
    }).toList();
  }

  List<num> _calculateSteps(List<num> values) {
    List<num> steps = <num>[];

    for (int i = 0; i < values.length - 1; i++) {
      num currentNum = values[i];
      num nextNum = values[i + 1];
      steps.add(nextNum - currentNum);
    }

    while (steps.isNotEmpty && steps.first == 0) {
      steps.removeAt(0);
    }

    if (steps.isEmpty) {
      return <num>[1];
    } else {
      return steps;
    }
  }
}

class LinearNumericPattern extends ValuePattern<num, num> {
  LinearNumericPattern({
    required super.steps,
    required num lastNumValue,
    required this.precision,
  }) : super(lastValue: lastNumValue);

  final int precision;

  @override
  num calculateNewValue(int index, CellProperties templateProperties, num lastValue, num? step) {
    num newValue = lastValue + step!;
    return double.parse(newValue.toStringAsFixed(precision));
  }

  @override
  SheetRichText formatValue(SheetRichText previousRichText, num value) {
    return previousRichText.withText(value.toStringAsFixed(precision));
  }

  @override
  void updateState(num newValue) {
    lastValue = newValue;
  }
}

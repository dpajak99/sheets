import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearNumericPatternMatcher implements ValuePatternMatcher {
  @override
  ValuePattern? detect(List<CellProperties> values) {
    try {
      List<num> numericValues = _parseNumericValues(values);
      List<num> steps = _calculateSteps(numericValues);
      if (steps.isEmpty) {
        return null;
      }

      num lastNumValue = numericValues.last;

      int precision = numericValues.fold(0, (int maxPrecision, num value) {
        int precision = value.toString().split('.').last.length;
        return precision > maxPrecision ? precision : maxPrecision;
      });

      return LinearNumericPattern(steps, lastNumValue, precision);
    } catch (e) {
      return null;
    }
  }

  List<num> _parseNumericValues(List<CellProperties> values) {
    return values.map((CellProperties cell) {
      SheetValueFormat format = cell.visibleValueFormat;
      if (format is SheetNumberFormat) {
        return format.toNumber(cell.value.toPlainText());
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

class LinearNumericPattern implements ValuePattern {
  LinearNumericPattern(this.steps, this.lastNumValue, this.precision);

  final List<num> steps;
  final num lastNumValue;
  final int precision;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    num lastNumValue = this.lastNumValue;

    for (int i = 0; i < fillCells.length; i++) {
      num step = steps[i % steps.length];
      num newNumValue = lastNumValue + step;
      newNumValue = double.parse(newNumValue.toStringAsFixed(precision));
      lastNumValue = newNumValue;

      SheetRichText previousRichText = baseCells[i % baseCells.length].value;
      SheetRichText updatedRichText = previousRichText.withText(newNumValue.toString());
      fillCells[i].value = updatedRichText;
      fillCells[i].style = baseCells[i % steps.length].style;
    }
  }
}

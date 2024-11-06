import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/cell_value.dart';
import 'package:sheets/core/values/pattern.dart';
import 'package:sheets/core/values/pattern_matcher.dart';

class LinearNumericPatternMatcher implements PatternMatcher {
  @override
  ValuePattern? detect(List<CellProperties> baseCells) {
    bool allNumeric = baseCells.every((CellProperties cell) => cell.value is NumericCellValue);
    if (!allNumeric) {
      return null;
    }

    List<double> baseValues = baseCells.map((CellProperties cell) => (cell.value as NumericCellValue).value).toList();
    List<double> steps = _calculateSteps(baseValues);
    if (steps.isEmpty) {
      return null;
    }

    double lastNumValue = baseValues.last;

    int precision = baseValues.fold(0, (int maxPrecision, double value) {
      int precision = value.toString().split('.').last.length;
      return precision > maxPrecision ? precision : maxPrecision;
    });

    return LinearNumericPattern(steps, lastNumValue, precision);
  }

  List<double> _calculateSteps(List<double> values) {
    List<double> steps = <double>[];

    for (int i = 0; i < values.length - 1; i++) {
      double currentNum = values[i];
      double nextNum = values[i + 1];
      steps.add(nextNum - currentNum);
    }

    while (steps.isNotEmpty && steps.first == 0) {
      steps.removeAt(0);
    }

    if (steps.isEmpty) {
      return <double>[1];
    } else {
      return steps;
    }
  }
}

class LinearNumericPattern implements ValuePattern {
  LinearNumericPattern(this.steps, this.lastNumValue, this.precision);

  final List<double> steps;
  final double lastNumValue;
  final int precision;

  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    double lastNumValue = this.lastNumValue;

    for (int i = 0; i < fillCells.length; i++) {
      double step = steps[i % steps.length];
      double newNumValue = lastNumValue + step;
      newNumValue = double.parse(newNumValue.toStringAsFixed(precision));
      lastNumValue = newNumValue;

      fillCells[i].value = NumericCellValue(newNumValue);
    }
  }
}

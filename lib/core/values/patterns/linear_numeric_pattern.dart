import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearNumericPatternMatcher implements ValuePatternMatcher {
  @override
  ValuePattern? detect(List<IndexedCellProperties> values) {
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

class LinearNumericPattern extends ValuePattern {
  LinearNumericPattern({
    required this.steps,
    required this.lastNumValue,
    required this.precision,
  });

  final List<num> steps;
  final num lastNumValue;
  final int precision;

  @override
  List<IndexedCellProperties> apply(List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    num lastNumValue = this.lastNumValue;

    for (int i = 0; i < fillCells.length; i++) {
      IndexedCellProperties templateProperties = baseCells[i % baseCells.length];
      IndexedCellProperties fillProperties = fillCells[i];

      num step = steps[i % steps.length];
      num newNumValue = lastNumValue + step;
      newNumValue = double.parse(newNumValue.toStringAsFixed(precision));
      lastNumValue = newNumValue;

      SheetRichText previousRichText = templateProperties.properties.value;
      SheetRichText updatedRichText = previousRichText.withText(newNumValue.toString());

      fillCells[i] = fillProperties.copyWith(
        properties: fillProperties.properties.copyWith(
          value: updatedRichText,
          style: templateProperties.properties.style,
        ),
      );
    }
    return fillCells;
  }

  @override
  List<Object?> get props => <Object?>[steps, lastNumValue, precision];
}

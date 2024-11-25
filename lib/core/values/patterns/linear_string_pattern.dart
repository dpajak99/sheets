import 'package:equatable/equatable.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class LinearStringPatternMatcher implements ValuePatternMatcher {
  @override
  ValuePattern? detect(List<CellProperties> baseCells) {
    List<_SegmentedStringCellValue>? segmentedValues = _segmentCellValues(baseCells);
    if (segmentedValues == null || segmentedValues.isEmpty) {
      return null;
    }

    HorizontalDirection expectedPosition = segmentedValues.first.integer.position;
    if (!_areIntegerPositionsConsistent(segmentedValues, expectedPosition)) {
      return null;
    }

    List<int> steps = _calculateSteps(segmentedValues);
    if (steps.isEmpty) {
      return null;
    }

    List<String> textValues = segmentedValues
        .take(segmentedValues.length)
        .map((_SegmentedStringCellValue segmentedValue) => segmentedValue.text)
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

  List<_SegmentedStringCellValue>? _segmentCellValues(List<CellProperties> baseCells) {
    List<_SegmentedStringCellValue> segmentedValues = <_SegmentedStringCellValue>[];

    for (CellProperties cell in baseCells) {
      String plainText = cell.value.toPlainText();

      _SegmentedStringCellValue? segmentedValue = _segmentText(plainText);
      if (segmentedValue == null) {
        return null;
      }

      segmentedValues.add(segmentedValue);
    }

    return segmentedValues;
  }

  _SegmentedStringCellValue? _segmentText(String value) {
    RegExp regex = RegExp(
      r'^(?:(?<startNumber>\d+)\s+)?(?<text>.*?)(?<endNumber>\d+)?$',
      unicode: true,
    );

    RegExpMatch? match = regex.firstMatch(value);
    if (match != null) {
      String? startNumber = match.namedGroup('startNumber');
      String? endNumber = match.namedGroup('endNumber');
      String? text = match.namedGroup('text');

      String? valueToIncrement = startNumber ?? endNumber;
      if (valueToIncrement != null && text != null) {
        HorizontalDirection position = startNumber != null ? HorizontalDirection.left : HorizontalDirection.right;
        return _SegmentedStringCellValue(
          _PositionedValue<String, HorizontalDirection>(valueToIncrement, position),
          position == HorizontalDirection.left ? ' $text' : text,
        );
      }
    }

    return null;
  }

  bool _areIntegerPositionsConsistent(
    List<_SegmentedStringCellValue> segmentedValues,
    HorizontalDirection expectedPosition,
  ) {
    return segmentedValues.every(
      (_SegmentedStringCellValue segmentedValue) => segmentedValue.integer.position == expectedPosition,
    );
  }

  List<int> _calculateSteps(List<_SegmentedStringCellValue> segmentedValues) {
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

      SheetRichText previousRichText = baseCells[i % baseCells.length].value;
      SheetRichText updatedRichText = previousRichText.withText(newTextValue);
      fillCells[i].value = updatedRichText;
      fillCells[i].style = baseCells[i % steps.length].style;
    }
  }
}

class _SegmentedStringCellValue with EquatableMixin {
  _SegmentedStringCellValue(this.integer, this.text);

  final _PositionedValue<String, HorizontalDirection> integer;
  final String text;

  @override
  List<Object?> get props => <Object?>[integer, text];
}

class _PositionedValue<T, P> with EquatableMixin {
  _PositionedValue(this.value, this.position);

  final T value;
  final P position;

  @override
  List<Object?> get props => <Object?>[value, position];
}

enum HorizontalDirection { left, right }

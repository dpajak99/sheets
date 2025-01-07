import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

abstract class ValuePatternMatcher {
  ValuePattern<dynamic, dynamic>? detect(List<CellProperties> baseCells);
}

abstract class ValuePattern<V, S> {
  ValuePattern({required this.steps, required this.lastValue});

  final List<S> steps;
  V lastValue;

  V calculateNewValue(int index, CellProperties templateProperties, V lastValue, S? step);

  SheetRichText formatValue(SheetRichText previousRichText, V value);

  void updateState(V newValue);

  // TODO(Dominik): Improvement possibility
  List<CellProperties> apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    List<CellProperties> filledCells = <CellProperties>[];

    for (int i = 0; i < fillCells.length; i++) {
      CellProperties templateProperties = baseCells[i % baseCells.length];
      CellProperties fillProperties = fillCells[i];

      S? step = steps.isNotEmpty ? steps[i % steps.length] : null;
      V newValue = calculateNewValue(i, templateProperties, lastValue, step);

      SheetRichText previousRichText = templateProperties.value;
      SheetRichText updatedRichText = formatValue(previousRichText, newValue);

      filledCells.add(fillProperties.copyWith(
        value: updatedRichText,
        style: templateProperties.style,
      ));

      updateState(newValue);
    }

    return filledCells;
  }
}

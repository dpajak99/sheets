import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

abstract class ValuePatternMatcher {
  ValuePattern<dynamic, dynamic>? detect(List<IndexedCellProperties> baseCells);
}

abstract class ValuePattern<V, S> {
  ValuePattern({required this.steps, required this.lastValue});

  final List<S> steps;
  V lastValue;

  V calculateNewValue(int index, CellProperties templateProperties, V lastValue, S? step);

  SheetRichText formatValue(SheetRichText previousRichText, V value);

  void updateState(V newValue);

  // TODO(Dominik): Improvement possibility
  List<IndexedCellProperties> apply(List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    List<IndexedCellProperties> filledCells = <IndexedCellProperties>[];

    for (int i = 0; i < fillCells.length; i++) {
      IndexedCellProperties templateProperties = baseCells[i % baseCells.length];
      IndexedCellProperties fillProperties = fillCells[i];

      S? step = steps.isNotEmpty ? steps[i % steps.length] : null;
      V newValue = calculateNewValue(i, templateProperties.properties, lastValue, step);

      SheetRichText previousRichText = templateProperties.properties.value;
      SheetRichText updatedRichText = formatValue(previousRichText, newValue);

      filledCells.add(IndexedCellProperties(
        index: fillProperties.index,
        properties: fillProperties.properties.copyWith(
          value: updatedRichText,
          style: templateProperties.properties.style,
        ),
      ));

      updateState(newValue);
    }

    return filledCells;
  }
}

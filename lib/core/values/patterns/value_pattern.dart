import 'package:equatable/equatable.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/direction.dart';

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

  void apply(SheetData data, List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    for (int i = 0; i < fillCells.length; i++) {
      IndexedCellProperties templateProperties = baseCells[i % baseCells.length];
      IndexedCellProperties fillProperties = fillCells[i];

      S? step = steps.isNotEmpty ? steps[i % steps.length] : null;
      V newValue = calculateNewValue(i, templateProperties.properties, lastValue, step);

      SheetRichText previousRichText = templateProperties.properties.value;
      SheetRichText updatedRichText = formatValue(previousRichText, newValue);

      data.setCellProperties(
        fillProperties.index,
        fillProperties.properties.copyWith(
          value: updatedRichText,
          style: templateProperties.properties.style,
        ),
      );

      updateState(newValue);
    }
  }
}

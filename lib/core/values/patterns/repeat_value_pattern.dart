import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class RepeatValuePattern extends ValuePattern {
  @override
  List<IndexedCellProperties> apply(List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    for (int i = 0; i < fillCells.length; i++) {
      IndexedCellProperties templateProperties = baseCells[i % baseCells.length];
      IndexedCellProperties fillProperties = fillCells[i];

      SheetRichText updatedRichText = templateProperties.properties.value;

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
  List<Object?> get props => <Object?>[];
}

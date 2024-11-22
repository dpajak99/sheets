import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';

class RepeatValuePattern implements ValuePattern {
  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    int baseLength = baseCells.length;
    for (int i = 0; i < fillCells.length; i++) {
      CellProperties cellProperties = fillCells[i];
      fillCells[i] = cellProperties.copyWith(
        value: baseCells[i % baseLength].value,
        style: cellProperties.style,
      );
    }
  }
}

import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/cell_value.dart';

abstract class ValuePattern {
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells);
}

class RepeatPattern implements ValuePattern {
  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    int baseLength = baseCells.length;
    for (int i = 0; i < fillCells.length; i++) {
      CellValue value = baseCells[i % baseLength].value;
      fillCells[i].value = value;
    }
  }
}

import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/patterns/value_pattern.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class RepeatValuePattern implements ValuePattern {
  @override
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells) {
    int baseLength = baseCells.length;
    for (int i = 0; i < fillCells.length; i++) {
      SheetRichText value = baseCells[i % baseLength].value;
      fillCells[i].value = value;
      fillCells[i].style = baseCells[i % baseLength].style;
    }
  }
}

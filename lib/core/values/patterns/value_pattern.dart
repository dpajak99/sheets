import 'package:sheets/core/cell_properties.dart';

abstract class ValuePatternMatcher {
  ValuePattern? detect(List<CellProperties> baseCells);
}

abstract class ValuePattern {
  void apply(List<CellProperties> baseCells, List<CellProperties> fillCells);
}

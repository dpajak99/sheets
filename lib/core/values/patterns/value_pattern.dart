import 'package:sheets/core/cell_properties.dart';

abstract class ValuePatternMatcher {
  ValuePattern? detect(List<IndexedCellProperties> baseCells);
}

abstract class ValuePattern {
  List<IndexedCellProperties> apply(List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells);
}

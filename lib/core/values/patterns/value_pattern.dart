import 'package:equatable/equatable.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data_manager.dart';
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

  // Abstract methods to be implemented by subclasses
  V calculateNewValue(int index, CellProperties templateProperties, V lastValue, S? step);

  SheetRichText formatValue(SheetRichText previousRichText, V value);

  void updateState(V newValue);

  void apply(Direction fillDirection, SheetData data, List<IndexedCellProperties> baseCells, List<IndexedCellProperties> fillCells) {
    int templateIndex = 0;
    for (int i = 0; i < fillCells.length; i++) {
      IndexedCellProperties templateProperties = baseCells[templateIndex % baseCells.length];
      IndexedCellProperties fillProperties = fillCells[i];

      if (templateProperties.properties.mergeStatus.contains(fillProperties.index)) {
        continue;
      }

      S? step = steps.isNotEmpty ? steps[templateIndex % steps.length] : null;
      V newValue = calculateNewValue(templateIndex, templateProperties.properties, lastValue, step);

      SheetRichText previousRichText = templateProperties.properties.value;
      SheetRichText updatedRichText = formatValue(previousRichText, newValue);

      int dxDiff = fillProperties.index.column.value - templateProperties.index.column.value;
      int dyDiff = fillProperties.index.row.value - templateProperties.index.row.value;
      CellMergeStatus mergeStatus = templateProperties.properties.mergeStatus.move(
        dx: dxDiff,
        dy: dyDiff,
      );
      updateMergedCells(data, mergeStatus);

      data.setCellProperties(
        fillProperties.index,
        fillProperties.properties.copyWith(
          value: updatedRichText,
          mergeStatus: mergeStatus,
          style: templateProperties.properties.style,
        ),
      );

      updateState(newValue);

      if (fillDirection.isVertical) {
        i += mergeStatus.height;
      } else {
        i += mergeStatus.width;
      }
      templateIndex++;
    }
  }

  // Existing methods from your ValuePattern class
  void disposeActiveMerges(CellIndex index, SheetData data) {
    CellProperties cellProperties = data.getCellProperties(index);
    if (cellProperties.mergeStatus is MergedCell) {
      MergedCell mergedCell = cellProperties.mergeStatus as MergedCell;
      for (CellIndex mergedIndex in mergedCell.mergedCells) {
        data.setCellProperties(mergedIndex, data.getCellProperties(mergedIndex).copyWith(mergeStatus: NoCellMerge()));
      }
    }
  }

  void updateMergedCells(SheetData data, CellMergeStatus mergeStatus) {
    if (mergeStatus is MergedCell) {
      for (CellIndex index in mergeStatus.mergedCells) {
        CellProperties cellProperties = data.getCellProperties(index);
        CellMergeStatus childMergeStatus = cellProperties.mergeStatus;
        if (childMergeStatus is MergedCell) {
          disposeActiveMerges(index, data);
        }
        data.setCellProperties(index, cellProperties.copyWith(mergeStatus: mergeStatus));
      }
    }
  }
}

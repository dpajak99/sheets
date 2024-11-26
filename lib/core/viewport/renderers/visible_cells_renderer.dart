import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/extensions/viewport_extensions.dart';

class VisibleCellsRenderer {
  VisibleCellsRenderer({
    required this.visibleRows,
    required this.visibleColumns,
  });

  final List<ViewportRow> visibleRows;

  final List<ViewportColumn> visibleColumns;

  List<ViewportCell> build(SheetDataManager dataManager) {
    List<ViewportCell> visibleCells = <ViewportCell>[];
    List<ViewportCell> mergedCells = <ViewportCell>[];
    List<MergedCell> resolvedMergedCells = <MergedCell>[];

    for (int y = 0; y < visibleRows.length; y++) {
      ViewportRow row = visibleRows[y];

      for (int x = 0; x < visibleColumns.length; x++) {
        ViewportColumn column = visibleColumns[x];

        CellIndex cellIndex = CellIndex(column: column.index, row: row.index);
        CellProperties cellProperties = dataManager.getCellProperties(cellIndex);

        if (cellProperties.mergeStatus is MergedCell) {
          MergedCell mergedCell = cellProperties.mergeStatus as MergedCell;
          CellProperties startCellProperties = dataManager.getCellProperties(mergedCell.start);

          if (mergedCell.isMainCell(cellIndex) || (y == 0 || x == 0) && !resolvedMergedCells.contains(mergedCell)) {
            CellIndex mergeEnd = mergedCell.end;

            ViewportRow rowEnd = visibleRows.findByIndex(mergeEnd.row);
            ViewportColumn columnEnd = visibleColumns.findByIndex(mergeEnd.column);

            mergedCells.add(ViewportCell.merged(
              index: mergedCell.start,
              rowStart: row,
              rowEnd: rowEnd,
              columnStart: column,
              columnEnd: columnEnd,
              properties: startCellProperties.copyWith(
                value: SheetRichText.single(text: 'Merged'),
              ),
            ));
            resolvedMergedCells.add(mergedCell);
          }
        } else {
          visibleCells.add(ViewportCell(
            column: column,
            row: row,
            properties: cellProperties.copyWith(
              value: SheetRichText.single(text: '--'),
            ),
          ));
        }
      }
    }

    return <ViewportCell>[...visibleCells, ...mergedCells];
  }
}

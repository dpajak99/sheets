import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/extensions/viewport_extensions.dart';

class VisibleCellsRenderer {
  VisibleCellsRenderer({
    required this.visibleRows,
    required this.visibleColumns,
  });

  final List<ViewportRow> visibleRows;

  final List<ViewportColumn> visibleColumns;

  List<ViewportCell> build(Worksheet worksheet) {
    List<ViewportCell> visibleCells = <ViewportCell>[];
    List<ViewportCell> mergedCells = <ViewportCell>[];
    List<CellMergeStatus> resolvedMergedCells = <CellMergeStatus>[];

    for (int y = 0; y < visibleRows.length; y++) {
      ViewportRow row = visibleRows[y];

      for (int x = 0; x < visibleColumns.length; x++) {
        ViewportColumn column = visibleColumns[x];

        CellIndex cellIndex = CellIndex(column: column.index, row: row.index);
        CellProperties cellProperties = worksheet.getCell(cellIndex);

        if (cellProperties.mergeStatus.isMerged) {
          CellMergeStatus mergedCell = cellProperties.mergeStatus;
          CellProperties startCellProperties = worksheet.getCell(mergedCell.start!);

          if (mergedCell.isMainCell(cellIndex) || (y == 0 || x == 0) && !resolvedMergedCells.contains(mergedCell)) {
            CellIndex mergeEnd = mergedCell.end!;

            ViewportRow rowEnd = visibleRows.findByIndex(mergeEnd.row);
            ViewportColumn columnEnd = visibleColumns.findByIndex(mergeEnd.column);

            mergedCells.add(ViewportCell.merged(
              index: mergedCell.start!,
              rowStart: row,
              rowEnd: rowEnd,
              columnStart: column,
              columnEnd: columnEnd,
              properties: startCellProperties,
            ));
            resolvedMergedCells.add(mergedCell);
          }
        } else {
          visibleCells.add(ViewportCell(
            column: column,
            row: row,
            properties: cellProperties,
          ));
        }
      }
    }

    return <ViewportCell>[...visibleCells, ...mergedCells];
  }
}

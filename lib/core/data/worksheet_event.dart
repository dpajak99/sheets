import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';

abstract class WorksheetEvent {
  void handle(Worksheet worksheet);
}

/// Inserts a batch of cell properties into the worksheet.
class InsertCellsWorksheetEvent extends WorksheetEvent {
  InsertCellsWorksheetEvent(this.cells);

  final List<CellProperties> cells;

  @override
  void handle(Worksheet worksheet) {
    List<CellMergeStatus> mergedCells = cells //
        .map((CellProperties cell) => cell.mergeStatus) //
        .where((CellMergeStatus e) => e.isMerged) //
        .toList();

    for (CellMergeStatus mergedCell in mergedCells) {
      worksheet.dispatchEvent(MergeCellsWorksheetEvent(cells: mergedCell.mergedCells));
    }

    // Each event can implement its own logic.
    for (CellProperties cell in cells) {
      worksheet.cellConfigs[cell.index] = CellConfig.fromProperties(cell);
    }
    // Possibly recalc the sheet size, etc.
    worksheet.recalculateContentSize();

    List<RowIndex> rows = cells.map((CellProperties cell) => cell.index.row).toSet().toList();
    for (RowIndex row in rows) {
      double minRowHeight = worksheet.getMinRowHeight(row);
      worksheet.dispatchEvent(SetRowHeightWorksheetEvent(row, minRowHeight));
    }
  }
}

/// Merges a list of cells into one merged region.
class MergeCellsWorksheetEvent extends WorksheetEvent {
  MergeCellsWorksheetEvent({
    required this.cells,
    this.overrideStyle,
  });

  final List<CellIndex> cells;
  final CellStyle? overrideStyle;

  @override
  void handle(Worksheet worksheet) {
    if (cells.length < 2) {
      return;
    }

    CellIndex start = cells.first;
    CellIndex end = cells.last;

    // 1. Unmerge all cells in the given range first.
    for (CellIndex cellIndex in cells) {
      _unmergeCell(worksheet, cellIndex);
    }

    // 2. Create a reference config from the first cell.
    CellConfig reference = CellConfig.fromProperties(
      worksheet.getCell(start),
    );

    // 3. Merge each cell in [cells].
    for (CellIndex cellIndex in cells) {
      worksheet.cellConfigs[cellIndex] = reference.copyWith(
        mergeStatus: CellMergeStatus.merged(start: start, end: end),
        style: overrideStyle ?? reference.style,
      );
    }

    // Recalculate if needed
    worksheet.recalculateContentSize();
  }

  void _unmergeCell(Worksheet worksheet, CellIndex cellIndex) {
    CellConfig? cellConfig = worksheet.cellConfigs[cellIndex];
    if (cellConfig == null) {
      return;
    }

    CellMergeStatus mergeStatus = cellConfig.mergeStatus;
    if (mergeStatus.isMerged) {
      CellConfig? mainCellConfig = worksheet.cellConfigs[mergeStatus.start];
      for (CellIndex index in mergeStatus.mergedCells) {
        worksheet.cellConfigs[index] = mainCellConfig?.copyWith(
              mergeStatus: const CellMergeStatus.noMerge(),
            ) ??
            CellConfig();
      }
    }
  }
}

/// Unmerges a list of cells.
class UnmergeCellsWorksheetEvent extends WorksheetEvent {
  UnmergeCellsWorksheetEvent(this.cells);

  UnmergeCellsWorksheetEvent.single(CellIndex cell) : cells = <CellIndex>[cell];

  final List<CellIndex> cells;

  @override
  void handle(Worksheet worksheet) {
    for (CellIndex cellIndex in cells) {
      _unmergeCell(worksheet, cellIndex);
    }
    worksheet.recalculateContentSize();
  }

  void _unmergeCell(Worksheet worksheet, CellIndex cellIndex) {
    CellConfig? cellConfig = worksheet.cellConfigs[cellIndex];
    if (cellConfig == null) {
      return;
    }

    CellMergeStatus mergeStatus = cellConfig.mergeStatus;
    if (mergeStatus.isMerged) {
      CellConfig? mainCellConfig = worksheet.cellConfigs[mergeStatus.start];
      for (CellIndex index in mergeStatus.mergedCells) {
        worksheet.cellConfigs[index] = mainCellConfig?.copyWith(
              mergeStatus: const CellMergeStatus.noMerge(),
            ) ??
            CellConfig();
      }
    }
  }
}

/// Clears the contents (but not style) of given cells.
class ClearCellsWorksheetEvent extends WorksheetEvent {
  ClearCellsWorksheetEvent(this.cells);

  final List<CellIndex> cells;

  @override
  void handle(Worksheet worksheet) {
    for (CellIndex cellIndex in cells) {
      CellConfig? currentConfig = worksheet.cellConfigs[cellIndex];
      if (currentConfig == null) {
        continue;
      }

      worksheet.cellConfigs[cellIndex] = currentConfig.copyWith(
        value: currentConfig.value.clear(),
      );
    }
    worksheet.recalculateContentSize();
  }
}

/// Applies a style-format action to a range of cells.
class FormatSelectionWorksheetEvent extends WorksheetEvent {
  FormatSelectionWorksheetEvent(this.cells, this.formatAction);

  final List<CellIndex> cells;
  final StyleFormatAction<StyleFormatIntent> formatAction;

  @override
  void handle(Worksheet worksheet) {
    for (CellIndex cellIndex in cells) {
      worksheet.cellConfigs[cellIndex] ??= CellConfig();
      CellConfig currentConfig = worksheet.cellConfigs[cellIndex]!;

      switch (formatAction) {
        case TextStyleFormatAction<TextStyleFormatIntent> _:
          // Updating text style
          worksheet.cellConfigs[cellIndex] = currentConfig.copyWith(
            value: currentConfig.value.updateStyle(
              formatAction as TextStyleFormatAction<TextStyleFormatIntent>,
            ),
          );
        case CellStyleFormatAction<CellStyleFormatIntent> _:
          // Updating cell style
          worksheet.cellConfigs[cellIndex] = currentConfig.copyWith(
            style: (formatAction as CellStyleFormatAction<CellStyleFormatIntent>).format(currentConfig.style),
          );
      }
      // Optionally adjust row height if needed
      worksheet.adjustCellHeight(cellIndex);
    }
    worksheet.recalculateContentSize();
  }
}

/// Sets a new text value in the given cell.
class SetTextWorksheetEvent extends WorksheetEvent {
  SetTextWorksheetEvent(this.cellIndex, this.text);

  final CellIndex cellIndex;
  final SheetRichText text;

  @override
  void handle(Worksheet worksheet) {
    CellConfig currentConfig = worksheet.cellConfigs[cellIndex] ?? CellConfig();
    worksheet.cellConfigs[cellIndex] = currentConfig.copyWith(value: text);

    // Adjust row height (optional)
    worksheet.adjustCellHeight(cellIndex);

    worksheet.recalculateContentSize();
  }
}

/// Example event: set row height
class SetRowHeightWorksheetEvent extends WorksheetEvent {
  SetRowHeightWorksheetEvent(this.rowIndex, this.height, {this.keepValue = false});

  final RowIndex rowIndex;
  final double height;
  final bool keepValue;

  @override
  void handle(Worksheet worksheet) {
    RowConfig oldRowConfig = worksheet.rowConfigs[rowIndex] ?? const RowConfig();
    RowConfig newRowConfig = oldRowConfig.copyWith(
      height: height,
      customHeight: keepValue ? height : null,
    );

    worksheet.rowConfigs[rowIndex] = newRowConfig;
    // Recalculate if something changed
    worksheet.recalculateContentSize();
  }
}

/// Example event: set column width
class SetColumnWidthWorksheetEvent extends WorksheetEvent {
  SetColumnWidthWorksheetEvent(this.columnIndex, this.width);

  final ColumnIndex columnIndex;
  final double width;

  @override
  void handle(Worksheet worksheet) {
    ColumnConfig oldColumnConfig = worksheet.columnConfigs[columnIndex] ?? const ColumnConfig();
    ColumnConfig newColumnConfig = oldColumnConfig.copyWith(width: width);

    worksheet.columnConfigs[columnIndex] = newColumnConfig;
    // Recalculate if something changed
    worksheet.recalculateContentSize();
  }
}

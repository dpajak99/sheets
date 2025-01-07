import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/utils/text_rotation.dart';

/// --------------------------------------------------------------------
/// 1. The base WorksheetEvent class + several example events
///    Each event fully defines its own functionality inside handle().
/// --------------------------------------------------------------------
abstract class WorksheetEvent {
  void handle(Worksheet worksheet);
}

/// Inserts a batch of cell properties into the worksheet.
class InsertCellsEvent extends WorksheetEvent {
  InsertCellsEvent(this.cells);

  final List<CellProperties> cells;

  @override
  void handle(Worksheet worksheet) {
    List<MergedCell> mergedCells = cells.map((CellProperties cell) => cell.mergeStatus).whereType<MergedCell>().toList();

    for (MergedCell mergedCell in mergedCells) {
      worksheet.dispatchEvent(MergeCellsEvent(cells: mergedCell.mergedCells));
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
      worksheet.dispatchEvent(SetRowHeightEvent(row, minRowHeight));
    }
  }
}

/// Merges a list of cells into one merged region.
class MergeCellsEvent extends WorksheetEvent {
  MergeCellsEvent({
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
        mergeStatus: MergedCell(start: start, end: end),
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
    if (mergeStatus is MergedCell) {
      CellConfig? mainCellConfig = worksheet.cellConfigs[mergeStatus.start];
      for (CellIndex index in mergeStatus.mergedCells) {
        worksheet.cellConfigs[index] = mainCellConfig?.copyWith(
              mergeStatus: const NoCellMerge(),
            ) ??
            CellConfig();
      }
    }
  }
}

/// Unmerges a list of cells.
class UnmergeCellsEvent extends WorksheetEvent {
  UnmergeCellsEvent(this.cells);

  UnmergeCellsEvent.single(CellIndex cell) : cells = <CellIndex>[cell];

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
    if (mergeStatus is MergedCell) {
      CellConfig? mainCellConfig = worksheet.cellConfigs[mergeStatus.start];
      for (CellIndex index in mergeStatus.mergedCells) {
        worksheet.cellConfigs[index] = mainCellConfig?.copyWith(
              mergeStatus: const NoCellMerge(),
            ) ??
            CellConfig();
      }
    }
  }
}

/// Clears the contents (but not style) of given cells.
class ClearCellsEvent extends WorksheetEvent {
  ClearCellsEvent(this.cells);

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
class FormatSelectionDataEvent extends WorksheetEvent {
  FormatSelectionDataEvent(this.cells, this.formatAction);

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
class SetTextEvent extends WorksheetEvent {
  SetTextEvent(this.cellIndex, this.text);

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
class SetRowHeightEvent extends WorksheetEvent {
  SetRowHeightEvent(this.rowIndex, this.height, {this.keepValue = false});

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
class SetColumnWidthEvent extends WorksheetEvent {
  SetColumnWidthEvent(this.columnIndex, this.width);

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

/// --------------------------------------------------------------------
/// 2. Worksheet class
///    - Holds rowConfigs, columnConfigs, cellConfigs directly
///    - Dispatches events by calling `event.handle(this)`
///    - Contains all "utility" methods needed by events
/// --------------------------------------------------------------------
class Worksheet {
  Worksheet({
    required this.rows,
    required this.cols,
    this.name,
    Map<RowIndex, RowConfig>? rowConfigs,
    Map<ColumnIndex, ColumnConfig>? columnConfigs,
    Map<CellIndex, CellConfig>? cellConfigs,
  })  : rowConfigs = rowConfigs ?? <RowIndex, RowConfig>{},
        columnConfigs = columnConfigs ?? <ColumnIndex, ColumnConfig>{},
        cellConfigs = cellConfigs ?? <CellIndex, CellConfig>{} {
    recalculateContentSize();
  }

  final int rows;
  final int cols;
  final String? name;

  /// Holds row-specific configs (like height, customHeight, etc.).
  final Map<RowIndex, RowConfig> rowConfigs;

  /// Holds column-specific configs (like width, customWidth, etc.).
  final Map<ColumnIndex, ColumnConfig> columnConfigs;

  /// Holds configurations of all cells (styles, merges, values, etc.).
  final Map<CellIndex, CellConfig> cellConfigs;

  /// Internally cached content width and height.
  double _contentWidth = 0;
  double _contentHeight = 0;

  Size get contentSize => Size(_contentWidth, _contentHeight);

  /// The main method to handle events.
  /// Each event fully defines its own logic in `handle()`.
  void dispatchEvent(WorksheetEvent event) {
    event.handle(this);
  }

  List<T> fillCellIndexes<T extends SheetIndex>(List<T> sheetIndexes) {
    return sheetIndexes.map(fillCellIndex).toList();
  }

  T fillCellIndex<T extends SheetIndex>(T sheetIndex) {
    if (sheetIndex is! CellIndex) {
      return sheetIndex;
    }
    CellMergeStatus mergeStatus = getCell(sheetIndex).mergeStatus;
    if (mergeStatus is MergedCell) {
      return MergedCellIndex(start: mergeStatus.start, end: mergeStatus.end) as T;
    } else {
      return sheetIndex;
    }
  }

  /// Recalculates total content size (width + height) based on row/column configs.
  void recalculateContentSize() {
    _recalculateContentWidth();
    _recalculateContentHeight();
  }

  /// Adjusts the row's height if content changed.
  void adjustCellHeight(CellIndex cellIndex) {
    double neededHeight = getMinRowHeight(cellIndex.row);
    RowConfig oldConfig = rowConfigs[cellIndex.row] ?? const RowConfig();
    RowConfig newConfig = oldConfig.copyWith(height: neededHeight);
    if (newConfig.height != oldConfig.height) {
      rowConfigs[cellIndex.row] = newConfig;
      recalculateContentSize();
    }
  }

  /// Returns a "renderable" CellProperties (injecting row/column configs).
  CellProperties getCell(CellIndex cellIndex) {
    CellConfig config = cellConfigs[cellIndex] ?? CellConfig();
    RowConfig rowCfg = rowConfigs[cellIndex.row] ?? const RowConfig();
    ColumnConfig colCfg = columnConfigs[cellIndex.column] ?? const ColumnConfig();

    return CellProperties(
      index: cellIndex,
      style: config.style,
      value: config.value,
      mergeStatus: config.mergeStatus,
      rowConfig: rowCfg,
      columnConfig: colCfg,
    );
  }

  /// Returns all cells (with their row/column configs) in the given list of indices.
  List<CellProperties> getCells(List<CellIndex> indices) {
    return indices.map(getCell).toList();
  }

  /// Returns all cells in a rectangular region from [start] to [end].
  List<CellProperties> getRange(CellIndex start, CellIndex end) {
    List<CellProperties> cells = <CellProperties>[];
    for (int r = start.row.value; r <= end.row.value; r++) {
      for (int c = start.column.value; c <= end.column.value; c++) {
        cells.add(getCell(CellIndex.raw(r, c)));
      }
    }
    return cells;
  }

  RowConfig getRow(RowIndex rowIndex) {
    return rowConfigs[rowIndex] ?? const RowConfig();
  }

  ColumnConfig getColumn(ColumnIndex columnIndex) {
    return columnConfigs[columnIndex] ?? const ColumnConfig();
  }

  /// Calculates minimal height for a given row based on the content of its cells.
  double getMinRowHeight(RowIndex rowIndex) {
    // Gather all cells for this row
    List<CellIndex> relevantCells = cellConfigs.keys.where((CellIndex cellIndex) => cellIndex.row == rowIndex).toList();
    if (relevantCells.isEmpty) {
      relevantCells.add(CellIndex(row: rowIndex, column: ColumnIndex(0)));
    }

    List<CellProperties> cellProperties = getCells(relevantCells);

    double? staticHeight = rowConfigs[rowIndex]?.customHeight;
    double maxNeededHeight = cellProperties.fold<double>(0, (double s, CellProperties cell) => math.max(s, cell.neededHeight));
    if (staticHeight != null) {
      return math.max(maxNeededHeight, staticHeight);
    }
    return maxNeededHeight;
  }

  void _recalculateContentWidth() {
    double totalWidth = 0;
    for (int c = 0; c < cols; c++) {
      ColumnConfig config = columnConfigs[ColumnIndex(c)] ?? const ColumnConfig();
      totalWidth += config.width + borderWidth;
    }
    // Subtract the left border for the first column
    totalWidth -= borderWidth;
    _contentWidth = totalWidth;
  }

  void _recalculateContentHeight() {
    double totalHeight = 0;
    for (int r = 0; r < rows; r++) {
      RowConfig config = rowConfigs[RowIndex(r)] ?? const RowConfig();
      totalHeight += config.height + borderWidth;
    }
    // Subtract the top border for the first row
    totalHeight -= borderWidth;
    _contentHeight = totalHeight;
  }
}

// --------------------------------------------------------------------
// 3. Supporting classes, constants, and stubs
// --------------------------------------------------------------------

abstract class CellMergeStatus {
  const CellMergeStatus();

  CellMergeStatus move({required int dx, required int dy});

  int get width => 0;

  int get height => 0;

  List<CellIndex> get mergedCells => <CellIndex>[];

  bool contains(CellIndex index) {
    return false;
  }
}

class NoCellMerge extends CellMergeStatus {
  const NoCellMerge();

  @override
  NoCellMerge move({required int dx, required int dy}) {
    return this;
  }
}

class MergedCell extends CellMergeStatus {
  MergedCell({
    required this.start,
    required this.end,
  });

  final CellIndex start;
  final CellIndex end;

  MergedCellIndex get index => MergedCellIndex(start: start, end: end);

  @override
  int get width {
    return end.column.value - start.column.value;
  }

  String get id => '${width + 1}x${height + 1}';

  @override
  int get height => end.row.value - start.row.value;

  bool isMainCell(CellIndex index) {
    return index == start;
  }

  @override
  bool contains(CellIndex index) {
    if (index is MergedCellIndex) {
      return index.selectedCells.any(contains);
    }
    return index.row.value >= start.row.value &&
        index.row.value <= end.row.value &&
        index.column.value >= start.column.value &&
        index.column.value <= end.column.value;
  }

  @override
  List<CellIndex> get mergedCells {
    List<CellIndex> mergedCells = <CellIndex>[];
    for (int i = start.row.value; i <= end.row.value; i++) {
      for (int j = start.column.value; j <= end.column.value; j++) {
        mergedCells.add(CellIndex(row: RowIndex(i), column: ColumnIndex(j)));
      }
    }
    return mergedCells;
  }

  @override
  MergedCell move({required int dx, required int dy}) {
    return MergedCell(
      start: start.move(dx: dx, dy: dy),
      end: end.move(dx: dx, dy: dy),
    );
  }

  MergedCell moveVertical({required int dy, bool reverse = false}) {
    int updatedDy = reverse ? dy - height : dy;
    return MergedCell(
      start: start.move(dx: 0, dy: updatedDy),
      end: end.move(dx: 0, dy: updatedDy),
    );
  }

  MergedCell moveHorizontal({required int dx, bool reverse = false}) {
    int updatedDx = reverse ? dx - width : dx;
    return MergedCell(
      start: start.move(dx: updatedDx, dy: 0),
      end: end.move(dx: updatedDx, dy: 0),
    );
  }
}

class RowConfig {
  const RowConfig({
    this.height = 21,
    this.customHeight,
  });

  final double height;
  final double? customHeight;

  RowConfig copyWith({
    double? height,
    double? customHeight,
  }) {
    return RowConfig(
      height: height ?? this.height,
      customHeight: customHeight ?? this.customHeight,
    );
  }
}

class ColumnConfig {
  const ColumnConfig({
    this.width = 100,
    this.customWidth,
  });

  final double width;
  final double? customWidth;

  ColumnConfig copyWith({
    double? width,
    double? customWidth,
  }) {
    return ColumnConfig(
      width: width ?? this.width,
      customWidth: customWidth ?? this.customWidth,
    );
  }
}

class CellConfig {
  CellConfig({
    CellStyle? style,
    SheetRichText? value,
    this.mergeStatus = const NoCellMerge(),
  })  : style = style ?? CellStyle(),
        value = value ?? SheetRichText();

  factory CellConfig.fromProperties(CellProperties props) {
    return CellConfig(
      style: props.style,
      value: props.value,
      mergeStatus: props.mergeStatus,
    );
  }

  final CellStyle style;
  final SheetRichText value;
  final CellMergeStatus mergeStatus;

  CellConfig copyWith({
    CellStyle? style,
    SheetRichText? value,
    CellMergeStatus? mergeStatus,
  }) {
    return CellConfig(
      style: style ?? this.style,
      value: value ?? this.value,
      mergeStatus: mergeStatus ?? this.mergeStatus,
    );
  }
}

class CellProperties {
  CellProperties({
    required this.index,
    this.rowConfig = const RowConfig(),
    this.columnConfig = const ColumnConfig(),
    this.mergeStatus = const NoCellMerge(),
    CellStyle? style,
    SheetRichText? value,
  })  : style = style ?? CellStyle(),
        value = value ?? SheetRichText();

  final CellIndex index;
  final CellStyle style;
  final SheetRichText value;
  final CellMergeStatus mergeStatus;
  final RowConfig rowConfig;
  final ColumnConfig columnConfig;

  bool get isEmpty => value.isEmpty;

  TextAlign get visibleTextAlign {
    return style.horizontalAlign ?? visibleValueFormat.textAlign;
  }

  SheetValueFormat get visibleValueFormat {
    return style.valueFormat ?? SheetValueFormat.auto(value);
  }

  SheetRichText get visibleRichText {
    return visibleValueFormat.formatVisible(value) ?? value;
  }

  SheetRichText get editableRichText {
    return visibleValueFormat.formatEditable(value);
  }

  CellIndex get startIndex {
    if (mergeStatus is MergedCell) {
      return (mergeStatus as MergedCell).start;
    }
    return index;
  }

  CellIndex get endIndex {
    if (mergeStatus is MergedCell) {
      return (mergeStatus as MergedCell).end;
    }
    return index;
  }

  double get neededWidth {
    return neededSize.width;
  }

  double get neededHeight {
    return neededSize.height;
  }

  Size get neededSize {
    // Magic padding
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 3, vertical: 2);

    if (value.isEmpty) {
      double h = rowConfig.height;
      double w = columnConfig.width;
      return Size(w, h);
    }

    TextRotation rotation = style.rotation;
    TextSpan textSpan = value.toTextSpan();

    // If vertical, add a divider for each character or line
    if (rotation == TextRotation.vertical) {
      textSpan = textSpan.applyDivider('\n');
    }

    TextPainter painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: visibleTextAlign,
    )..layout();

    double textWidth = painter.width;
    double textHeight = painter.height;

    double minW;
    double minH;

    double angle = rotation.angle;
    if (rotation == TextRotation.vertical) {
      // Vertical text approach
      minW = textWidth + padding.horizontal;
      minH = textHeight + padding.vertical;
    } else if (angle != 0) {
      // Arbitrary rotation
      double radians = angle * math.pi / 180;
      double sinValue = math.sin(radians).abs();
      double cosValue = math.cos(radians).abs();

      double rotatedWidth = textWidth * cosValue + textHeight * sinValue;
      double rotatedHeight = textWidth * sinValue + textHeight * cosValue;

      minW = rotatedWidth + padding.horizontal;
      minH = rotatedHeight + padding.vertical;
    } else {
      // No rotation
      minW = textWidth + padding.horizontal;
      minH = textHeight + padding.vertical;
    }

    return Size(
      minW.clamp(defaultColumnWidth, double.infinity),
      minH.clamp(defaultRowHeight, double.infinity),
    );
  }

  CellProperties copyWith({
    CellIndex? index,
    CellStyle? style,
    SheetRichText? value,
    CellMergeStatus? mergeStatus,
    RowConfig? rowConfig,
    ColumnConfig? columnConfig,
  }) {
    return CellProperties(
      index: index ?? this.index,
      style: style ?? this.style,
      value: value ?? this.value,
      mergeStatus: mergeStatus ?? this.mergeStatus,
      rowConfig: rowConfig ?? this.rowConfig,
      columnConfig: columnConfig ?? this.columnConfig,
    );
  }
}

class CellStyle {
  CellStyle({
    TextAlign? horizontalAlign,
    TextOverflowBehavior? textOverflow,
    TextAlignVertical? verticalAlign,
    TextRotation? rotation,
    Color? backgroundColor,
    this.valueFormat,
    this.border,
  })  : horizontalAlign = horizontalAlign ?? TextAlign.left,
        textOverflow = textOverflow ?? TextOverflowBehavior.clip,
        verticalAlign = verticalAlign ?? TextAlignVertical.bottom,
        rotation = rotation ?? TextRotation.none,
        backgroundColor = (backgroundColor != null && backgroundColor.a == 1) ? backgroundColor : Colors.white;

  final SheetValueFormat? valueFormat;
  final Color backgroundColor;
  final TextAlign? horizontalAlign;
  final TextRotation rotation;
  final TextOverflowBehavior textOverflow;
  final TextAlignVertical verticalAlign;
  final Border? border;

  CellStyle copyWith({
    TextAlign? horizontalAlign,
    TextOverflowBehavior? textOverflow,
    TextAlignVertical? verticalAlign,
    TextRotation? rotation,
    Color? backgroundColor,
    SheetValueFormat? valueFormat,
    bool? valueFormatNull,
    Border? border,
  }) {
    return CellStyle(
      horizontalAlign: horizontalAlign ?? this.horizontalAlign,
      textOverflow: textOverflow ?? this.textOverflow,
      verticalAlign: verticalAlign ?? this.verticalAlign,
      rotation: rotation ?? this.rotation,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      valueFormat: (valueFormatNull ?? false) ? null : valueFormat ?? this.valueFormat,
      border: border ?? this.border,
    );
  }
}

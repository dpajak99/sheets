import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet_event.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/utils/text_rotation.dart';

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
    if (mergeStatus.isMerged) {
      return MergedCellIndex(start: mergeStatus.start!, end: mergeStatus.end!) as T;
    } else {
      return sheetIndex;
    }
  }

  FirstVisibleRowInfo findRowByY(double y) {
    int actualRowIndex = 0;
    double currentHeightStart = 0;

    FirstVisibleRowInfo? firstVisibleRowInfo;

    while (firstVisibleRowInfo == null) {
      RowIndex rowIndex = RowIndex(actualRowIndex);
      RowConfig rowConfig = getRow(rowIndex);
      double rowHeightEnd = currentHeightStart + rowConfig.height + borderWidth;

      if (y >= currentHeightStart && y < rowHeightEnd) {
        firstVisibleRowInfo = FirstVisibleRowInfo(
          index: rowIndex,
          startCoordinate: currentHeightStart,
          visibleHeight: rowHeightEnd - y,
          hiddenHeight: y - currentHeightStart,
        );
      } else {
        actualRowIndex++;
        currentHeightStart = rowHeightEnd;
      }
    }

    return firstVisibleRowInfo;
  }

  FirstVisibleColumnInfo findColumnByX(double x) {
    int actualColumnIndex = 0;
    double currentWidthStart = 0;

    FirstVisibleColumnInfo? firstVisibleColumnInfo;

    while (firstVisibleColumnInfo == null) {
      ColumnIndex columnIndex = ColumnIndex(actualColumnIndex);
      ColumnConfig columnConfig = getColumn(columnIndex);
      double columnWidthEnd = currentWidthStart + columnConfig.width + borderWidth;

      if (x >= currentWidthStart && x < columnWidthEnd) {
        firstVisibleColumnInfo = FirstVisibleColumnInfo(
          index: columnIndex,
          startCoordinate: currentWidthStart - borderWidth,
          visibleWidth: columnWidthEnd - x,
          hiddenWidth: x - currentWidthStart,
        );
      } else {
        actualColumnIndex++;
        currentWidthStart = columnWidthEnd;
      }
    }

    return firstVisibleColumnInfo;
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

class CellMergeStatus {
  /// If `start` and `end` are null, this represents a "NoCellMerge" scenario.
  /// Otherwise, it represents a "MergedCell" scenario.
  final CellIndex? start;
  final CellIndex? end;

  const CellMergeStatus.noMerge()
      : start = null,
        end = null;

  const CellMergeStatus.merged({
    required this.start,
    required this.end,
  });

  /// Indicates whether this instance is a merged cell range.
  bool get isMerged => start != null && end != null;

  /// Returns the width of the merged cell range.
  /// If not merged, returns 0.
  int get width {
    if (!isMerged) return 0;
    return end!.column.value - start!.column.value;
  }

  /// Returns the height of the merged cell range.
  /// If not merged, returns 0.
  int get height {
    if (!isMerged) return 0;
    return end!.row.value - start!.row.value;
  }

  /// Checks if a given [index] is within this merged cell range.
  /// Always returns false if not merged.
  bool contains(CellIndex index) {
    // If this is not merged, it can't contain any cell.
    if (!isMerged) {
      return false;
    }

    // If [index] is a MergedCellIndex, check each of its selected cells.
    if (index is MergedCellIndex) {
      return index.selectedCells.any(contains);
    }

    return index.row.value >= start!.row.value &&
        index.row.value <= end!.row.value &&
        index.column.value >= start!.column.value &&
        index.column.value <= end!.column.value;
  }

  /// Returns a list of all cells in this merged cell range.
  /// For a non-merged scenario, returns an empty list.
  List<CellIndex> get mergedCells {
    if (!isMerged) {
      return <CellIndex>[];
    }
    final List<CellIndex> result = <CellIndex>[];
    for (int r = start!.row.value; r <= end!.row.value; r++) {
      for (int c = start!.column.value; c <= end!.column.value; c++) {
        result.add(
          CellIndex(
            row: RowIndex(r),
            column: ColumnIndex(c),
          ),
        );
      }
    }
    return result;
  }

  /// Returns a textual reference of the merged size, for example "3x2".
  String get reference {
    return '${width + 1}x${height + 1}';
  }

  /// Checks if the given [index] is the main cell of the merged range (i.e., the `start` cell).
  bool isMainCell(CellIndex index) {
    if (!isMerged) return false;
    return index == start;
  }

  /// Creates a new instance of [CellMergeStatus], shifted by (dx, dy).
  /// If the current instance is not merged, it simply returns the same instance.
  CellMergeStatus move({required int dx, required int dy}) {
    if (!isMerged) {
      // Not merged, so no change.
      return this;
    }
    return CellMergeStatus.merged(
      start: start!.move(dx: dx, dy: dy),
      end: end!.move(dx: dx, dy: dy),
    );
  }

  /// Moves the merged range vertically by [dy].
  /// If [reverse] is true, it subtracts the height from [dy].
  CellMergeStatus moveVertical({required int dy, bool reverse = false}) {
    if (!isMerged) {
      return this;
    }
    int updatedDy = reverse ? dy - height : dy;
    return CellMergeStatus.merged(
      start: start!.move(dx: 0, dy: updatedDy),
      end: end!.move(dx: 0, dy: updatedDy),
    );
  }

  /// Moves the merged range horizontally by [dx].
  /// If [reverse] is true, it subtracts the width from [dx].
  CellMergeStatus moveHorizontal({required int dx, bool reverse = false}) {
    if (!isMerged) {
      return this;
    }
    int updatedDx = reverse ? dx - width : dx;
    return CellMergeStatus.merged(
      start: start!.move(dx: updatedDx, dy: 0),
      end: end!.move(dx: updatedDx, dy: 0),
    );
  }
}

class RowConfig with EquatableMixin {
  const RowConfig({
    this.height = 21,
    this.customHeight,
    this.pinned = false,
  });

  final double height;
  final double? customHeight;
  final bool pinned;

  RowConfig copyWith({
    double? height,
    double? customHeight,
    bool? pinned,
  }) {
    return RowConfig(
      height: height ?? this.height,
      customHeight: customHeight ?? this.customHeight,
      pinned: pinned ?? this.pinned,
    );
  }

  @override
  List<Object?> get props => <Object?>[height, customHeight, pinned];
}

class ColumnConfig with EquatableMixin {
  const ColumnConfig({
    this.width = 100,
    this.customWidth,
    this.pinned = false,
  });

  final double width;
  final double? customWidth;
  final bool pinned;

  ColumnConfig copyWith({
    double? width,
    double? customWidth,
    bool? pinned,
  }) {
    return ColumnConfig(
      width: width ?? this.width,
      customWidth: customWidth ?? this.customWidth,
      pinned: pinned ?? this.pinned,
    );
  }

  @override
  List<Object?> get props => <Object?>[width, customWidth, pinned];
}

class CellConfig {
  CellConfig({
    CellStyle? style,
    SheetRichText? value,
    this.mergeStatus = const CellMergeStatus.noMerge(),
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
    this.mergeStatus = const CellMergeStatus.noMerge(),
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

  CellIndex get startIndex => mergeStatus.start ?? index;

  CellIndex get endIndex => mergeStatus.end ?? index;

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

class FirstVisibleColumnInfo with EquatableMixin {
  const FirstVisibleColumnInfo({
    required this.index,
    required this.startCoordinate,
    required this.visibleWidth,
    required this.hiddenWidth,
  });

  final ColumnIndex index;
  final double startCoordinate;
  final double visibleWidth;
  final double hiddenWidth;

  @override
  List<Object?> get props => <Object?>[index, startCoordinate, visibleWidth, hiddenWidth];
}

class FirstVisibleRowInfo with EquatableMixin {
  const FirstVisibleRowInfo({
    required this.index,
    required this.startCoordinate,
    required this.visibleHeight,
    required this.hiddenHeight,
  });

  final RowIndex index;
  final double startCoordinate;
  final double visibleHeight;
  final double hiddenHeight;

  @override
  List<Object?> get props => <Object?>[index, startCoordinate, visibleHeight, hiddenHeight];
}

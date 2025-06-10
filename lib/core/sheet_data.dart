import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/utils/text_rotation.dart';

class ColumnsProperties {
  ColumnsProperties([Map<ColumnIndex, ColumnStyle>? styles]) {
    this.styles = styles ?? <ColumnIndex, ColumnStyle>{};
  }

  late final Map<ColumnIndex, ColumnStyle> styles;

  ColumnStyle get(ColumnIndex columnIndex) {
    return styles[columnIndex] ?? ColumnStyle.defaults();
  }

  double getWidth(ColumnIndex columnIndex) {
    return styles[columnIndex]?.width ?? defaultColumnWidth;
  }

  void set(ColumnIndex columnIndex, ColumnStyle columnStyle) {
    styles[columnIndex] = columnStyle;
  }

  void setWidth(ColumnIndex columnIndex, double width) {
    ColumnStyle previousColumnStyle = get(columnIndex);
    ColumnStyle updatedColumnStyle = previousColumnStyle.copyWith(width: width);
    set(columnIndex, updatedColumnStyle);
  }
}

class RowsProperties {
  RowsProperties([Map<RowIndex, RowStyle>? styles]) {
    this.styles = styles ?? <RowIndex, RowStyle>{};
  }

  late final Map<RowIndex, RowStyle> styles;

  RowStyle get(RowIndex rowIndex) {
    return styles[rowIndex] ?? RowStyle.defaults();
  }

  double getHeight(RowIndex rowIndex) {
    return styles[rowIndex]?.height ?? defaultRowHeight;
  }

  void set(RowIndex rowIndex, RowStyle rowStyle) {
    styles[rowIndex] = rowStyle;
  }

  void setHeight(RowIndex rowIndex, double height, {bool keepValue = false}) {
    RowStyle previousRowStyle = get(rowIndex);
    RowStyle updatedRowStyle = previousRowStyle.copyWith(height: height, customHeight: keepValue ? height : null);
    set(rowIndex, updatedRowStyle);
  }
}

class CellsProperties {
  CellsProperties([Map<CellIndex, CellProperties>? data]) {
    this.data = data ?? <CellIndex, CellProperties>{};
  }

  late final Map<CellIndex, CellProperties> data;

  CellProperties get(CellIndex cellIndex) {
    CellIndex updatedIndex = cellIndex;
    if (cellIndex is MergedCellIndex) {
      updatedIndex = cellIndex.start;
    }
    return data[updatedIndex] ?? CellProperties();
  }

  Map<CellIndex, CellProperties> getAll(List<CellIndex> cellIndexes) {
    return Map<CellIndex, CellProperties>.fromEntries(cellIndexes.map((CellIndex cellIndex) {
      return MapEntry<CellIndex, CellProperties>(cellIndex, get(cellIndex));
    }));
  }

  List<CellProperties> getByRowRange(ColumnIndex column, RowIndex start, RowIndex end) {
    List<CellProperties> cellProperties = <CellProperties>[];
    for (int i = start.value; i <= end.value; i++) {
      cellProperties.add(get(CellIndex(row: RowIndex(i), column: column)));
    }
    return cellProperties;
  }

  List<CellProperties> getByColumnRange(RowIndex row, ColumnIndex start, ColumnIndex end) {
    List<CellProperties> cellProperties = <CellProperties>[];
    for (int i = start.value; i <= end.value; i++) {
      cellProperties.add(get(CellIndex(row: row, column: ColumnIndex(i))));
    }
    return cellProperties;
  }

  void set(CellIndex index, CellProperties properties) {
    data[index] = properties;
  }

  void setAll(List<IndexedCellProperties> properties) {
    for (IndexedCellProperties entry in properties) {
      set(entry.index, entry.properties);
    }
  }

  void setStyle(CellIndex cellIndex, CellStyle newCellStyle) {
    CellProperties previousCellProperties = get(cellIndex);
    CellProperties updatedCellProperties = previousCellProperties.copyWith(style: newCellStyle);
    set(cellIndex, updatedCellProperties);
  }

  void setText(CellIndex cellIndex, SheetRichText text) {
    CellProperties previousCellProperties = get(cellIndex);
    CellProperties updatedCellProperties = previousCellProperties.copyWith(value: text);
    set(cellIndex, updatedCellProperties);
  }

  void clear(CellIndex cellIndex) {
    CellProperties previousCellProperties = get(cellIndex);
    CellProperties updatedCellProperties = previousCellProperties.copyWith(
      value: previousCellProperties.value.clear(),
    );
    set(cellIndex, updatedCellProperties);
  }

  void clearAll(List<CellIndex> cells) {
    cells.forEach(clear);
  }

  void setMergeStatus(CellMergeStatus mergeStatus) {
    for (CellIndex cellIndex in mergeStatus.mergedCells) {
      CellProperties previousCellProperties = get(cellIndex);
      CellMergeStatus previousMergeStatus = previousCellProperties.mergeStatus;
      if (previousMergeStatus is MergedCell) {
        unmerge(cellIndex);
      }
      CellProperties updatedCellProperties = previousCellProperties.copyWith(mergeStatus: mergeStatus);
      set(cellIndex, updatedCellProperties);
    }
  }

  void merge(List<CellIndex> cells, {CellStyle? style}) {
    if (cells.length < 2) {
      return;
    }

    CellIndex start = cells.first;
    CellIndex end = cells.last;

    cells.forEach(unmerge);

    CellProperties mainCellProperties = get(start);
    for (CellIndex cellIndex in cells) {
      data[cellIndex] = mainCellProperties.copyWith(
        mergeStatus: MergedCell(start: start, end: end),
        style: style ?? mainCellProperties.style,
      );
    }
  }

  void unmerge(CellIndex cellIndex) {
    CellProperties cellProperties = get(cellIndex);
    CellMergeStatus mergeStatus = cellProperties.mergeStatus;
    if (mergeStatus is MergedCell) {
      CellProperties mergeCellProperties = get(mergeStatus.start);
      for (CellIndex index in mergeStatus.mergedCells) {
        set(index, mergeCellProperties.copyWith(mergeStatus: NoCellMerge()));
      }
    }
  }

  void unmergeAll(List<CellIndex> cells) {
    cells.forEach(unmerge);
  }
}

class WorksheetData {
  WorksheetData({
    required this.columnCount,
    required this.rowCount,
    RowsProperties? rows,
    ColumnsProperties? columns,
    CellsProperties? cells,
    this.pinnedColumnCount = 0,
    this.pinnedRowCount = 0,
  }) {
    this.rows = rows ?? RowsProperties();
    this.columns = columns ?? ColumnsProperties();
    this.cells = cells ?? CellsProperties();

    _recalculateContentSize();
  }

  WorksheetData.dev() : this(columnCount: 100, rowCount: 100);

  late final RowsProperties rows;
  late final ColumnsProperties columns;
  late final CellsProperties cells;

  int columnCount;
  int rowCount;

  int pinnedColumnCount;
  int pinnedRowCount;

  double _contentWidth = 0;
  double _contentHeight = 0;

  List<T> fillCellIndexes<T extends SheetIndex>(List<T> sheetIndexes) {
    return sheetIndexes.map(fillCellIndex).toList();
  }

  T fillCellIndex<T extends SheetIndex>(T sheetIndex) {
    if (sheetIndex is! CellIndex) {
      return sheetIndex;
    }
    CellMergeStatus mergeStatus = cells.get(sheetIndex).mergeStatus;
    if (mergeStatus is MergedCell) {
      return MergedCellIndex(start: mergeStatus.start, end: mergeStatus.end) as T;
    } else {
      return sheetIndex;
    }
  }

  void _recalculateContentSize() {
    _recalculateContentWidth();
    _recalculateContentHeight();
  }

  void _recalculateContentWidth() {
    double contentWidth = 0;
    for (int i = 0; i < columnCount; i++) {
      double columnWidth = columns.getWidth(ColumnIndex(i));
      contentWidth += columnWidth + borderWidth;
    }
    contentWidth -= borderWidth; // First column left border is not visible
    _contentWidth = contentWidth;
  }

  void _recalculateContentHeight() {
    double contentHeight = 0;
    for (int i = 0; i < rowCount; i++) {
      double rowHeight = rows.getHeight(RowIndex(i));
      contentHeight += rowHeight + borderWidth;
    }
    contentHeight -= borderWidth; // First row top border is not visible
    _contentHeight = contentHeight;
  }

  void formatSelection(List<CellIndex> cellIndexes, StyleFormatAction<StyleFormatIntent> formatAction) {
    for (CellIndex cellIndex in cellIndexes) {
      switch (formatAction) {
        case TextStyleFormatAction<TextStyleFormatIntent> formatAction:
          CellProperties cellProperties = cells.get(cellIndex);
          cells.setText(cellIndex, cellProperties.value.updateStyle(formatAction));
        case CellStyleFormatAction<CellStyleFormatIntent> formatAction:
          CellProperties cellProperties = cells.get(cellIndex);
          cells.setStyle(cellIndex, formatAction.format(cellProperties.style));
        case SheetStyleFormatAction<SheetStyleFormatIntent> formatAction:
          formatAction.format(this);
      }
      adjustCellHeight(cellIndex);
    }
  }

  Size getCellSize(CellIndex cellIndex) {
    double height = rows.getHeight(cellIndex.row);
    double width = columns.getWidth(cellIndex.column);
    return Size(width, height);
  }

  void setCellSize(CellIndex cellIndex, double height, double width) {
    rows.setHeight(cellIndex.row, height);
    columns.setWidth(cellIndex.column, width);
  }

  void adjustCellHeight(CellIndex cellIndex) {
    double minRowHeight = getMinRowHeight(cellIndex.row);
    rows.setHeight(cellIndex.row, minRowHeight);
  }

  double getMinRowHeight(RowIndex rowIndex) {
    List<CellIndex> cellIndexes = cells.data.keys.where((CellIndex cellIndex) => cellIndex.row == rowIndex).toList();
    if (cellIndexes.isEmpty) {
      cellIndexes.add(CellIndex(row: rowIndex, column: ColumnIndex(0)));
    }

    double? staticHeight = rows.get(rowIndex).customHeight;
    double minRowHeight = cellIndexes.map(getMinCellSize).map((Size size) => size.height).reduce(max);

    if (staticHeight != null) {
      return max(minRowHeight, staticHeight);
    } else {
      return minRowHeight;
    }
  }

  Size getMinCellSize(CellIndex cellIndex) {
    CellProperties cellProperties = cells.get(cellIndex);

    // TODO(Dominik): Magic padding. No idea where it comes from. Should be analyzed and removed.
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 3, vertical: 2);

    if (cellProperties.value.isEmpty) {
      double height = rows.getHeight(cellIndex.row);
      double width = columns.getWidth(cellIndex.column);
      return Size(width, height);
    }

    TextRotation textRotation = cellProperties.style.rotation;
    TextSpan textSpan = cellProperties.value.toTextSpan();
    if (textRotation == TextRotation.vertical) {
      textSpan = textSpan.applyDivider('\n');
    }

    TextPainter painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: cellProperties.visibleTextAlign,
    )..layout();

    double textWidth = painter.width;
    double textHeight = painter.height;

    double minCellWidth;
    double minCellHeight;

    double angle = textRotation.angle;

    if (textRotation == TextRotation.vertical) {
      // Vertical text
      minCellWidth = textWidth + padding.horizontal;
      minCellHeight = textHeight + padding.vertical;
    } else if (angle != 0) {
      double radians = angle * pi / 180;
      double sinValue = sin(radians).abs();
      double cosValue = cos(radians).abs();

      // Calculate the rotated bounding box size
      double rotatedWidth = textWidth * cosValue + textHeight * sinValue;
      double rotatedHeight = textWidth * sinValue + textHeight * cosValue;

      // Add padding to the rotated dimensions
      minCellWidth = rotatedWidth + padding.horizontal;
      minCellHeight = rotatedHeight + padding.vertical;
    } else {
      // No rotation, add padding to the text size
      minCellWidth = textWidth + padding.horizontal;
      minCellHeight = textHeight + padding.vertical;
    }

    return Size(
      minCellWidth.clamp(defaultColumnWidth, double.infinity),
      minCellHeight.clamp(defaultRowHeight, double.infinity),
    );
  }

  double get contentWidth => _contentWidth;

  double get contentHeight => _contentHeight;

  Size get contentSize => Size(contentWidth, contentHeight);

  double get pinnedColumnsWidth {
    double width = 0;
    for (int i = 0; i < pinnedColumnCount && i < columnCount; i++) {
      width += columns.getWidth(ColumnIndex(i)) + borderWidth;
    }
    if (width > 0) {
      width -= borderWidth;
    }
    return width;
  }

  double get pinnedRowsHeight {
    double height = 0;
    for (int i = 0; i < pinnedRowCount && i < rowCount; i++) {
      height += rows.getHeight(RowIndex(i)) + borderWidth;
    }
    if (height > 0) {
      height -= borderWidth;
    }
    return height;
  }

  Size get scrollableContentSize =>
      Size(contentWidth - pinnedColumnsWidth, contentHeight - pinnedRowsHeight);
}

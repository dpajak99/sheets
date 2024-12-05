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

class SheetData {
  SheetData({
    required this.columnCount,
    required this.rowCount,
    Map<ColumnIndex, ColumnStyle>? customColumnStyles,
    Map<RowIndex, RowStyle>? customRowStyles,
    Map<CellIndex, CellProperties>? data,
  })  : _customRowStyles = customRowStyles ?? <RowIndex, RowStyle>{},
        _customColumnStyles = customColumnStyles ?? <ColumnIndex, ColumnStyle>{},
        _data = data ?? <CellIndex, CellProperties>{} {
    _recalculateContentSize();
  }

  SheetData.dev() : this(columnCount: 100, rowCount: 100);

  final Map<ColumnIndex, ColumnStyle> _customColumnStyles;
  final Map<RowIndex, RowStyle> _customRowStyles;
  final Map<CellIndex, CellProperties> _data;

  int columnCount;
  int rowCount;

  double _contentWidth = 0;
  double _contentHeight = 0;

  List<T> fillCellIndexes<T extends SheetIndex>(List<T> sheetIndexes) {
    return sheetIndexes.map(fillCellIndex).toList();
  }

  T fillCellIndex<T extends SheetIndex>(T sheetIndex) {
    if (sheetIndex is! CellIndex) {
      return sheetIndex;
    }
    CellMergeStatus mergeStatus = getCellProperties(sheetIndex).mergeStatus;
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
      double columnWidth = getColumnWidth(ColumnIndex(i));
      contentWidth += columnWidth + borderWidth;
    }
    contentWidth -= borderWidth; // First column left border is not visible
    _contentWidth = contentWidth;
  }

  void _recalculateContentHeight() {
    double contentHeight = 0;
    for (int i = 0; i < rowCount; i++) {
      double rowHeight = getRowHeight(RowIndex(i));
      contentHeight += rowHeight + borderWidth;
    }
    contentHeight -= borderWidth; // First row top border is not visible
    _contentHeight = contentHeight;
  }

  CellProperties getCellProperties(CellIndex cellIndex) {
    CellIndex updatedIndex = cellIndex;
    if (cellIndex is MergedCellIndex) {
      updatedIndex = cellIndex.start;
    }
    return _data[updatedIndex] ?? CellProperties();
  }

  double getColumnWidth(ColumnIndex columnIndex) {
    return getColumnStyle(columnIndex).width;
  }

  RowStyle getRowStyle(RowIndex rowIndex) {
    return _customRowStyles[rowIndex] ?? RowStyle.defaults();
  }

  double getRowHeight(RowIndex rowIndex) {
    return getRowStyle(rowIndex).height;
  }

  ColumnStyle getColumnStyle(ColumnIndex columnIndex) {
    return _customColumnStyles[columnIndex] ?? ColumnStyle.defaults();
  }

  void unmergeCells(List<CellIndex> cells) {
    cells.forEach(unmergeCell);
  }

  void unmergeCell(CellIndex cellIndex) {
    CellProperties cellProperties = getCellProperties(cellIndex);
    CellMergeStatus mergeStatus = cellProperties.mergeStatus;
    if (mergeStatus is MergedCell) {
      CellProperties mergeCellProperties = getCellProperties(mergeStatus.start);
      for(CellIndex index in mergeStatus.mergedCells) {
        _data[index] = mergeCellProperties.copyWith(
          mergeStatus: NoCellMerge(),
        );
      }
    }
  }

  void mergeCells(List<CellIndex> cells, {CellStyle? style}) {
    if (cells.length < 2) {
      return;
    }

    CellIndex start = cells.first;
    CellIndex end = cells.last;

    cells.forEach(unmergeCell);

    CellProperties mainCellProperties = getCellProperties(start);
    for (CellIndex cellIndex in cells) {
      _data[cellIndex] = mainCellProperties.copyWith(
        mergeStatus: MergedCell(start: start, end: end),
        style: style ?? mainCellProperties.style,
      );
    }
  }

  void formatSelection(List<CellIndex> cells, StyleFormatAction<StyleFormatIntent> formatAction) {
    for (CellIndex cellIndex in cells) {
      _data[cellIndex] ??= CellProperties();

      switch (formatAction) {
        case TextStyleFormatAction<TextStyleFormatIntent> formatAction:
          CellProperties cellProperties = _data[cellIndex]!;
          _data[cellIndex] = cellProperties.copyWith(value: cellProperties.value.updateStyle(formatAction));
        case CellStyleFormatAction<CellStyleFormatIntent> formatAction:
          CellProperties cellProperties = _data[cellIndex]!;
          _data[cellIndex] = cellProperties.copyWith(style: formatAction.format(_data[cellIndex]!.style));
        case SheetStyleFormatAction<SheetStyleFormatIntent> formatAction:
          formatAction.format(this);
      }
      adjustCellHeight(cellIndex);
    }
  }

  void setText(CellIndex cellIndex, SheetRichText text) {
    CellProperties cellProperties = _data[cellIndex] ?? CellProperties();
    _data[cellIndex] = cellProperties.copyWith(value: text);
  }

  void setCellsProperties(List<IndexedCellProperties> properties) {
    for (IndexedCellProperties entry in properties) {
      setCellProperties(entry.index, entry.properties);
    }
  }

  void setCellProperties(CellIndex index, CellProperties properties) {
    _data[index] = properties;
  }

  Size getCellSize(CellIndex cellIndex) {
    double height = getRowStyle(cellIndex.row).height;
    double width = getColumnStyle(cellIndex.column).width;
    return Size(width, height);
  }

  void setCellSize(CellIndex cellIndex, double height, double width) {
    setRowHeight(cellIndex.row, height);
    setColumnWidth(cellIndex.column, width);
  }

  void setCellStyle(CellIndex cellIndex, CellStyle cellStyle) {
    _data[cellIndex] ??= CellProperties();
    _data[cellIndex] = _data[cellIndex]!.copyWith(style: cellStyle);
  }

  void setRowHeight(RowIndex rowIndex, double height, {bool keepValue = false}) {
    RowStyle previousRowStyle = getRowStyle(rowIndex);
    RowStyle updatedRowStyle = previousRowStyle.copyWith(height: height, customHeight: keepValue ? height : null);
    _customRowStyles[rowIndex] = updatedRowStyle;

    if (previousRowStyle.height != updatedRowStyle.height) {
      _recalculateContentHeight();
    }
  }

  void setColumnWidth(ColumnIndex columnIndex, double width) {
    ColumnStyle previousColumnStyle = getColumnStyle(columnIndex);
    ColumnStyle updatedColumnStyle = previousColumnStyle.copyWith(width: width);
    _customColumnStyles[columnIndex] = updatedColumnStyle;

    if (previousColumnStyle.width != updatedColumnStyle.width) {
      _recalculateContentWidth();
    }
  }

  void clearCells(List<CellIndex> cells) {
    cells.forEach(clearCell);
  }

  void clearCell(CellIndex cellIndex) {
    _data[cellIndex] ??= CellProperties();
    _data[cellIndex] = _data[cellIndex]!.copyWith(value: _data[cellIndex]!.value.clear());
  }

  void adjustCellHeight(CellIndex cellIndex) {
    double minRowHeight = getMinRowHeight(cellIndex.row);
    setRowHeight(cellIndex.row, minRowHeight);
  }

  double getMinRowHeight(RowIndex rowIndex) {
    List<CellIndex> cellIndexes = _data.keys.where((CellIndex cellIndex) => cellIndex.row == rowIndex).toList();

    double? staticHeight = getRowStyle(rowIndex).customHeight;
    double minRowHeight = cellIndexes.map(getMinCellSize).map((Size size) => size.height).reduce(max);

    if (staticHeight != null) {
      return max(minRowHeight, staticHeight);
    } else {
      return minRowHeight;
    }
  }

  Size getMinCellSize(CellIndex cellIndex) {
    CellProperties cellProperties = getCellProperties(cellIndex);

    // TODO(Dominik): Magic padding. No idea where it comes from. Should be analyzed and removed.
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 3.5);

    if (cellProperties.value.isEmpty) {
      double height = getRowStyle(cellIndex.row).height;
      double width = getColumnStyle(cellIndex.column).width;
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
    );

    // Set a reasonable maxWidth for the text layout
    // You can use a default column width or a predefined maximum width
    double maxTextWidth = getColumnStyle(cellIndex.column).width - padding.horizontal;
    painter.layout(maxWidth: maxTextWidth);

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

    return Size(minCellWidth, minCellHeight);
  }

  double get contentWidth => _contentWidth;

  double get contentHeight => _contentHeight;

  Size get contentSize => Size(contentWidth, contentHeight);

  Map<CellIndex, CellProperties> getMultiCellProperties(List<CellIndex> cellIndexes) {
    return Map<CellIndex, CellProperties>.fromEntries(cellIndexes.map((CellIndex cellIndex) {
      return MapEntry<CellIndex, CellProperties>(cellIndex, getCellProperties(cellIndex));
    }));
  }

  List<CellProperties> getCellPropertiesByRowRange(ColumnIndex column, RowIndex start, RowIndex end) {
    List<CellProperties> cellProperties = <CellProperties>[];
    for (int i = start.value; i <= end.value; i++) {
      cellProperties.add(getCellProperties(CellIndex(row: RowIndex(i), column: column)));
    }
    return cellProperties;
  }

  List<CellProperties> getCellPropertiesByColumnRange(RowIndex row, ColumnIndex start, ColumnIndex end) {
    List<CellProperties> cellProperties = <CellProperties>[];
    for (int i = start.value; i <= end.value; i++) {
      cellProperties.add(getCellProperties(CellIndex(row: row, column: ColumnIndex(i))));
    }
    return cellProperties;
  }
}

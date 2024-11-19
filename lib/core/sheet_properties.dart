import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';

class SheetProperties extends ChangeNotifier {
  SheetProperties({
    Map<ColumnIndex, ColumnStyle>? customColumnStyles,
    Map<RowIndex, RowStyle>? customRowStyles,
    Map<CellIndex, CellProperties>? data,
    this.columnCount = 100,
    this.rowCount = 200,
  })  : _customRowStyles = customRowStyles ?? <RowIndex, RowStyle>{},
        _customColumnStyles = customColumnStyles ?? <ColumnIndex, ColumnStyle>{} {
    this.data = data ?? <CellIndex, CellProperties>{};
  }

  late final Map<CellIndex, CellProperties> data;

  final Map<ColumnIndex, ColumnStyle> _customColumnStyles;

  Map<ColumnIndex, ColumnStyle> get customColumnStyles => _customColumnStyles;

  final Map<RowIndex, RowStyle> _customRowStyles;

  Map<RowIndex, RowStyle> get customRowStyles => _customRowStyles;

  int columnCount;
  int rowCount;

  void formatSelection(List<CellIndex> cells, StyleFormatAction<StyleFormatIntent> formatAction) {
    for (CellIndex cellIndex in cells) {
      data[cellIndex] ??= CellProperties.empty();

      switch (formatAction) {
        case TextStyleFormatAction<TextStyleFormatIntent> formatAction:
          data[cellIndex]!.value = data[cellIndex]!.value.updateStyle(formatAction);
        case CellStyleFormatAction<CellStyleFormatIntent> formatAction:
          data[cellIndex]!.style = formatAction.format(data[cellIndex]!.style);
        case SheetStyleFormatAction<SheetStyleFormatIntent> formatAction:
          formatAction.format(this);
      }
    }
    notifyListeners();
  }

  void setRichText(CellIndex cellIndex, SheetRichText text) {
    data[cellIndex] ??= CellProperties.empty();
    data[cellIndex]!.value = text;
    notifyListeners();
  }

  Map<CellIndex, CellProperties> getMultiCellProperties(List<CellIndex> cellIndexes) {
    return Map<CellIndex, CellProperties>.fromEntries(cellIndexes.map((CellIndex cellIndex) {
      return MapEntry<CellIndex, CellProperties>(cellIndex, getCellProperties(cellIndex));
    }));
  }

  CellProperties getCellProperties(CellIndex cellIndex) {
    return data[cellIndex] ?? CellProperties.empty();
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

  void setCellsProperties(Map<CellIndex, CellProperties> cellProperties) {
    for (MapEntry<CellIndex, CellProperties> entry in cellProperties.entries) {
      data[entry.key] = entry.value;
    }
    notifyListeners();
  }

  void addRows(int count) {
    rowCount += count;
    notifyListeners();
  }

  void addColumns(int count) {
    columnCount += count;
    notifyListeners();
  }

  double getRowHeight(RowIndex rowIndex) {
    return getRowStyle(rowIndex).height;
  }

  double getColumnWidth(ColumnIndex columnIndex) {
    return getColumnStyle(columnIndex).width;
  }

  void setCellSize(CellIndex cellIndex, RowStyle rowStyle, ColumnStyle columnStyle) {
    _customRowStyles[cellIndex.row] = rowStyle;
    _customColumnStyles[cellIndex.column] = columnStyle;
    notifyListeners();
  }

  void setCellStyle(CellIndex cellIndex, CellStyle cellStyle, {bool notify = true}) {
    data[cellIndex] ??= CellProperties.empty();
    data[cellIndex] = data[cellIndex]!.copyWith(style: cellStyle);

    if (notify) {
      notifyListeners();
    }
  }

  void setRowStyle(RowIndex rowIndex, RowStyle rowStyle) {
    _customRowStyles[rowIndex] = rowStyle;
    notifyListeners();
  }

  RowStyle getRowStyle(RowIndex rowIndex) {
    return _customRowStyles[rowIndex] ?? RowStyle.defaults();
  }

  void setColumnStyle(ColumnIndex columnIndex, ColumnStyle columnStyle) {
    _customColumnStyles[columnIndex] = columnStyle;
    notifyListeners();
  }

  void ensureMinimalRowsHeight(List<RowIndex> rows) {
    rows.forEach(adjustRowToMaxFontSize);
  }

  void adjustRowToMaxFontSize(RowIndex rowIndex) {
    double maxHeight = 0;
    for (int i = 0; i < columnCount; i++) {
      CellProperties cellProperties = getCellProperties(CellIndex(row: rowIndex, column: ColumnIndex(i)));
      TextPainter textPainter = TextPainter(text: cellProperties.value.toTextSpan(), textDirection: TextDirection.ltr)..layout();
      maxHeight = max(maxHeight, textPainter.height);
    }
    setRowStyle(rowIndex, RowStyle(height: maxHeight + 5));
    notifyListeners();
  }

  ColumnStyle getColumnStyle(ColumnIndex columnIndex) {
    return _customColumnStyles[columnIndex] ?? ColumnStyle.defaults();
  }

  void clearCells(List<CellIndex> cells) {
    cells.forEach(clearCell);
    notifyListeners();
  }

  void clearCell(CellIndex cellIndex) {
    data[cellIndex] ??= CellProperties.empty();
    data[cellIndex] = data[cellIndex]!.copyWith(value: data[cellIndex]!.value.clear());
  }

  Map<int, double> get customRowExtents {
    return _customRowStyles.map((RowIndex key, RowStyle value) => MapEntry<int, double>(key.value, value.height));
  }

  Map<int, double> get customColumnExtents {
    return _customColumnStyles.map((ColumnIndex key, ColumnStyle value) => MapEntry<int, double>(key.value, value.width));
  }
}

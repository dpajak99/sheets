import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
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
        _data = data ?? <CellIndex, CellProperties>{};

  final Map<ColumnIndex, ColumnStyle> _customColumnStyles;
  final Map<RowIndex, RowStyle> _customRowStyles;
  final Map<CellIndex, CellProperties> _data;

  int columnCount;
  int rowCount;

  CellProperties getCellProperties(CellIndex cellIndex) {
    return _data[cellIndex] ?? CellProperties.empty();
  }

  RowStyle getRowStyle(RowIndex rowIndex) {
    return _customRowStyles[rowIndex] ?? RowStyle.defaults();
  }

  ColumnStyle getColumnStyle(ColumnIndex columnIndex) {
    return _customColumnStyles[columnIndex] ?? ColumnStyle.defaults();
  }

  void formatSelection(List<CellIndex> cells, StyleFormatAction<StyleFormatIntent> formatAction) {
    for (CellIndex cellIndex in cells) {
      _data[cellIndex] ??= CellProperties.empty();

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
    CellProperties cellProperties = _data[cellIndex] ?? CellProperties.empty();
    _data[cellIndex] = cellProperties.copyWith(value: text);
  }

  void setCellsProperties(List<IndexedCellProperties> properties) {
    for (IndexedCellProperties entry in properties) {
      _data[entry.index] = entry.properties;
    }
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
    _data[cellIndex] ??= CellProperties.empty();
    _data[cellIndex] = _data[cellIndex]!.copyWith(style: cellStyle);
  }

  void setRowHeight(RowIndex rowIndex, double height) {
    _customRowStyles[rowIndex] ??= RowStyle.defaults();
    _customRowStyles[rowIndex] = _customRowStyles[rowIndex]!.copyWith(height: height);
  }

  void setColumnWidth(ColumnIndex columnIndex, double width) {
    _customColumnStyles[columnIndex] ??= ColumnStyle.defaults();
    _customColumnStyles[columnIndex] = _customColumnStyles[columnIndex]!.copyWith(width: width);
  }

  void clearCells(List<CellIndex> cells) {
    cells.forEach(clearCell);
  }

  void clearCell(CellIndex cellIndex) {
    _data[cellIndex] ??= CellProperties.empty();
    _data[cellIndex] = _data[cellIndex]!.copyWith(value: _data[cellIndex]!.value.clear());
  }

  void adjustCellHeight(CellIndex cellIndex) {
    double minRowHeight = getMinRowHeight(cellIndex.row);
    setRowHeight(cellIndex.row, minRowHeight);
  }

  double getMinRowHeight(RowIndex rowIndex) {
    List<CellIndex> cellIndexes = _data.keys.where((CellIndex cellIndex) => cellIndex.row == rowIndex).toList();
    double minRowHeight = cellIndexes.map(getMinCellSize).map((Size size) => size.height).reduce(max);
    return minRowHeight;
  }

  Size getMinCellSize(CellIndex cellIndex) {
    CellProperties cellProperties = getCellProperties(cellIndex);

    // Get the padding from the cell style or default to EdgeInsets.zero
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 3);

    if (cellProperties.value.isEmpty) {
      double height = getRowStyle(cellIndex.row).height;
      double width = getColumnStyle(cellIndex.column).width;
      return Size(width, height);
    }

    TextRotation textRotation = cellProperties.style.rotation;
    TextSpan textSpan = cellProperties.value.toTextSpan();
    if(textRotation == TextRotation.vertical) {
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

    if(textRotation == TextRotation.vertical) {
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

}

class SheetDataManager extends ChangeNotifier {
  SheetDataManager({
    required SheetData data,
  }) : _data = data;

  SheetDataManager.dev() {
    _data = SheetData(columnCount: 200, rowCount: 100, data: <CellIndex, CellProperties>{
      CellIndex.raw(5, 5): CellProperties(value: SheetRichText.single(text: '1'), style: CellStyle()),
    });
  }

  late final SheetData _data;

  void write(void Function(SheetData data) action) {
    action(_data);
    notifyListeners();
  }

  int get columnCount => _data.columnCount;

  int get rowCount => _data.rowCount;

  RowStyle getRowStyle(RowIndex rowIndex) {
    return _data.getRowStyle(rowIndex);
  }

  ColumnStyle getColumnStyle(ColumnIndex columnIndex) {
    return _data.getColumnStyle(columnIndex);
  }

  double getRowHeight(RowIndex rowIndex) {
    return getRowStyle(rowIndex).height;
  }

  double getColumnWidth(ColumnIndex columnIndex) {
    return getColumnStyle(columnIndex).width;
  }

  Map<CellIndex, CellProperties> getMultiCellProperties(List<CellIndex> cellIndexes) {
    return Map<CellIndex, CellProperties>.fromEntries(cellIndexes.map((CellIndex cellIndex) {
      return MapEntry<CellIndex, CellProperties>(cellIndex, getCellProperties(cellIndex));
    }));
  }

  CellProperties getCellProperties(CellIndex cellIndex) {
    return _data.getCellProperties(cellIndex);
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

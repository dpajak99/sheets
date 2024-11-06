import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/cell_value.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class SheetProperties extends ChangeNotifier {
  SheetProperties({
    Map<ColumnIndex, ColumnStyle>? customColumnStyles,
    Map<RowIndex, RowStyle>? customRowStyles,
    Map<CellIndex, MainSheetTextSpan>? data,
    this.columnCount = 100,
    this.rowCount = 100,
  })  : _customRowStyles = customRowStyles ?? <RowIndex, RowStyle>{},
        _customColumnStyles = customColumnStyles ?? <ColumnIndex, ColumnStyle>{} {
    this.data = data ??
        <CellIndex, MainSheetTextSpan>{
          CellIndex.raw(0, 0): MainSheetTextSpan(text: '1'),
          CellIndex.raw(0, 1): MainSheetTextSpan(text: '1.1'),
          CellIndex.raw(0, 2): MainSheetTextSpan(text: '3'),
          //
          CellIndex.raw(1, 0): MainSheetTextSpan(text: '2'),
          CellIndex.raw(1, 1): MainSheetTextSpan(text: '2.2'),
          CellIndex.raw(1, 2): MainSheetTextSpan(text: '2'),
          //
          CellIndex.raw(2, 0): MainSheetTextSpan(text: '3'),
          CellIndex.raw(2, 1): MainSheetTextSpan(text: '3.3'),
          CellIndex.raw(2, 2): MainSheetTextSpan(text: '1'),
          //
          CellIndex.raw(10, 5): MainSheetTextSpan(
            text: 'w',
            children: <SheetTextSpan>[
              SheetTextSpan(text: 'a'),
              SheetTextSpan(text: 'bff', style: const TextStyle(fontWeight: FontWeight.bold)),
              SheetTextSpan(text: 'cvv', style: const TextStyle(color: Colors.red)),
              SheetTextSpan(text: 'd'),
              SheetTextSpan(text: 'ffe', style: const TextStyle(fontSize: 14)),
            ],
          ),
        };
  }

  late final Map<CellIndex, MainSheetTextSpan> data;

  final Map<ColumnIndex, ColumnStyle> _customColumnStyles;

  Map<ColumnIndex, ColumnStyle> get customColumnStyles => _customColumnStyles;

  final Map<RowIndex, RowStyle> _customRowStyles;

  Map<RowIndex, RowStyle> get customRowStyles => _customRowStyles;

  int columnCount;
  int rowCount;

  void setCellText(CellIndex cellIndex, String text) {
    data[cellIndex] = getCellText(cellIndex).withText(text);
    notifyListeners();
  }

  void setCellsProperties(List<CellProperties> cellProperties) {
    for (CellProperties cellProperty in cellProperties) {
      data[cellProperty.index] = cellProperty.value.span;
    }
    notifyListeners();
  }

  MainSheetTextSpan getCellText(CellIndex cellIndex) {
    return data[cellIndex] ?? MainSheetTextSpan.empty();
  }

  CellProperties getCellProperties(CellIndex cellIndex) {
    return CellProperties(
      cellIndex,
      CellValueParser.parse(getCellText(cellIndex)),
    );
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

  void setCellStyle(CellIndex cellIndex, RowStyle rowStyle, ColumnStyle columnStyle) {
    _customRowStyles[cellIndex.row] = rowStyle;
    _customColumnStyles[cellIndex.column] = columnStyle;
    notifyListeners();
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

  ColumnStyle getColumnStyle(ColumnIndex columnIndex) {
    return _customColumnStyles[columnIndex] ?? ColumnStyle.defaults();
  }

  Map<int, double> get customRowExtents {
    return _customRowStyles.map((RowIndex key, RowStyle value) => MapEntry<int, double>(key.value, value.height));
  }

  Map<int, double> get customColumnExtents {
    return _customColumnStyles.map((ColumnIndex key, ColumnStyle value) => MapEntry<int, double>(key.value, value.width));
  }
}

class ColumnStyle with EquatableMixin {
  ColumnStyle({
    required this.width,
  });

  ColumnStyle.defaults() : width = defaultColumnWidth;
  final double width;

  ColumnStyle copyWith({
    double? width,
  }) {
    return ColumnStyle(
      width: width ?? this.width,
    );
  }

  @override
  List<Object?> get props => <Object?>[width];
}

class RowStyle with EquatableMixin {
  RowStyle({
    required this.height,
  });

  RowStyle.defaults() : height = defaultRowHeight;
  final double height;

  RowStyle copyWith({
    double? height,
  }) {
    return RowStyle(
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => <Object?>[height];
}

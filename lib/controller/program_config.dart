import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/style.dart';

abstract class SheetItemConfig with EquatableMixin {
  final Rect rect;

  SheetItemConfig({
    required this.rect,
  });

  String get value;
}

class RowConfig extends SheetItemConfig {
  final RowIndex rowIndex;
  final RowStyle rowStyle;

  RowConfig({
    required super.rect,
    required this.rowIndex,
    required this.rowStyle,
  });

  @override
  String toString() {
    return 'Row(${rowIndex.value})';
  }

  @override
  String get value {
    return '${rowIndex.value + 1}';
  }

  @override
  List<Object?> get props => [rowIndex, rowStyle, rect];
}

class ColumnConfig extends SheetItemConfig {
  final ColumnIndex columnIndex;
  final ColumnStyle columnStyle;

  ColumnConfig({
    required super.rect,
    required this.columnIndex,
    required this.columnStyle,
  });

  @override
  String toString() {
    return 'Column(${columnIndex.value})';
  }

  @override
  String get value {
    return numberToExcelColumn(columnIndex.value + 1);
  }

  String numberToExcelColumn(int number) {
    String result = '';

    while (number > 0) {
      number--; // Excel columns start from 1, not 0, hence this adjustment
      result = String.fromCharCode(65 + (number % 26)) + result;
      number = (number ~/ 26);
    }

    return result;
  }

  @override
  List<Object?> get props => [columnIndex, columnStyle, rect];
}

class CellConfig extends SheetItemConfig {
  final CellIndex index;
  final RowConfig rowConfig;
  final ColumnConfig columnConfig;
  final String _value;

  CellConfig({
    required super.rect,
    required this.index,
    required this.rowConfig,
    required this.columnConfig,
    required String value,
  }) : _value = value;

  CellConfig.fromColumnRow(this.columnConfig, this.rowConfig, {required String value})
      : _value = value, index = CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: columnConfig.columnIndex),
        super(
          rect: Rect.fromLTWH(
            columnConfig.rect.left,
            rowConfig.rect.top,
            columnConfig.rect.width,
            rowConfig.rect.height,
          ),
        );

  @override
  String get value {
    return _value.isEmpty ? '${columnConfig.value}${rowConfig.value}' : _value;
  }

  @override
  List<Object?> get props => [rowConfig, columnConfig];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/style.dart';

abstract class SheetItemConfig with EquatableMixin {
  final Rect rect;

  SheetItemConfig({
    required this.rect,
  });
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
  List<Object?> get props => [columnIndex, columnStyle, rect];
}

class CellConfig extends SheetItemConfig {
  final CellIndex cellIndex;
  final RowConfig rowConfig;
  final ColumnConfig columnConfig;

  CellConfig({
    required super.rect,
    required this.cellIndex,
    required this.rowConfig,
    required this.columnConfig,
  });

  CellConfig.fromColumnRow(this.columnConfig, this.rowConfig)
      : cellIndex = CellIndex(rowIndex: rowConfig.rowIndex, columnIndex: columnConfig.columnIndex),
        super(
          rect: Rect.fromLTWH(
            columnConfig.rect.left,
            rowConfig.rect.top,
            columnConfig.rect.width,
            rowConfig.rect.height,
          ),
        );

  @override
  String toString() {
    return 'Cell(${cellIndex.rowIndex.value}, ${cellIndex.columnIndex.value})';
  }

  @override
  List<Object?> get props => [rowConfig, columnConfig];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/values/cell_value.dart';

abstract class ViewportItem with EquatableMixin {
  ViewportItem({
    required this.rect,
  });

  final Rect rect;

  SheetIndex get index;

  Rect getSheetRect(Offset scrollOffset) {
    return Rect.fromLTWH(
      rect.left + scrollOffset.dx,
      rect.top + scrollOffset.dy,
      rect.width,
      rect.height,
    );
  }
}

class ViewportRow extends ViewportItem {
  ViewportRow({
    required super.rect,
    required RowIndex index,
    required RowStyle style,
  })
      : _index = index,
        _style = style;

  final RowIndex _index;
  final RowStyle _style;

  String get value => '${_index.value + 1}';

  @override
  RowIndex get index => _index;

  RowStyle get style => _style;

  @override
  List<Object?> get props => <Object?>[_index, _style, rect];
}

class ViewportColumn extends ViewportItem {
  ViewportColumn({
    required super.rect,
    required ColumnIndex index,
    required ColumnStyle style,
  })
      : _index = index,
        _style = style;

  final ColumnIndex _index;
  final ColumnStyle _style;

  String get value {
    return numberToExcelColumn(_index.value + 1);
  }

  @override
  ColumnIndex get index => _index;

  ColumnStyle get style => _style;

  String numberToExcelColumn(int number) {
    String result = '';

    int parsedNumber = number;
    while (parsedNumber > 0) {
      parsedNumber--; // Excel columns start from 1, not 0, hence this adjustment
      result = String.fromCharCode(65 + (parsedNumber % 26)) + result;
      parsedNumber = parsedNumber ~/ 26;
    }

    return result;
  }

  @override
  List<Object?> get props => <Object?>[_index, _style, rect];
}

class ViewportCell extends ViewportItem {
  factory ViewportCell({
    required CellIndex index,
    required ViewportRow row,
    required ViewportColumn column,
    required CellProperties properties,
  }) {
    return ViewportCell._(
      rect: Rect.fromLTWH(column.rect.left, row.rect.top, column.rect.width, row.rect.height),
      index: index,
      row: row,
      column: column,
      properties: properties,
    );
  }

  ViewportCell._({
    required super.rect,
    required CellIndex index,
    required ViewportRow row,
    required ViewportColumn column,
    required CellProperties properties,
  })
      : _index = index,
        _row = row,
        _column = column,
        _properties = properties;

  ViewportCell copyWith({
    Rect? rect,
    CellIndex? index,
    ViewportRow? row,
    ViewportColumn? column,
    CellProperties? properties,
  }) {
    return ViewportCell._(
      rect: rect ?? this.rect,
      index: index ?? _index,
      row: row ?? _row,
      column: column ?? _column,
      properties: properties ?? _properties,
    );
  }

  final CellIndex _index;
  final ViewportRow _row;
  final ViewportColumn _column;
  final CellProperties _properties;

  @override
  CellIndex get index => _index;

  ViewportCell withText(String text) {
    CellValue value = _properties.value;
    return copyWith(properties: _properties.copyWith(value: value.withText(text)));
  }

  String get rawText => _properties.value.rawText;

  TextAlign get textAlign => _properties.value.span.textAlign;

  TextStyle get textStyle => _properties.value.span.style;

  CellProperties get properties => _properties;

  ViewportRow get row => _row;

  ViewportColumn get column => _column;

  @override
  List<Object?> get props => <Object?>[rect, _index, _row, _column, _properties];
}

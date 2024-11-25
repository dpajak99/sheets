import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';

abstract class ViewportItem with EquatableMixin {
  ViewportItem({
    required this.rect,
  });

  final Rect rect;

  String get value;

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

  @override
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

  @override
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
    required String value,
  }) {
    return ViewportCell._(
      rect: Rect.fromLTWH(column.rect.left, row.rect.top, column.rect.width, row.rect.height),
      index: index,
      row: row,
      column: column,
      value: value,
    );
  }

  ViewportCell._({
    required super.rect,
    required CellIndex index,
    required ViewportRow row,
    required ViewportColumn column,
    required String value,
  })
      : _index = index,
        _row = row,
        _column = column,
        _value = value;

  ViewportCell copyWith({
    Rect? rect,
    CellIndex? index,
    ViewportRow? row,
    ViewportColumn? column,
    String? value,
  }) {
    return ViewportCell._(
      rect: rect ?? this.rect,
      index: index ?? _index,
      row: row ?? _row,
      column: column ?? _column,
      value: value ?? _value,
    );
  }

  final CellIndex _index;
  final ViewportRow _row;
  final ViewportColumn _column;
  final String _value;

  @override
  CellIndex get index => _index;

  @override
  String get value => _value;

  ViewportRow get row => _row;

  ViewportColumn get column => _column;

  TextStyle get textStyle {
    return const TextStyle(
      fontFamily: 'Arial',
      fontSize: 12,
      color: Colors.black,
      height: 1,
      letterSpacing: 0,
    );
  }

  @override
  List<Object?> get props => <Object?>[rect, _index, _row, _column, _value];
}

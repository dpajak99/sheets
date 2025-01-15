import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

abstract class ViewportItem with EquatableMixin {
  ViewportItem({
    required this.rect,
  });

  final BorderRect rect;

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

class BorderRect extends Rect {
  const BorderRect.fromLTWH(super.left, super.top, super.width, super.height) : super.fromLTWH();

  const BorderRect.fromLTRB(super.left, super.top, super.right, super.bottom) : super.fromLTRB();

  static BorderRect zero = const BorderRect.fromLTWH(0, 0, 0, 0);

  Line getTopBorder(Border border) {
    double topWidth = border.top.width;
    double topCenter = topWidth <= 2 ? top - borderWidth : top - borderWidth * 2;
    double topShift = topWidth / 2;

    double leftShift = border.left.width <= 2 ? borderWidth : borderWidth * 2;
    double rightShift = border.right.width <= 2 ? borderWidth : borderWidth * 2;

    return Line(
      Offset(left - leftShift, topCenter + topShift),
      Offset(right + rightShift, topCenter + topShift),
    );
  }

  Line getRightBorder(Border border) {
    double rightWidth = border.right.width;
    double rightCenter = rightWidth <= 2 ? right + borderWidth : right + borderWidth * 2;
    double rightShift = rightWidth / 2;

    double topShift = border.top.width <= 2 ? borderWidth : borderWidth * 2;
    double bottomShift = border.bottom.width <= 2 ? borderWidth : borderWidth * 2;

    return Line(
      Offset(rightCenter - rightShift, top - topShift),
      Offset(rightCenter - rightShift, bottom + bottomShift),
    );
  }

  Line getBottomBorder(Border border) {
    double bottomWidth = border.bottom.width;
    double bottomCenter = bottomWidth <= 2 ? bottom + borderWidth : bottom + borderWidth * 2;
    double bottomShift = bottomWidth / 2;

    double leftShift = border.left.width <= 2 ? borderWidth : borderWidth * 2;
    double rightShift = border.right.width <= 2 ? borderWidth : borderWidth * 2;

    return Line(
      Offset(left - leftShift, bottomCenter - bottomShift),
      Offset(right + rightShift, bottomCenter - bottomShift),
    );
  }

  Line getLeftBorder(Border border) {
    double leftWidth = border.left.width;
    double leftCenter = leftWidth <= 2 ? left - borderWidth : left - borderWidth * 2;
    double leftShift = leftWidth / 2;

    double topShift = border.top.width <= 2 ? borderWidth : borderWidth * 2;
    double bottomShift = border.bottom.width <= 2 ? borderWidth : borderWidth * 2;

    return Line(
      Offset(leftCenter + leftShift, top - topShift),
      Offset(leftCenter + leftShift, bottom + bottomShift),
    );
  }
}

class Line {
  Line(this._start, this._end);

  final Offset _start;
  final Offset _end;

  Offset get start {
    return _start;
  }

  Offset get end {
    return _end;
  }
}

class ViewportRow extends ViewportItem {
  ViewportRow({
    required super.rect,
    required RowIndex index,
    required RowConfig config,
  })  : _index = index,
        _config = config;

  final RowIndex _index;
  final RowConfig _config;

  String get value => '${_index.value + 1}';

  @override
  RowIndex get index => _index;

  RowConfig get config => _config;

  bool get isPinned => _config.pinned;

  @override
  List<Object?> get props => <Object?>[_index, _config, rect];
}

class ViewportColumn extends ViewportItem {
  ViewportColumn({
    required super.rect,
    required ColumnIndex index,
    required ColumnConfig config,
  })  : _index = index,
        _config = config;

  final ColumnIndex _index;
  final ColumnConfig _config;

  String get value {
    return numberToExcelColumn(_index.value + 1);
  }

  @override
  ColumnIndex get index => _index;

  ColumnConfig get style => _config;

  bool get isPinned => _config.pinned;

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
  List<Object?> get props => <Object?>[_index, _config, rect];
}

class ViewportCell extends ViewportItem {
  factory ViewportCell({
    required ViewportRow row,
    required ViewportColumn column,
    CellProperties? properties,
  }) {
    return ViewportCell._(
      rect: BorderRect.fromLTRB(column.rect.left, row.rect.top, column.rect.right, row.rect.bottom),
      row: row,
      column: column,
      properties: properties ??
          CellProperties(
            index: CellIndex(row: row.index, column: column.index),
            value: SheetRichText(),
          ),
    );
  }

  factory ViewportCell.merged({
    required CellIndex index,
    required ViewportRow rowStart,
    required ViewportRow rowEnd,
    required ViewportColumn columnStart,
    required ViewportColumn columnEnd,
    required CellProperties properties,
  }) {
    return ViewportCell._(
      index: index,
      rect: BorderRect.fromLTRB(columnStart.rect.left, rowStart.rect.top, columnEnd.rect.right, rowEnd.rect.bottom),
      row: rowStart,
      column: columnStart,
      properties: properties,
    );
  }

  ViewportCell._({
    required super.rect,
    required ViewportRow row,
    required ViewportColumn column,
    required CellProperties properties,
    CellIndex? index,
  })  : _index = index ?? CellIndex(row: row.index, column: column.index),
        _row = row,
        _column = column {
    _properties = properties;
  }

  ViewportCell copyWith({
    BorderRect? rect,
    ViewportRow? row,
    ViewportColumn? column,
    CellProperties? properties,
  }) {
    return ViewportCell._(
      rect: rect ?? this.rect,
      row: row ?? _row,
      column: column ?? _column,
      properties: properties ?? _properties,
    );
  }

  final CellIndex _index;
  final ViewportRow _row;
  final ViewportColumn _column;
  late final CellProperties _properties;

  @override
  CellIndex get index => _index;

  ViewportColumn get column => _column;

  ViewportRow get row => _row;

  ViewportCell withText(String text) {
    return copyWith(
      properties: _properties.copyWith(value: _properties.value.withText(text)),
    );
  }

  CellProperties get properties => _properties;

  @override
  List<Object?> get props => <Object?>[rect, _index, _row, _column, _properties];
}

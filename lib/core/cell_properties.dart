import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

extension IndexedValuesProperties on Iterable<IndexedCellProperties> {
  Map<ColumnIndex, List<IndexedCellProperties>> groupByColumns() {
    Map<ColumnIndex, List<IndexedCellProperties>> groupedCells = <ColumnIndex, List<IndexedCellProperties>>{};
    for (IndexedCellProperties cell in this) {
      groupedCells.putIfAbsent(cell.index.column, () => <IndexedCellProperties>[]).add(cell);
    }
    return groupedCells;
  }

  List<IndexedCellProperties> whereColumn(ColumnIndex index) {
    return where((IndexedCellProperties cell) => cell.index.column == index).toList();
  }

  Map<RowIndex, List<IndexedCellProperties>> groupByRows() {
    Map<RowIndex, List<IndexedCellProperties>> groupedCells = <RowIndex, List<IndexedCellProperties>>{};
    for (IndexedCellProperties cell in this) {
      groupedCells.putIfAbsent(cell.index.row, () => <IndexedCellProperties>[]).add(cell);
    }
    return groupedCells;
  }

  List<IndexedCellProperties> whereRow(RowIndex index) {
    return where((IndexedCellProperties cell) => cell.index.row == index).toList();
  }

  List<IndexedCellProperties> maybeReverse(bool value) {
    return value ? toList().reversed.toList() : toList();
  }
}

class IndexedCellProperties with EquatableMixin {
  const IndexedCellProperties({
    required this.index,
    required this.properties,
  });

  final CellIndex index;
  final CellProperties properties;

  IndexedCellProperties copyWith({CellIndex? index, CellProperties? properties}) {
    return IndexedCellProperties(
      index: index ?? this.index,
      properties: properties ?? this.properties,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, properties];
}

class CellProperties with EquatableMixin {
  CellProperties({
    required this.style,
    required this.value,
  });

  CellProperties.empty()
      : value = SheetRichText(),
        style = CellStyle();

  final CellStyle style;
  final SheetRichText value;

  CellProperties copyWith({SheetRichText? value, CellStyle? style}) {
    return CellProperties(
      style: style ?? this.style,
      value: value ?? this.value,
    );
  }

  SheetRichText get visibleRichText {
    return visibleValueFormat.formatVisible(value) ?? value;
  }

  SheetRichText get editableRichText {
    return visibleValueFormat.formatEditable(value);
  }

  SheetValueFormat get visibleValueFormat {
    return style.valueFormat ?? SheetValueFormat.auto(value);
  }

  TextAlign get visibleTextAlign {
    return style.horizontalAlign ?? visibleValueFormat.textAlign;
  }

  @override
  List<Object?> get props => <Object?>[style, value];
}

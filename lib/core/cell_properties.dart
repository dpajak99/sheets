import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/values/cell_value.dart';

class CellProperties with EquatableMixin {
  CellProperties(this.index, this.style, this.value);

  CellProperties.empty(this.index, this.style) : value = StringCellValue.empty();

  final CellIndex index;
  final CellStyle style;
  CellValue value;

  CellProperties copyWith({CellValue? value, CellStyle? style}) {
    return CellProperties(
      index,
      style ?? this.style,
      value ?? this.value,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, value];
}

class CellStyle with EquatableMixin {
  CellStyle({
    required this.rowStyle,
    required this.columnStyle,
  });

  final RowStyle rowStyle;
  final ColumnStyle columnStyle;

  @override
  List<Object?> get props => <Object?>[rowStyle, columnStyle];
}

class SelectionStyle with EquatableMixin {
  SelectionStyle(this.textStyle);

  final TextStyle textStyle;

  FontWeight? get fontWeight => textStyle.fontWeight;

  FontStyle? get fontStyle => textStyle.fontStyle;

  TextDecoration? get decoration => textStyle.decoration;

  Color? get color => textStyle.color;

  Color? get backgroundColor => textStyle.backgroundColor;

  double? get fontSize => textStyle.fontSize;

  @override
  List<Object?> get props => <Object?>[textStyle];
}

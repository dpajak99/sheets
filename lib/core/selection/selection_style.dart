import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/text_vertical_align.dart';

abstract class SelectionStyle with EquatableMixin {
  SelectionStyle({
    required this.cellProperties,
    required this.textStyle,
  });

  final CellProperties cellProperties;
  final SheetTextSpanStyle textStyle;

  TextAlign get textAlignHorizontal => cellProperties.visibleTextAlign;

  TextVerticalAlign get textAlignVertical {
    return cellProperties.style.verticalAlign;
  }

  CellStyle get cellStyle => cellProperties.style;

  FontWeight? get fontWeight => textStyle.fontWeight;

  FontStyle? get fontStyle => textStyle.fontStyle;

  TextDecoration? get decoration => textStyle.decoration;

  Color? get color => textStyle.color;

  Color? get backgroundColor => cellProperties.style.backgroundColor;

  FontSize get fontSize => textStyle.fontSize;

  SheetValueFormat get valueFormat => cellProperties.visibleValueFormat;
}

class CellSelectionStyle extends SelectionStyle {
  CellSelectionStyle({
    required super.cellProperties,
  }) : super(
          textStyle: cellProperties.value.getSharedStyle(),
        );

  @override
  List<Object?> get props => <Object?>[cellProperties];
}

class CursorSelectionStyle extends SelectionStyle {
  CursorSelectionStyle({
    required super.cellProperties,
    required super.textStyle,
  });

  @override
  List<Object?> get props => <Object?>[cellProperties, textStyle];
}

class CursorRangeSelectionStyle extends SelectionStyle {
  CursorRangeSelectionStyle({
    required super.cellProperties,
    required this.textStyles,
  }) : super(
          textStyle: cellProperties.value.getSharedStyle(),
        );

  final List<SheetTextSpanStyle> textStyles;

  @override
  List<Object?> get props => <Object?>[cellProperties, textStyles];
}

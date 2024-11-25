import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_overflow_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

class CellProperties with EquatableMixin {
  CellProperties({
    required this.style,
    required this.value,
  });

  CellProperties.empty()
      : value = SheetRichText.empty(),
        style = CellStyle();

  CellStyle style;
  SheetRichText value;

  CellProperties copyWith({SheetRichText? value, CellStyle? style}) {
    return CellProperties(
      style: style ?? this.style,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => <Object?>[value];
}

class CellStyle with EquatableMixin {
  CellStyle({
    this.textAlign = TextAlign.left,
    this.textOverflow = TextOverflowBehavior.clip,
    this.textVerticalAlign = TextVerticalAlign.bottom,
    this.rotationAngleDegrees = 0.0,
    this.backgroundColor = Colors.white,
    Border? border,
  })  : _border = border,
        borderZIndex = border != null ? DateTime.now().millisecondsSinceEpoch : null;

  Color backgroundColor;
  double rotationAngleDegrees;
  TextAlign textAlign;
  TextOverflowBehavior textOverflow;
  TextVerticalAlign textVerticalAlign;
  Border? _border;

  Border? get border => _border;
  set border(Border? value) {
    _border = value;
    borderZIndex = DateTime.now().millisecondsSinceEpoch;
  }

  int? borderZIndex;

  @override
  List<Object?> get props => <Object?>[textAlign, textOverflow, textVerticalAlign];
}

class SelectionStyle with EquatableMixin {
  SelectionStyle(this.textStyle, this.cellStyle);

  final TextStyle textStyle;
  final CellStyle cellStyle;

  TextAlign get textAlignHorizontal => cellStyle.textAlign;

  TextVerticalAlign get textAlignVertical => cellStyle.textVerticalAlign;

  FontWeight? get fontWeight => textStyle.fontWeight;

  FontStyle? get fontStyle => textStyle.fontStyle;

  TextDecoration? get decoration => textStyle.decoration;

  Color? get color => textStyle.color;

  Color? get backgroundColor => textStyle.backgroundColor;

  double? get fontSize => textStyle.fontSize;

  @override
  List<Object?> get props => <Object?>[textStyle];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_overflow_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

class CellStyle with EquatableMixin {
  CellStyle({
    this.textAlign,
    this.textOverflow = TextOverflowBehavior.clip,
    this.textVerticalAlign = TextVerticalAlign.bottom,
    this.rotationAngleDegrees = 0.0,
    this.backgroundColor = Colors.white,
    this.valueFormat,
    Border? border,
  })  : _border = border,
        borderZIndex = border != null ? globalBorderZIndex++ : null;

  static int globalBorderZIndex = 0;

  SheetValueFormat? valueFormat;
  Color backgroundColor;
  double rotationAngleDegrees;
  TextAlign? textAlign;
  TextOverflowBehavior textOverflow;
  TextVerticalAlign textVerticalAlign;
  Border? _border;

  Border? get border => _border;

  set border(Border? value) {
    _border = value;
    if (value != null) {
      borderZIndex = globalBorderZIndex++;
    } else {
      borderZIndex = null;
    }
  }

  int? borderZIndex;

  @override
  List<Object?> get props => <Object?>[
    textAlign,
    textOverflow,
    textVerticalAlign,
    rotationAngleDegrees,
    backgroundColor,
    valueFormat,
    _border,
    borderZIndex,
  ];
}

class ColumnStyle with EquatableMixin {
  ColumnStyle({required this.width});

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
  RowStyle({required this.height});

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

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/utils/text_vertical_align.dart';

class CellStyle with EquatableMixin {
  CellStyle({
    TextAlign? horizontalAlign,
    TextOverflowBehavior? textOverflow,
    TextVerticalAlign? verticalAlign,
    TextRotation? rotation,
    Color? backgroundColor,
    this.valueFormat,
    this.border,
  })  : horizontalAlign = horizontalAlign ?? TextAlign.left,
        textOverflow = textOverflow ?? TextOverflowBehavior.clip,
        verticalAlign = verticalAlign ?? TextVerticalAlign.bottom,
        rotation = rotation ?? TextRotation.none,
        backgroundColor = (backgroundColor != null && backgroundColor.alpha == 1) ? backgroundColor : Colors.white,
        borderZIndex = border != null ? globalBorderZIndex++ : null;

  static int globalBorderZIndex = 0;

  CellStyle copyWith({
    TextAlign? horizontalAlign,
    TextOverflowBehavior? textOverflow,
    TextRotation? rotation,
    TextVerticalAlign? verticalAlign,
    Color? backgroundColor,
    SheetValueFormat? valueFormat,
    bool valueFormatNull = false,
    Border? border,
  }) {
    return CellStyle(
      horizontalAlign: horizontalAlign ?? this.horizontalAlign,
      verticalAlign: verticalAlign ?? this.verticalAlign,
      rotation: rotation ?? this.rotation,
      textOverflow: textOverflow ?? this.textOverflow,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      valueFormat: valueFormatNull ? null : valueFormat ?? this.valueFormat,
      border: border ?? this.border,
    );
  }

  final SheetValueFormat? valueFormat;
  final Color backgroundColor;
  final TextAlign? horizontalAlign;
  final TextRotation rotation;
  final TextOverflowBehavior textOverflow;
  final TextVerticalAlign verticalAlign;
  final Border? border;
  final int? borderZIndex;

  @override
  List<Object?> get props => <Object?>[
        valueFormat,
        backgroundColor,
        horizontalAlign,
        rotation,
        textOverflow,
        verticalAlign,
        border,
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
  RowStyle({
    required this.height,
    this.customHeight,
  });

  RowStyle.defaults()
      : height = defaultRowHeight,
        customHeight = null;

  final double height;
  final double? customHeight;

  RowStyle copyWith({
    double? height,
    double? customHeight,
  }) {
    return RowStyle(
      height: height ?? this.height,
      customHeight: customHeight ?? this.customHeight,
    );
  }

  @override
  List<Object?> get props => <Object?>[height, customHeight];
}

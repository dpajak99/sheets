import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/utils/text_vertical_align.dart';

class CellStyle with EquatableMixin {
  CellStyle({
    this.horizontalAlign,
    this.textOverflow = TextOverflowBehavior.clip,
    this.verticalAlign = TextVerticalAlign.bottom,
    this.rotation = TextRotation.none,
    this.backgroundColor = Colors.white,
    this.valueFormat,
    this.border,
  })  : borderZIndex = border != null ? globalBorderZIndex++ : null;

  static int globalBorderZIndex = 0;

  CellStyle copyWith({
    TextAlign? horizontalAlign,
    TextOverflowBehavior? textOverflow,
    TextRotation? rotation,
    TextVerticalAlign? verticalAlign,
    double? rotationAngleDegrees,
    Color? backgroundColor,
    SheetValueFormat? valueFormat,
    Border? border,
  }) {
    return CellStyle(
      horizontalAlign: horizontalAlign ?? this.horizontalAlign,
      verticalAlign: verticalAlign ?? this.verticalAlign,
      rotation: rotation ?? this.rotation,
      textOverflow: textOverflow ?? this.textOverflow,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      valueFormat: valueFormat ?? this.valueFormat,
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
    horizontalAlign,
    textOverflow,
    verticalAlign,
    backgroundColor,
    valueFormat,
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

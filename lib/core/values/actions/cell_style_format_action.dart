import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

abstract class FormatAction with EquatableMixin {
  FormatAction({this.autoresize = false});

  final bool autoresize;
}

abstract class CellStyleFormatAction extends FormatAction {
  CellStyleFormatAction();

  void format(CellStyle previousCellStyle);
}

class UpdateHorizontalTextAlignAction extends CellStyleFormatAction {
  UpdateHorizontalTextAlignAction(this.textAlign);

  final TextAlign textAlign;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.textAlign = textAlign;
  }

  @override
  List<Object?> get props => <Object?>[textAlign];
}

class UpdateVerticalTextAlignAction extends CellStyleFormatAction {
  UpdateVerticalTextAlignAction(this.textVerticalAlign);

  final TextVerticalAlign textVerticalAlign;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.textVerticalAlign = textVerticalAlign;
  }

  @override
  List<Object?> get props => <Object?>[textVerticalAlign];
}

class UpdateBackgroundColorAction extends CellStyleFormatAction {
  UpdateBackgroundColorAction(this.color);

  final Color color;

  @override
  void format(CellStyle previousCellStyle) {
    previousCellStyle.backgroundColor = color;
  }

  @override
  List<Object?> get props => <Object?>[];
}

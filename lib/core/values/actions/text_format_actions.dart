import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';

abstract class TextFormatAction with EquatableMixin {
  TextFormatAction(this.selectionStyle);

  final SelectionStyle selectionStyle;

  TextStyle format(TextStyle previousTextStyle);
}

class UpdateFontWeightAction extends TextFormatAction {
  UpdateFontWeightAction(super.selectionStyle, this.fontWeight);

  final FontWeight fontWeight;

  @override
  TextStyle format(TextStyle previousTextStyle) {
    if (selectionStyle.fontWeight == fontWeight) {
      return previousTextStyle.copyWith(fontWeight: FontWeight.normal);
    } else {
      return previousTextStyle.copyWith(fontWeight: fontWeight);
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateFontStyleAction extends TextFormatAction {
  UpdateFontStyleAction(super.selectionStyle, this.fontStyle);

  final FontStyle fontStyle;

  @override
  TextStyle format(TextStyle previousTextStyle) {
    if (selectionStyle.fontStyle == fontStyle) {
      return previousTextStyle.copyWith(fontStyle: FontStyle.normal);
    } else {
      return previousTextStyle.copyWith(fontStyle: fontStyle);
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateTextDecorationAction extends TextFormatAction {
  UpdateTextDecorationAction(super.selectionStyle, this.decoration);

  final TextDecoration decoration;

  @override
  TextStyle format(TextStyle previousTextStyle) {
    if (selectionStyle.decoration == decoration) {
      return previousTextStyle.copyWith(decoration: TextDecoration.none);
    } else {
      return previousTextStyle.copyWith(decoration: decoration);
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateFontColorAction extends TextFormatAction {
  UpdateFontColorAction(super.selectionStyle, this.color);

  final Color color;

  @override
  TextStyle format(TextStyle previousTextStyle) {
    return previousTextStyle.copyWith(color: color);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateBackgroundColorAction extends TextFormatAction {
  UpdateBackgroundColorAction(super.selectionStyle, this.color);

  final Color color;

  @override
  TextStyle format(TextStyle previousTextStyle) {
    return previousTextStyle.copyWith(backgroundColor: color);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class DecreaseFontSizeAction extends TextFormatAction {
  DecreaseFontSizeAction(super.selectionStyle);

  @override
  TextStyle format(TextStyle previousTextStyle) {
    if (selectionStyle.fontSize != null) {
      return previousTextStyle.copyWith(fontSize: previousTextStyle.fontSize! - 1);
    } else {
      return previousTextStyle;
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class IncreaseFontSizeAction extends TextFormatAction {
  IncreaseFontSizeAction(super.selectionStyle);

  @override
  TextStyle format(TextStyle previousTextStyle) {
    if (selectionStyle.fontSize != null) {
      return previousTextStyle.copyWith(fontSize: previousTextStyle.fontSize! + 1);
    } else {
      return previousTextStyle;
    }
  }
  @override
  List<Object?> get props => <Object?>[];
}

class UpdateFontFamilyAction extends TextFormatAction {
  UpdateFontFamilyAction(super.selectionStyle, this.fontFamily);

  final String fontFamily;

  @override
  TextStyle format(TextStyle previousTextStyle) {
    return previousTextStyle.copyWith(fontFamily: fontFamily);
  }

  @override
  List<Object?> get props => <Object?>[];
}

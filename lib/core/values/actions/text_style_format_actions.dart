import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/values/actions/cell_style_format_action.dart';

abstract class TextStyleFormatAction extends FormatAction {
  TextStyleFormatAction(this.selectionStyle, {super.autoresize});

  final SelectionStyle selectionStyle;

  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle);
}

class UpdateFontWeightAction extends TextStyleFormatAction {
  UpdateFontWeightAction(super.selectionStyle, this.fontWeight);

  final FontWeight fontWeight;

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    if (selectionStyle.fontWeight == fontWeight) {
      return previousTextStyle.copyWith(fontWeight: FontWeight.normal);
    } else {
      return previousTextStyle.copyWith(fontWeight: fontWeight);
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateFontStyleAction extends TextStyleFormatAction {
  UpdateFontStyleAction(super.selectionStyle, this.fontStyle);

  final FontStyle fontStyle;

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    if (selectionStyle.fontStyle == fontStyle) {
      return previousTextStyle.copyWith(fontStyle: FontStyle.normal);
    } else {
      return previousTextStyle.copyWith(fontStyle: fontStyle);
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateTextDecorationAction extends TextStyleFormatAction {
  UpdateTextDecorationAction(super.selectionStyle, this.decoration);

  final TextDecoration decoration;

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    if (selectionStyle.decoration == decoration) {
      return previousTextStyle.copyWith(decoration: TextDecoration.none);
    } else {
      return previousTextStyle.copyWith(decoration: decoration);
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateFontColorAction extends TextStyleFormatAction {
  UpdateFontColorAction(super.selectionStyle, this.color);

  final Color color;

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    return previousTextStyle.copyWith(color: color);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class DecreaseFontSizeAction extends TextStyleFormatAction {
  DecreaseFontSizeAction(super.selectionStyle) : super(autoresize: true);

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    if (selectionStyle.fontSize != null) {
      return previousTextStyle.copyWith(fontSize: previousTextStyle.fontSize! - 1);
    } else {
      return previousTextStyle;
    }
  }

  @override
  List<Object?> get props => <Object?>[];
}

class IncreaseFontSizeAction extends TextStyleFormatAction {
  IncreaseFontSizeAction(super.selectionStyle): super(autoresize: true);

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    if (selectionStyle.fontSize != null) {
      return previousTextStyle.copyWith(fontSize: previousTextStyle.fontSize! + 1);
    } else {
      return previousTextStyle;
    }
  }
  @override
  List<Object?> get props => <Object?>[];
}

class UpdateFontFamilyAction extends TextStyleFormatAction {
  UpdateFontFamilyAction(super.selectionStyle, this.fontFamily);

  final String fontFamily;

  @override
  TextStyle format(TextStyle mergedTextStyle, TextStyle previousTextStyle) {
    return previousTextStyle.copyWith(fontFamily: fontFamily);
  }

  @override
  List<Object?> get props => <Object?>[];
}

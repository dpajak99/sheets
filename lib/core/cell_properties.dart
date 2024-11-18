import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_overflow_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';

int globalBorderZIndex = 0;

class CellProperties with EquatableMixin {
  CellProperties({
    required this.style,
    required this.value,
  });

  CellProperties.empty()
      : value = SheetRichText(),
        style = CellStyle();

  CellStyle style;
  SheetRichText value;

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
    return style.textAlign ?? visibleValueFormat.textAlign;
  }

  @override
  List<Object?> get props => <Object?>[style, value];
}

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

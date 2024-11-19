import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

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

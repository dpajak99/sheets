import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class IndexedCellProperties with EquatableMixin {
  const IndexedCellProperties({
    required this.index,
    required this.properties,
  });

  final CellIndex index;
  final CellProperties properties;

  IndexedCellProperties copyWith({CellIndex? index, CellProperties? properties}) {
    return IndexedCellProperties(
      index: index ?? this.index,
      properties: properties ?? this.properties,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, properties];
}

class CellProperties with EquatableMixin {
  CellProperties({
    CellStyle? style,
    SheetRichText? value,
  }) {
    this.style = style ?? CellStyle();
    this.value = value ?? SheetRichText();
  }

  late final CellStyle style;
  late final SheetRichText value;

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
    return style.horizontalAlign ?? visibleValueFormat.textAlign;
  }

  @override
  List<Object?> get props => <Object?>[style, value];
}

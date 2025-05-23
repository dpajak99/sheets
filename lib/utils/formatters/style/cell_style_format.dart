import 'package:flutter/material.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/text_rotation.dart';

abstract class CellStyleFormatIntent extends StyleFormatIntent {
  CellStyleFormatIntent();

  CellStyleFormatAction<CellStyleFormatIntent> createAction({CellStyle? cellStyle});
}

abstract class CellStyleFormatAction<I extends CellStyleFormatIntent> extends StyleFormatAction<I> {
  CellStyleFormatAction({required super.intent, this.baseCellStyle});

  final CellStyle? baseCellStyle;

  CellStyle format(CellStyle currentStyle);
}

// Horizontal TextAlign
class SetHorizontalAlignIntent extends CellStyleFormatIntent {
  SetHorizontalAlignIntent(this.align);

  final TextAlign align;

  @override
  SetHorizontalAlignAction createAction({CellStyle? cellStyle}) {
    return SetHorizontalAlignAction(intent: this, baseCellStyle: cellStyle);
  }
}

class SetHorizontalAlignAction extends CellStyleFormatAction<SetHorizontalAlignIntent> {
  SetHorizontalAlignAction({required super.intent, super.baseCellStyle});

  @override
  CellStyle format(CellStyle currentStyle) {
    return currentStyle.copyWith(horizontalAlign: intent.align);
  }
}

// Vertical TextAlign
class SetVerticalAlignIntent extends CellStyleFormatIntent {
  SetVerticalAlignIntent(this.align);

  final TextAlignVertical align;

  @override
  SetVerticalAlignAction createAction({CellStyle? cellStyle}) {
    return SetVerticalAlignAction(intent: this, baseCellStyle: cellStyle);
  }
}

class SetVerticalAlignAction extends CellStyleFormatAction<SetVerticalAlignIntent> {
  SetVerticalAlignAction({required super.intent, super.baseCellStyle});

  @override
  CellStyle format(CellStyle currentStyle) {
    return currentStyle.copyWith(verticalAlign: intent.align);
  }
}

// Background color
class SetBackgroundColorIntent extends CellStyleFormatIntent {
  SetBackgroundColorIntent({required this.color});

  final Color? color;

  @override
  SetBackgroundColorAction createAction({CellStyle? cellStyle}) {
    return SetBackgroundColorAction(intent: this, baseCellStyle: cellStyle);
  }
}

class SetBackgroundColorAction extends CellStyleFormatAction<SetBackgroundColorIntent> {
  SetBackgroundColorAction({required super.intent, super.baseCellStyle});

  @override
  CellStyle format(CellStyle currentStyle) {
    return currentStyle.copyWith(backgroundColor: intent.color);
  }
}

// Value format
class SetValueFormatIntent extends CellStyleFormatIntent {
  SetValueFormatIntent({required this.format});

  final SheetValueFormat? Function(SheetValueFormat? previousFormat)? format;

  @override
  SetValueFormatAction createAction({CellStyle? cellStyle}) {
    return SetValueFormatAction(intent: this, baseCellStyle: cellStyle);
  }
}

class SetValueFormatAction extends CellStyleFormatAction<SetValueFormatIntent> {
  SetValueFormatAction({required super.intent, super.baseCellStyle});

  @override
  CellStyle format(CellStyle currentStyle) {
    SheetValueFormat? newFormat = intent.format?.call(currentStyle.valueFormat);
    if (newFormat == null) {
      return currentStyle.copyWith(valueFormatNull: true);
    } else {
      return currentStyle.copyWith(valueFormat: newFormat);
    }
  }
}

// Rotation
class SetRotationIntent extends CellStyleFormatIntent {
  SetRotationIntent(this.rotation);

  final TextRotation rotation;

  @override
  SetRotationAction createAction({CellStyle? cellStyle}) {
    return SetRotationAction(intent: this, baseCellStyle: cellStyle);
  }
}

class SetRotationAction extends CellStyleFormatAction<SetRotationIntent> {
  SetRotationAction({required super.intent, super.baseCellStyle});

  @override
  CellStyle format(CellStyle currentStyle) {
    return currentStyle.copyWith(rotation: intent.rotation);
  }
}

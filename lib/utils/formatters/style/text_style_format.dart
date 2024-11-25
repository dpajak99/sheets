import 'package:flutter/material.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';

abstract class TextStyleFormatIntent extends StyleFormatIntent {
  TextStyleFormatIntent();

  TextStyleFormatAction<TextStyleFormatIntent> createAction({TextStyle? baseTextStyle});
}

abstract class TextStyleFormatAction<I extends TextStyleFormatIntent> extends StyleFormatAction<I> {
  TextStyleFormatAction({required super.intent, this.baseTextStyle});

  final TextStyle? baseTextStyle;

  TextStyle format(TextStyle currentStyle);
}

// FontWeight
class ToggleFontWeightIntent extends TextStyleFormatIntent {
  ToggleFontWeightIntent({
    this.defaultValue = FontWeight.normal,
    this.value = FontWeight.bold,
  });

  final FontWeight defaultValue;
  final FontWeight value;

  @override
  ToggleFontWeightAction createAction({TextStyle? baseTextStyle}) {
    return ToggleFontWeightAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class ToggleFontWeightAction extends TextStyleFormatAction<ToggleFontWeightIntent> {
  ToggleFontWeightAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    TextStyle baseStyle = baseTextStyle ?? currentStyle;
    if (baseStyle.fontWeight == intent.value) {
      return currentStyle.copyWith(fontWeight: intent.defaultValue);
    } else {
      return currentStyle.copyWith(fontWeight: intent.value);
    }
  }
}

// FontStyle
class ToggleFontStyleIntent extends TextStyleFormatIntent {
  ToggleFontStyleIntent({
    this.defaultValue = FontStyle.normal,
    this.value = FontStyle.italic,
  });

  final FontStyle defaultValue;
  final FontStyle value;

  @override
  ToggleFontStyleAction createAction({TextStyle? baseTextStyle}) {
    return ToggleFontStyleAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class ToggleFontStyleAction extends TextStyleFormatAction<ToggleFontStyleIntent> {
  ToggleFontStyleAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    TextStyle baseStyle = baseTextStyle ?? currentStyle;
    if (baseStyle.fontStyle == intent.value) {
      return currentStyle.copyWith(fontStyle: intent.defaultValue);
    } else {
      return currentStyle.copyWith(fontStyle: intent.value);
    }
  }
}

// TextDecoration
class ToggleTextDecorationIntent extends TextStyleFormatIntent {
  ToggleTextDecorationIntent({
    required this.value,
  });

  final TextDecoration value;

  @override
  ToggleTextDecorationAction createAction({TextStyle? baseTextStyle}) {
    return ToggleTextDecorationAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class ToggleTextDecorationAction extends TextStyleFormatAction<ToggleTextDecorationIntent> {
  ToggleTextDecorationAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    TextStyle baseStyle = baseTextStyle ?? currentStyle;
    TextDecoration? baseDecoration = baseStyle.decoration;

    if (baseDecoration == null) {
      return currentStyle.copyWith(decoration: intent.value);
    } else if (baseDecoration.contains(intent.value)) {
      List<TextDecoration> availableDecorations = <TextDecoration>[
        if (baseDecoration.contains(TextDecoration.underline)) TextDecoration.underline,
        if (baseDecoration.contains(TextDecoration.overline)) TextDecoration.overline,
        if (baseDecoration.contains(TextDecoration.lineThrough)) TextDecoration.lineThrough,
      ]..remove(intent.value);

      return currentStyle.copyWith(decoration: TextDecoration.combine(availableDecorations));
    } else {
      return currentStyle.copyWith(decoration: TextDecoration.combine(<TextDecoration>[currentStyle.decoration!, intent.value]));
    }
  }
}

// Color
class SetFontColorIntent extends TextStyleFormatIntent {
  SetFontColorIntent({
    required this.color,
  });

  final Color color;

  @override
  SetFontColorAction createAction({TextStyle? baseTextStyle}) {
    return SetFontColorAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class SetFontColorAction extends TextStyleFormatAction<SetFontColorIntent> {
  SetFontColorAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    return currentStyle.copyWith(color: intent.color);
  }
}

// FontSize (decrease)
class DecreaseFontSizeIntent extends TextStyleFormatIntent {
  DecreaseFontSizeIntent();

  @override
  DecreaseFontSizeAction createAction({TextStyle? baseTextStyle}) {
    return DecreaseFontSizeAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class DecreaseFontSizeAction extends TextStyleFormatAction<DecreaseFontSizeIntent> {
  DecreaseFontSizeAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    if (currentStyle.fontSize == null) {
      return currentStyle;
    } else {
      return currentStyle.copyWith(fontSize: currentStyle.fontSize! - 1);
    }
  }
}

// FontSize (increase)
class IncreaseFontSizeIntent extends TextStyleFormatIntent {
  IncreaseFontSizeIntent();

  @override
  IncreaseFontSizeAction createAction({TextStyle? baseTextStyle}) {
    return IncreaseFontSizeAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class IncreaseFontSizeAction extends TextStyleFormatAction<IncreaseFontSizeIntent> {
  IncreaseFontSizeAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    if (currentStyle.fontSize == null) {
      return currentStyle;
    } else {
      return currentStyle.copyWith(fontSize: currentStyle.fontSize! + 1);
    }
  }
}

// FontSize
class SetFontSizeIntent extends TextStyleFormatIntent {
  SetFontSizeIntent({
    required this.fontSize,
  });

  final double fontSize;

  @override
  SetFontSizeAction createAction({TextStyle? baseTextStyle}) {
    return SetFontSizeAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class SetFontSizeAction extends TextStyleFormatAction<SetFontSizeIntent> {
  SetFontSizeAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    return currentStyle.copyWith(fontSize: intent.fontSize);
  }
}

// FontFamily
class SetFontFamilyIntent extends TextStyleFormatIntent {
  SetFontFamilyIntent({
    required this.fontFamily,
  });

  final String fontFamily;

  @override
  SetFontFamilyAction createAction({TextStyle? baseTextStyle}) {
    return SetFontFamilyAction(intent: this, baseTextStyle: baseTextStyle);
  }
}

class SetFontFamilyAction extends TextStyleFormatAction<SetFontFamilyIntent> {
  SetFontFamilyAction({required super.intent, super.baseTextStyle});

  @override
  TextStyle format(TextStyle currentStyle) {
    return currentStyle.copyWith(fontFamily: intent.fontFamily);
  }
}

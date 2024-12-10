import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';

class SheetRichText with EquatableMixin {
  factory SheetRichText({List<SheetTextSpan>? spans}) {
    return SheetRichText._(spans == null || spans.isEmpty
            ? <SheetTextSpan>[SheetTextSpan(text: '')] //
            : spans)
        .simplify();
  }

  factory SheetRichText.single({
    required String text,
    SheetTextSpanStyle? style,
  }) {
    return SheetRichText._(<SheetTextSpan>[
      SheetTextSpan(text: text, style: style),
    ]);
  }

  factory SheetRichText.fromTextSpan(TextSpan textSpan) {
    if(textSpan.children?.isEmpty ?? true) {
      return SheetRichText.fromTextSpans(<TextSpan>[textSpan]);
    }
    return SheetRichText.fromTextSpans(textSpan.children!.cast());
  }

  factory SheetRichText.fromTextSpans(List<TextSpan> textSpans) {
    List<SheetTextSpan> spans = textSpans.map((TextSpan textSpan) {
      return SheetTextSpan(
        text: textSpan.text ?? '',
        style: SheetTextSpanStyle.fromTextStyle(textSpan.style),
      );
    }).toList();
    return SheetRichText._(spans).simplify();
  }

  SheetRichText._(this.spans);

  final List<SheetTextSpan> spans;

  SheetRichText simplify() {
    List<SheetTextSpan> newSpans = <SheetTextSpan>[];
    SheetTextSpan? currentSpan;
    for (SheetTextSpan span in spans) {
      if (currentSpan == null) {
        currentSpan = span;
      } else if (currentSpan.style == span.style) {
        currentSpan = currentSpan.copyWith(text: currentSpan.text + span.text);
      } else {
        newSpans.add(currentSpan);
        currentSpan = span;
      }
    }
    if (currentSpan != null) {
      newSpans.add(currentSpan);
    }
    if (newSpans.isEmpty) {
      newSpans.add(SheetTextSpan(text: ''));
    }
    return SheetRichText._(newSpans);
  }

  bool get isEmpty {
    if (spans.isEmpty) {
      return true;
    } else {
      return spans.every((SheetTextSpan span) => span.text.isEmpty);
    }
  }

  String toPlainText() {
    return spans.map((SheetTextSpan span) => span.text).join();
  }

  SheetRichText clear({bool clearStyle = true}) {
    SheetTextSpan firstSpan = spans.first;
    return SheetRichText(spans: <SheetTextSpan>[
      SheetTextSpan(text: '', style: clearStyle ? firstSpan.style : null),
    ]);
  }

  SheetRichText withText(String text) {
    List<SheetTextSpan> newSpans = <SheetTextSpan>[
      SheetTextSpan(text: text, style: spans.first.style),
    ];
    return SheetRichText(spans: newSpans);
  }

  TextSpan toTextSpan() {
    return TextSpan(
      children: spans.map((SheetTextSpan span) => span.toTextSpan()).toList(),
    );
  }

  SheetTextSpanStyle getSharedStyle() {
    List<SheetTextSpanStyle> styles = spans.map((SheetTextSpan span) => span.style).toList();
    if (styles.length > 1) {
      return styles.reduce((SheetTextSpanStyle a, SheetTextSpanStyle b) => a.merge(b));
    } else {
      return styles.first;
    }
  }

  SheetRichText updateStyle(TextStyleFormatAction<TextStyleFormatIntent> formatter) {
    List<SheetTextSpan> newSpans = List<SheetTextSpan>.from(spans);
    for (int i = 0; i < newSpans.length; i++) {
      SheetTextSpan span = newSpans[i];
      newSpans[i] = span.copyWith(style: formatter.format(span.style));
    }
    return SheetRichText(spans: newSpans);
  }

  @override
  List<Object?> get props => <Object?>[spans];
}

class SheetTextSpan with EquatableMixin {
  SheetTextSpan({
    required this.text,
    SheetTextSpanStyle? style,
  }) : style = style ?? SheetTextSpanStyle();

  final String text;
  final SheetTextSpanStyle style;

  SheetTextSpan copyWith({
    String? text,
    SheetTextSpanStyle? style,
  }) {
    return SheetTextSpan(
      text: text ?? this.text,
      style: style ?? this.style,
    );
  }

  TextSpan toTextSpan() {
    return TextSpan(text: text, style: style.toTextStyle());
  }

  @override
  List<Object?> get props => <Object?>[text, style];
}

class SheetTextSpanStyle extends Equatable {
  SheetTextSpanStyle({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    FontSize? fontSize,
    TextDecoration? decoration,
    double? letterSpacing,
    String? fontFamily,
  })  : color = color ?? Colors.black,
        fontWeight = fontWeight ?? FontWeight.normal,
        fontStyle = fontStyle ?? FontStyle.normal,
        fontSize = fontSize ?? const FontSize.fromPoints(10),
        decoration = decoration ?? TextDecoration.none,
        letterSpacing = letterSpacing ?? 0,
        fontFamily = fontFamily?.split('/').last ?? 'Arial';

  factory SheetTextSpanStyle.fromTextStyle(TextStyle? textStyle) {
    if (textStyle == null) {
      return SheetTextSpanStyle();
    }
    return SheetTextSpanStyle(
      color: textStyle.color,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      fontSize: textStyle.fontSize != null ? FontSize.fromPixels(textStyle.fontSize!) : null,
      decoration: textStyle.decoration,
      letterSpacing: textStyle.letterSpacing,
      fontFamily: textStyle.fontFamily,
    );
  }

  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final FontSize fontSize;
  final TextDecoration decoration;
  final double letterSpacing;
  final String fontFamily;

  SheetTextSpanStyle copyWith({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    FontSize? fontSize,
    TextDecoration? decoration,
    double? letterSpacing,
    String? fontFamily,
  }) {
    return SheetTextSpanStyle(
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      fontSize: fontSize ?? this.fontSize,
      decoration: decoration ?? this.decoration,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  SheetTextSpanStyle merge(SheetTextSpanStyle? other) {
    if (other == null) {
      return this;
    }

    SheetTextSpanStyle emptyTextStyle = SheetTextSpanStyle();

    return SheetTextSpanStyle(
      color: other.color != emptyTextStyle.color ? other.color : color,
      fontSize: other.fontSize != emptyTextStyle.fontSize ? other.fontSize : fontSize,
      fontWeight: other.fontWeight != emptyTextStyle.fontWeight ? other.fontWeight : fontWeight,
      fontStyle: other.fontStyle != emptyTextStyle.fontStyle ? other.fontStyle : fontStyle,
      letterSpacing: other.letterSpacing != emptyTextStyle.letterSpacing ? other.letterSpacing : letterSpacing,
      decoration: other.decoration != emptyTextStyle.decoration ? other.decoration : decoration,
      fontFamily: other.fontFamily != emptyTextStyle.fontFamily ? other.fontFamily : fontFamily,
    );
  }

  TextStyle toTextStyle() {
    return TextStyle(
      color: color,
      package: 'sheets',
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize.px,
      decoration: decoration,
      letterSpacing: letterSpacing,
      fontFamily: fontFamily,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        color,
        fontWeight,
        fontStyle,
        fontSize,
        decoration,
        letterSpacing,
        fontFamily,
      ];
}

enum FontSizeUnit {
  pt,
  px,
}

class FontSize with EquatableMixin {
  const FontSize.fromPixels(this.value) : unit = FontSizeUnit.px;

  const FontSize.fromPoints(this.value) : unit = FontSizeUnit.pt;

  factory FontSize.fromString(String value) {
    if (value.endsWith('pt')) {
      return FontSize.fromPoints(double.parse(value.substring(0, value.length - 2)));
    } else if (value.endsWith('px')) {
      return FontSize.fromPixels(double.parse(value.substring(0, value.length - 2)));
    } else {
      throw ArgumentError('Invalid font size string: $value');
    }
  }

  final double value;
  final FontSizeUnit unit;

  FontSize increasePoints(double amount) {
    return FontSize.fromPoints(pt + amount);
  }

  FontSize decreasePoints(double amount) {
    return FontSize.fromPoints(pt - amount);
  }

  String asString(FontSizeUnit unit) {
    return switch (unit) {
      FontSizeUnit.pt => '${pt}pt',
      FontSizeUnit.px => '${px}px',
    };
  }

  double get pt {
    if (unit == FontSizeUnit.pt) {
      return value;
    } else {
      return pxToPt(value);
    }
  }

  double get px {
    if (unit == FontSizeUnit.px) {
      return value;
    } else {
      return ptToPx(value);
    }
  }

  double pxToPt(double px) {
    return px / 96 * 72;
  }

  double ptToPx(double pt) {
    return pt / 72 * 96;
  }

  @override
  List<Object?> get props => <Object?>[value, unit];
}

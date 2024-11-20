import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart' as constants;
import 'package:sheets/utils/formatters/style/text_style_format.dart';

class SheetRichText {
  SheetRichText({List<SheetTextSpan>? spans})
      : spans = spans == null || spans.isEmpty
            ? <SheetTextSpan>[SheetTextSpan(text: '', style: constants.defaultTextStyle)] //
            : spans;

  SheetRichText.single({
    required String text,
    TextStyle? style,
  }) : spans = <SheetTextSpan>[SheetTextSpan(text: text, style: style ?? constants.defaultTextStyle)];

  factory SheetRichText.fromTextSpan(TextSpan textSpan) {
    return SheetRichText.fromTextSpans(textSpan.children!.cast());
  }

  factory SheetRichText.fromTextSpans(List<TextSpan> textSpans) {
    List<SheetTextSpan> spans = textSpans.map((TextSpan textSpan) {
      return SheetTextSpan(
        text: textSpan.text ?? '',
        style: textSpan.style!,
      );
    }).toList();
    return SheetRichText(spans: spans);
  }

  final List<SheetTextSpan> spans;

  bool get isEmpty {
    if(spans.isEmpty) {
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
      SheetTextSpan(text: '', style: clearStyle ? firstSpan.style : constants.defaultTextStyle),
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

  TextStyle getSharedStyle() {
    List<TextStyle> styles = spans.map((SheetTextSpan span) => span.style).toList();
    if (styles.length > 1) {
      return styles.reduce((TextStyle a, TextStyle b) => a.merge(b));
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
}

class SheetTextSpan {
  SheetTextSpan({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  SheetTextSpan copyWith({
    String? text,
    TextStyle? style,
  }) {
    return SheetTextSpan(
      text: text ?? this.text,
      style: style ?? this.style,
    );
  }

  TextSpan toTextSpan() {
    return TextSpan(text: text, style: style);
  }
}

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart' as constants;
import 'package:sheets/core/values/actions/text_format_actions.dart';

class SheetRichText {
  SheetRichText({required this.spans});

  SheetRichText.single({
    required String text,
    TextStyle? style,
  }) : spans = <SheetTextSpan>[SheetTextSpan(text: text, style: style ?? constants.defaultTextStyle)];

  SheetRichText.empty({TextStyle? style})
      : spans = <SheetTextSpan>[SheetTextSpan(text: '', style: style ?? constants.defaultTextStyle)];

  factory SheetRichText.fromTextSpans(List<TextSpan> textSpans) {
    List<SheetTextSpan> spans = textSpans.map((TextSpan textSpan) {
      return SheetTextSpan(
        text: textSpan.text ?? '',
        style: textSpan.style ?? constants.defaultTextStyle,
      );
    }).toList();
    return SheetRichText(spans: spans);
  }

  final List<SheetTextSpan> spans;
  final TextAlign textAlign = TextAlign.left;

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
    if (styles.isEmpty) {
      return constants.defaultTextStyle;
    }
    return styles.reduce((TextStyle a, TextStyle b) => a.merge(b));
  }

  void updateStyle(TextFormatAction textFormatAction) {
    for(int i = 0; i < spans.length; i++) {
      spans[i] = spans[i].copyWith(style: textFormatAction.format(spans[i].style));
    }
  }

  String get rawText {
    return spans.map((SheetTextSpan span) => span.text).join();
  }
}

class SheetTextSpan {
  SheetTextSpan({
    required this.text,
    this.style = constants.defaultTextStyle,
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

class EditableTextSpan with EquatableMixin {
  EditableTextSpan({
    required this.letters,
  }) : defaultTextStyle = constants.defaultTextStyle;

  factory EditableTextSpan.fromString(String text, TextStyle style) {
    List<TextSpanLetter> letters = text.split('').map((String letter) {
      return TextSpanLetter(letter, style);
    }).toList();
    if (letters.isEmpty) {
      letters.add(TextSpanLetter.empty(style));
    }
    return EditableTextSpan(letters: letters);
  }

  factory EditableTextSpan.fromSheetRichText(SheetRichText sheetRichText) {
    return EditableTextSpan.fromTextSpan(sheetRichText.toTextSpan());
  }

  factory EditableTextSpan.fromTextSpan(TextSpan textSpan) {
    List<TextSpanLetter> letters = <TextSpanLetter>[];
    textSpan.visitChildren((InlineSpan span) {
      if (span is TextSpan) {
        List<String> text = span.text?.split('') ?? <String>[];
        for(String letter in text) {
          letters.add(TextSpanLetter(letter, span.style ?? constants.defaultTextStyle));
        }
      }
      return true;
    });

    if (letters.isEmpty) {
      letters.add(TextSpanLetter.empty(constants.defaultTextStyle));
    }

    return EditableTextSpan(letters: letters);
  }

  final TextStyle defaultTextStyle;
  final List<TextSpanLetter> letters;

  String get rawText {
    return letters.map((TextSpanLetter letter) => letter.letter).join();
  }

  void clear({bool keepStyle = false}) {
    TextStyle style = keepStyle ? letters.first.style : defaultTextStyle;
    letters.clear();
    letters.add(TextSpanLetter.empty(style));
  }

  TextSpan toSimplifiedTextSpan() {
    assert(letters.isNotEmpty, 'Letters should not be empty');
    List<TextSpan> spans = <TextSpan>[];
    TextStyle currentStyle = letters.first.style;
    String sameStyleText = '';

    for (int i = 0; i < letters.length; i++) {
      TextSpanLetter letter = letters[i];
      if (i == letters.length - 1) {
        sameStyleText += letter.letter;
        spans.add(TextSpan(text: sameStyleText, style: currentStyle));
      } else if (currentStyle != letter.style) {
        spans.add(TextSpan(text: sameStyleText, style: currentStyle));
        currentStyle = letter.style;
        sameStyleText = letter.letter;
      } else {
        sameStyleText += letter.letter;
      }
    }

    return TextSpan(text: '', children: spans);
  }

  void insert(int index, String text) {
    TextStyle previousStyle = getPreviousStyle(index);
    List<TextSpanLetter> newLetters = text.split('').map((String letter) {
      return TextSpanLetter(letter, previousStyle);
    }).toList();

    letters.insertAll(index, newLetters);
  }

  void removeAt(int index) {
    TextStyle previousStyle = getPreviousStyle(index);
    letters.removeAt(index);
    if (letters.isEmpty) {
      letters.add(TextSpanLetter.empty(previousStyle));
    }
  }

  void removeRange(int start, int end) {
    TextSpanLetter letter = letters.first;

    if (start == end) {
      removeAt(start - 1);
    } else {
      letters.removeRange(start, end);
    }

    if (letters.isEmpty) {
      letters.add(letter.copyWith(letter: ''));
    }
  }

  void insertStyle(int index, TextFormatAction textFormatAction) {
    TextStyle previousStyle = getPreviousStyle(index);
    TextStyle newStyle = textFormatAction.format(previousStyle);

    while (index < letters.length && letters[index].isEmpty) {
      letters.removeAt(index);
    }
    if (index < 0) {
      letters.insert(0, TextSpanLetter.empty(newStyle));
    } else if (index >= letters.length) {
      letters.add(TextSpanLetter.empty(newStyle));
    } else {
      letters.insert(index, TextSpanLetter.empty(newStyle));
    }
  }

  void updateStyle(int start, int end, TextFormatAction textFormatAction) {
    for (int i = start; i < end; i++) {
      TextSpanLetter letter = letters[i];
      letters[i] = letter.copyWith(style: textFormatAction.format(letter.style));
    }
  }

  TextStyle getCurrentStyle(int index) {
    int letterIndex = max(index - 1, 0);
    return letters.elementAtOrNull(letterIndex)?.style ?? defaultTextStyle;
  }

  TextStyle getPreviousStyle(int index) {
    TextSpanLetter? previousLetter = letters.elementAtOrNull(index);
    if (previousLetter == null || !previousLetter.isEmpty) {
      previousLetter = index < letters.length - 1 ? letters[max(0, index - 1)] : letters.last;
    }

    return previousLetter.style;
  }

  double get maxFontSize {
    return letters.map((TextSpanLetter letter) {
      return letter.style.fontSize ?? 1;
    }).reduce(max);
  }

  double get minFontSize {
    return letters.map((TextSpanLetter letter) {
      return letter.style.fontSize ?? 1;
    }).reduce(min);
  }

  @override
  List<Object?> get props => <Object?>[letters];
}

class TextSpanLetter with EquatableMixin {
  TextSpanLetter(
    this.letter,
    this.style,
  ) : assert(letter.isEmpty || letter.length == 1, 'Letter must be empty or have a length of 1');

  TextSpanLetter.empty(this.style) : letter = '';
  final String letter;
  final TextStyle style;

  TextSpanLetter copyWith({
    String? letter,
    TextStyle? style,
  }) {
    return TextSpanLetter(
      letter ?? this.letter,
      style ?? this.style,
    );
  }

  bool get isEmpty => letter.isEmpty;

  @override
  List<Object?> get props => <Object?>[letter];
}

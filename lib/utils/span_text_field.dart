import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class AnnotatedEditableText extends EditableText {
  AnnotatedEditableText({
    required this.textSpan,
    required super.maxLines,
    required super.minLines,
    required super.cursorWidth,
    required super.cursorRadius,
    required super.scrollPadding,
    required super.textAlign,
    required super.focusNode,
    required super.controller,
    required super.style,
    required super.cursorColor,
    super.key,
  }) : super(
          backgroundCursorColor: cursorColor,
          keyboardType: TextInputType.text,
          selectionColor: Colors.blue,
        );

  final MainSheetTextSpan textSpan;

  @override
  AnnotatedEditableTextState createState() => AnnotatedEditableTextState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MainSheetTextSpan>('textSpan', textSpan));
  }
}

class AnnotatedEditableTextState extends EditableTextState {
  late MainSheetTextSpan baseSheetTextSpan = widget.textSpan.copyWith();

  @override
  AnnotatedEditableText get widget => super.widget as AnnotatedEditableText;

  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _previousText = widget.controller.text;
  }

  @override
  TextSpan buildTextSpan() {
    String currentText = textEditingValue.text;

    if (_previousText != currentText) {
      int start = 0;
      while (start < _previousText.length && start < currentText.length && _previousText[start] == currentText[start]) {
        start++;
      }

      int endOld = _previousText.length - 1;
      int endNew = currentText.length - 1;
      while (endOld >= start && endNew >= start && _previousText[endOld] == currentText[endNew]) {
        endOld--;
        endNew--;
      }

      String removedText = _previousText.substring(start, endOld + 1);
      String insertedText = currentText.substring(start, endNew + 1);

      if (removedText.isNotEmpty) {
        baseSheetTextSpan.delete(start, removedText.length);
      }

      if (insertedText.isNotEmpty) {
        baseSheetTextSpan.insert(start, insertedText);
      }

      _previousText = currentText;
    }

    TextSpan textSpan = baseSheetTextSpan.toTextSpan();

    return textSpan;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MainSheetTextSpan>('baseSheetTextSpan', baseSheetTextSpan));
  }
}

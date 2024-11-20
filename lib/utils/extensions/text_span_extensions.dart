import 'package:flutter/material.dart';

extension TextSpanExtensions on TextSpan {
  TextSpan applyDivider(String divider, {TextSpan? child}) {
    TextSpan originalSpan = child ?? this;

    String originalText = originalSpan.text ?? '';
    String transformedText = originalText.split('').join(divider);

    List<TextSpan> updatedChildren = (originalSpan.children ?? <TextSpan>[])
        .whereType<TextSpan>()
        .map((TextSpan span) => applyDivider(divider, child: span))
        .toList();

    return TextSpan(text: transformedText, style: originalSpan.style, children: updatedChildren);
  }
}

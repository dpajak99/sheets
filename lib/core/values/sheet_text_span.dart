import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SheetTextSpan with EquatableMixin {
  SheetTextSpan({
    required this.text,
    this.style = defaultTextStyle,
    this.textAlign = TextAlign.left,
  });

  static const TextStyle defaultTextStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 12,
    color: Colors.black,
    height: 1,
    letterSpacing: 0,
  );

  SheetTextSpan copyWith({
    String? text,
    TextStyle? style,
    TextAlign? textAlign,
  }) {
    return SheetTextSpan(
      text: text ?? this.text,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  late String text;
  final TextStyle style;
  final TextAlign textAlign;

  String get rawText => text;

  void insert(int index, String insertedText) {
    print('inserting $insertedText at $index');
    text = text.substring(0, index) + insertedText + text.substring(index);
  }

  void delete(int index, int length) {
    if (index < 0 || index > text.length) {
      throw RangeError('Index out of bounds in delete');
    }
    if (length < 0) {
      throw RangeError('Negative length in delete');
    }
    int deleteEnd = index + length;
    if (deleteEnd > text.length) {
      deleteEnd = text.length;
    }
    text = text.substring(0, index) + text.substring(deleteEnd);
  }

  SheetTextSpan withText(String text) {
    return SheetTextSpan(
      text: text,
      style: style,
      textAlign: textAlign,
    );
  }

  TextSpan toTextSpan() {
    return TextSpan(
      text: text,
      style: style,
    );
  }

  @override
  List<Object?> get props => <Object?>[text, style, textAlign];
}

class MainSheetTextSpan extends SheetTextSpan {
  MainSheetTextSpan({
    required super.text,
    super.style,
    super.textAlign,
    this.children = const <SheetTextSpan>[],
  });

  MainSheetTextSpan.empty()
      : this(
          text: '',
          children: <SheetTextSpan>[],
        );

  @override
  MainSheetTextSpan copyWith({
    String? text,
    TextStyle? style,
    TextAlign? textAlign,
    List<SheetTextSpan>? children,
  }) {
    return MainSheetTextSpan(
      text: text ?? this.text,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      children: children ?? this.children,
    );
  }

  final List<SheetTextSpan> children;

  @override
  String get rawText {
    return <String>[text, ...children.map((SheetTextSpan child) => child.rawText)].join();
  }

  @override
  MainSheetTextSpan withText(String text) {
    return MainSheetTextSpan(
      text: text,
      style: style,
      textAlign: textAlign,
      children: children,
    );
  }

  @override
  TextSpan toTextSpan() {
    List<TextSpan> childTextSpans = children.map((SheetTextSpan child) => child.toTextSpan()).toList();

    return TextSpan(
      text: text,
      style: style,
      children: childTextSpans,
    );
  }

  @override
  void insert(int index, String insertedText) {
    int cursor = 0;

    if (index <= text.length) {
      text = text.substring(0, index) + insertedText + text.substring(index);
      return;
    }

    cursor += text.length;

    for (SheetTextSpan child in children) {
      int childLength = child.rawText.length;
      if (index <= cursor + childLength) {
        child.insert(index - cursor, insertedText);
        return;
      }
      cursor += childLength;
    }

    if (index == cursor) {
      children.add(SheetTextSpan(text: insertedText));
      return;
    }

    throw Exception('Index out of bounds in insert');
  }

  @override
  void delete(int index, int length) {
    int processedLength = length;
    int processedIndex = index;
    int totalLength = rawText.length;
    if (processedIndex < 0 || processedIndex > totalLength) {
      throw RangeError('Index out of bounds in delete');
    }
    if (processedLength < 0) {
      throw RangeError('Negative length in delete');
    }
    if (processedIndex + processedLength > totalLength) {
      processedLength = totalLength - processedIndex;
    }
    int endIndex = processedIndex + processedLength;

    int textLength = text.length;
    if (processedIndex < textLength) {
      int deleteEnd = endIndex <= textLength ? endIndex : textLength;
      int deleteLengthInText = deleteEnd - processedIndex;
      text = text.substring(0, processedIndex) + text.substring(deleteEnd);
      processedIndex = 0;
      processedLength -= deleteLengthInText;
      if (processedLength <= 0) {
        return;
      }
    } else {
      processedIndex -= textLength;
    }

    int i = 0;
    while (i < children.length && processedLength > 0) {
      SheetTextSpan child = children[i];
      int childTextLength = child.rawText.length;

      if (processedIndex < childTextLength) {
        int deleteLengthInChild = (childTextLength - processedIndex) < processedLength
            ? (childTextLength - processedIndex)
            : processedLength;

        if (processedIndex < 0 || processedIndex + deleteLengthInChild > childTextLength) {
          throw RangeError('Index out of bounds in child delete');
        }

        child.delete(processedIndex, deleteLengthInChild);
        processedLength -= deleteLengthInChild;

        if (child.rawText.isEmpty) {
          children.removeAt(i);
        } else {
          i++;
        }

        processedIndex = 0;
      } else {
        processedIndex -= childTextLength;
        i++;
      }
    }
  }


  @override
  List<Object?> get props => <Object?>[text, style, textAlign, children];
}

import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/value_update_notifier.dart';

class SheetTextEditingController extends TextEditingController {
  SheetTextEditingController({
    required this.sheetText,
  }) : super(text: sheetText.rawText);

  final EditableTextSpan sheetText;
  final ValueUpdateNotifier<TextSelection?> selectionNotifier = ValueUpdateNotifier<TextSelection?>(null);

  @override
  TextSpan buildTextSpan({required BuildContext context, required bool withComposing, TextStyle? style}) {
    return sheetText.toSimplifiedTextSpan();
  }

  @override
  set value(TextEditingValue newValue) {
    TextEditingValue oldValue = value;
    bool valueRemoved = newValue.text.isEmpty;
    bool valueChanged = oldValue.text != newValue.text;

    if (valueRemoved) {
      sheetText.clear(keepStyle: true);
    } else if (valueChanged) {
      bool valueAdded = oldValue.text.length < newValue.text.length;
      bool valueRemoved = oldValue.text.length > newValue.text.length;

      if (valueAdded) {
        int start = oldValue.selection.start;
        int end = newValue.selection.start;
        String addedText = newValue.text.substring(start, end);
        sheetText.insert(start, addedText);
      } else if (valueRemoved) {
        int start = oldValue.selection.start;
        int end = oldValue.selection.end;
        sheetText.removeRange(start, end);
      }
    }
    super.value = newValue;
    selectionNotifier.value = newValue.selection;
  }

  TextStyle get activeStyle {
    return sheetText.getCurrentStyle(value.selection.end);
  }

  void applyStyleToSelection(TextStyleUpdateRequest textStyleUpdateRequest) {
    TextSelection selection = value.selection;
    int start = selection.start;
    int end = selection.end;

    if (start == -1 || end == -1) {
      return;
    }

    if (start == end) {
      sheetText.insertStyle(start, textStyleUpdateRequest);
    } else {
      sheetText.updateStyle(start, end, textStyleUpdateRequest);
    }
    selectionNotifier.refresh();
    notifyListeners();
  }
}

class TextStyleUpdateRequest with EquatableMixin {
  TextStyleUpdateRequest({
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.leadingDistribution,
    this.locale,
    this.foreground,
    this.background,
    this.shadows,
    this.fontFeatures,
    this.fontVariations,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.overflow,
  });

  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final TextLeadingDistribution? leadingDistribution;
  final Locale? locale;
  final Paint? foreground;
  final Paint? background;
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;
  final List<FontVariation>? fontVariations;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final String? debugLabel;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final String? package;
  final TextOverflow? overflow;

  TextStyle applyTo(TextStyle textStyle) {
    return textStyle.copyWith(
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        color,
        backgroundColor,
        fontSize,
        fontWeight,
        fontStyle,
        letterSpacing,
        wordSpacing,
        textBaseline,
        leadingDistribution,
        locale,
        foreground,
        background,
        shadows,
        fontFeatures,
        fontVariations,
        decoration,
        decorationColor,
        decorationStyle,
        decorationThickness,
        debugLabel,
        fontFamily,
        fontFamilyFallback,
        package,
        overflow
      ];
}

class SheetTextField extends StatefulWidget {
  const SheetTextField({
    required this.focusNode,
    required this.controller,
    required this.width,
    required this.height,
    required this.onSizeChanged,
    super.key,
  });

  final FocusNode focusNode;
  final SheetTextEditingController controller;
  final double width;
  final double height;
  final ValueChanged<Size> onSizeChanged;

  @override
  State<StatefulWidget> createState() => _SheetTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetTextEditingController>('controller', controller));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<ValueChanged<Size>>.has('onSizeChanged', onSizeChanged));
  }
}

class _SheetTextFieldState extends State<SheetTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        widget.focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextSelection?>(
      valueListenable: widget.controller.selectionNotifier,
      builder: (BuildContext context, TextSelection? selection, _) {
        double maximalWidgetHeight = max(widget.controller.sheetText.minFontSize, widget.height);

        int cursorPosition = widget.controller.selection.baseOffset;
        TextStyle? cursorTextStyle = widget.controller.sheetText.getCurrentStyle(cursorPosition);
        double cursorHeight = cursorTextStyle.fontSize ?? 8.0;

        double textLineHeight = 1;
        if (cursorHeight != maximalWidgetHeight) {
          textLineHeight = textLineHeight + (cursorHeight / maximalWidgetHeight) * 0.28;
        }

        double maxWidth = 300;
        TextPainter textPainter = TextPainter(
          text: widget.controller.sheetText.toSimplifiedTextSpan(),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        double width = max(widget.width, min(maxWidth, textPainter.size.width + 2));
        double height = max(maximalWidgetHeight, textPainter.size.height);

        widget.onSizeChanged(Size(width, height));

        return Container(
          color: Colors.red.withOpacity(0.2),
          width: width,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              maxLines: null,
              autofocus: true,
              mouseCursor: SystemMouseCursors.text,
              controller: widget.controller,
              focusNode: widget.focusNode,
              cursorHeight: cursorHeight,
              textAlignVertical: TextAlignVertical.top,
              strutStyle: StrutStyle(height: textLineHeight),
              cursorWidth: 1,
              cursorColor: Colors.black,
              selectionHeightStyle: BoxHeightStyle.max,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        );
      },
    );
  }
}

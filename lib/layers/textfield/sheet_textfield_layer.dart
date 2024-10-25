import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/config/sheet_constants.dart' as constants;
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetTextfieldLayer extends StatefulWidget {
  const SheetTextfieldLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetTextfieldLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetTextfieldLayerState extends State<SheetTextfieldLayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ViewportCell?>(
      valueListenable: widget.sheetController.activeCellNotifier,
      builder: (BuildContext context, ViewportCell? activeCell, Widget? child) {
        if (activeCell == null) {
          return const SizedBox();
        }

        return Stack(
          children: <Widget>[
            Positioned(
              left: activeCell.rect.left,
              top: activeCell.rect.top + constants.borderWidth,
              child: SheetTextfield(
                viewportCell: activeCell,
                onEditingCompleted: (String value, Size? newSize) {
                  widget.sheetController.setCellValue(activeCell.index, value, size: newSize);
                  SheetSelectionMoveGesture(1, 0).resolve(widget.sheetController);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class SheetTextfield extends StatefulWidget {
  SheetTextfield({
    required this.viewportCell,
    required this.onEditingCompleted,
    this.backgroundColor = Colors.white,
    this.offset = Offset.zero,
    Border? outerBorder,
    Border? innerBorder,
    EdgeInsets? contentPadding,
    super.key,
  }) {
    this.outerBorder =
        outerBorder ?? Border.all(color: const Color(0xffB2C5F4), width: 2, strokeAlign: BorderSide.strokeAlignOutside);
    this.innerBorder = innerBorder ?? Border.all(color: const Color(0xff3056C6), width: 2);
    this.contentPadding = contentPadding ?? const EdgeInsets.symmetric(vertical: 1, horizontal: 3);
  }

  final ViewportCell viewportCell;
  final void Function(String, Size?) onEditingCompleted;
  final Color backgroundColor;
  final Offset offset;
  late final Border outerBorder;
  late final Border innerBorder;
  late final EdgeInsets contentPadding;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ViewportCell>('viewportCell', viewportCell));
    properties.add(DiagnosticsProperty<Border>('outerBorder', outerBorder));
    properties.add(DiagnosticsProperty<Border>('innerBorder', innerBorder));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DiagnosticsProperty<EdgeInsets>('contentPadding', contentPadding));
    properties.add(ObjectFlagProperty<void Function(String p1, Size? p2)>.has('onEditingCompleted', onEditingCompleted));
  }

  @override
  State<StatefulWidget> createState() => _SheetTextfieldState();
}

class _SheetTextfieldState extends State<SheetTextfield> {
  late final FocusNode focusNode;
  late final TextEditingController controller;

  ViewportCell get viewportCell => widget.viewportCell;
  bool controlPressed = false;
  late Size textfieldSize = Size(viewportCell.rect.width, viewportCell.rect.height);
  Size? newSize;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent) {
          if (controlPressed) {
            return KeyEventResult.ignored;
          }
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            widget.onEditingCompleted(controller.text, newSize);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.controlLeft) {
            controlPressed = true;
          }
          return KeyEventResult.ignored;
        } else if (event is KeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.controlLeft) {
            controlPressed = false;
          }
          return KeyEventResult.ignored;
        } else {
          return KeyEventResult.ignored;
        }
      },
    );
    controller = TextEditingController(text: widget.viewportCell.value);
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: widget.outerBorder,
        color: widget.backgroundColor,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(border: widget.innerBorder),
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.innerBorder.top.width,
            left: widget.innerBorder.left.width,
            right: widget.innerBorder.right.width,
            bottom: widget.innerBorder.bottom.width,
          ),
          child: FixedIncrementTextField(
            baseSize: Size(textfieldWidth, textfieldHeight),
            maxWidth: 300,
            maxHeight: 300,
            controller: controller,
            focusNode: focusNode,
            minLines: 1,
            maxLines: null,
            style: widget.viewportCell.textStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: widget.contentPadding,
            ),
            cursorColor: Colors.black,
            horizontalIncrementBuilder: () {
              return viewportCell.rect.width;
            },
            onSizeChanged: (Size size) {
              Size updatedSize = Size(
                textfieldSize.width,
                size.height + widget.innerBorder.top.width + widget.innerBorder.bottom.width + constants.borderWidth,
              );
              newSize = updatedSize;
            },
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ViewportCell>('viewportCell', viewportCell));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<TextEditingController>('controller', controller));
    properties.add(DiagnosticsProperty<bool>('controlPressed', controlPressed));
    properties.add(DiagnosticsProperty<Size>('textfieldSize', textfieldSize));
    properties.add(DoubleProperty('textfieldWidth', textfieldWidth));
    properties.add(DoubleProperty('textfieldHeight', textfieldHeight));
    properties.add(DiagnosticsProperty<Size?>('newSize', newSize));
  }

  double get textfieldWidth {
    double borderWidth = widget.innerBorder.left.width + widget.innerBorder.right.width;
    return textfieldSize.width - borderWidth - constants.borderWidth;
  }

  double get textfieldHeight {
    double borderWidth = widget.innerBorder.top.width + widget.innerBorder.bottom.width;
    return textfieldSize.height - borderWidth - constants.borderWidth;
  }
}

class FixedIncrementTextField extends StatefulWidget {
  const FixedIncrementTextField({
    required this.baseSize,
    required this.maxWidth,
    required this.maxHeight,
    required this.controller,
    required this.focusNode,
    required this.minLines,
    required this.style,
    required this.cursorColor,
    required this.decoration,
    required this.horizontalIncrementBuilder,
    required this.onSizeChanged,
    super.key,
    this.maxLines = 1,
  });

  final Size baseSize;
  final double maxWidth;
  final double maxHeight;
  final TextEditingController controller;
  final FocusNode focusNode;
  final int minLines;
  final int? maxLines;
  final TextStyle style;
  final Color cursorColor;
  final InputDecoration decoration;
  final double Function() horizontalIncrementBuilder;
  final void Function(Size) onSizeChanged;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('controller', controller));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(IntProperty('minLines', minLines));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
    properties.add(ColorProperty('cursorColor', cursorColor));
    properties.add(DoubleProperty('maxWidth', maxWidth));
    properties.add(DoubleProperty('maxHeight', maxHeight));
    properties.add(ObjectFlagProperty<double Function()>.has('horizontalIncrementBuilder', horizontalIncrementBuilder));
    properties.add(ObjectFlagProperty<void Function(Size p1)>.has('onSizeChanged', onSizeChanged));
    properties.add(DiagnosticsProperty<Size>('baseSize', baseSize));
    properties.add(DiagnosticsProperty<InputDecoration>('decoration', decoration));
  }

  @override
  State<StatefulWidget> createState() => _FixedIncrementTextFieldState();
}

class _FixedIncrementTextFieldState extends State<FixedIncrementTextField> {
  late Size _areaSize = widget.baseSize;
  late Size _editableSize = baseEditableSize;

  Size get baseEditableSize => Size(
        widget.baseSize.width - (widget.decoration.contentPadding?.horizontal ?? 0),
        widget.baseSize.height - (widget.decoration.contentPadding?.vertical ?? 0),
      );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_adjustSize);
    _adjustSize(notify: false);
  }

  void _adjustSize({bool notify = true}) {
    double fontSize = widget.style.fontSize ?? 0;
    double lineHeightFactor = widget.style.height ?? 1;
    double singleLineHeight = fontSize * lineHeightFactor;

    TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.controller.text, style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: widget.maxWidth);

    double textWidth = textPainter.width;
    double textHeight = textPainter.height;

    int requiredLines = (textHeight / singleLineHeight).ceil();

    double maxWidth = widget.maxWidth;
    double maxHeight = widget.maxHeight;

    double newWidth = _editableSize.width;
    double newHeight = requiredLines * singleLineHeight + 2;

    if (textWidth > newWidth && newWidth < maxWidth) {
      newWidth = min(textWidth + widget.horizontalIncrementBuilder(), maxWidth);
    }

    newWidth = min(newWidth, maxWidth);
    newHeight = min(newHeight, maxHeight);

    _editableSize = Size(newWidth, newHeight);

    Size newAreaSize = Size(
      newWidth + (widget.decoration.contentPadding?.horizontal ?? 0),
      newHeight + (widget.decoration.contentPadding?.vertical ?? 0),
    );

    _areaSize = Size(
      newAreaSize.width,
      max(newAreaSize.height, widget.baseSize.height),
    );

    int customNewLines = widget.controller.text.split('\n').length;
    double customNewLinesHeight = customNewLines * singleLineHeight + (widget.decoration.contentPadding?.vertical ?? 0) + 2;
    widget.onSizeChanged(Size(widget.baseSize.width, customNewLinesHeight));

    if (notify) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_adjustSize);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: _areaSize,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: widget.decoration.contentPadding ?? EdgeInsets.zero,
          child: SizedBox.fromSize(
            size: _editableSize,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                style: widget.style,
                cursorColor: widget.cursorColor,
                cursorWidth: 1,
                cursorRadius: Radius.zero,
                decoration: widget.decoration.copyWith(
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('baseEditableSize', baseEditableSize));
  }
}

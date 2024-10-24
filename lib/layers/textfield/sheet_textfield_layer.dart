import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      valueListenable: widget.sheetController.activeCell,
      builder: (BuildContext context, ViewportCell? activeCell, Widget? child) {
        if (activeCell == null) {
          return const SizedBox();
        }

        return Stack(
          children: <Widget>[
            Positioned(
              left: activeCell.rect.left - 2,
              top: activeCell.rect.top - 1,
              child: SheetTextfield(viewportCell: activeCell),
            ),
          ],
        );
      },
    );
  }
}

class SheetTextfield extends StatefulWidget {
  const SheetTextfield({
    required this.viewportCell,
    super.key,
  });

  final ViewportCell viewportCell;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ViewportCell>('viewportCell', viewportCell));
  }

  @override
  State<StatefulWidget> createState() => _SheetTextfieldState();
}

class _SheetTextfieldState extends State<SheetTextfield> {
  late final FocusNode focusNode;
  late final TextEditingController controller;

  ViewportCell get viewportCell => widget.viewportCell;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController(text: widget.viewportCell.value);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: viewportCell.rect.width + 3,
        minHeight: viewportCell.rect.height + 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffB2C5F4), width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xff3056C6), width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FixedIncrementTextField(
            width: viewportCell.rect.width - 11,
            increment: viewportCell.rect.width,
            maxWidth: 300,
            autofocus: true,
            controller: controller,
            focusNode: focusNode,
            minLines: 1,
            maxLines: null,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              color: Colors.black,
              height: 1,
            ),
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
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
  }
}

class FixedIncrementTextField extends StatefulWidget {
  const FixedIncrementTextField({
    required this.width,
    required this.increment,
    required this.maxWidth,
    required this.autofocus,
    required this.controller,
    required this.focusNode,
    required this.minLines,
    required this.style,
    required this.cursorColor,
    required this.decoration,
    super.key,
    this.maxLines = 1,
  });

  final double width;
  final double increment;
  final double maxWidth;
  final bool autofocus;
  final TextEditingController controller;
  final FocusNode focusNode;
  final int minLines;
  final int? maxLines;
  final TextStyle style;
  final Color cursorColor;
  final InputDecoration decoration;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<TextEditingController>('controller', controller));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(IntProperty('minLines', minLines));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
    properties.add(ColorProperty('cursorColor', cursorColor));
    properties.add(DiagnosticsProperty<InputDecoration>('decoration', decoration));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('increment', increment));
    properties.add(DoubleProperty('maxWidth', maxWidth));
  }

  @override
  State<StatefulWidget> createState() => _FixedIncrementTextFieldState();
}

class _FixedIncrementTextFieldState extends State<FixedIncrementTextField> {
  late double _width = widget.width;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_adjustWidth);
  }

  void _adjustWidth() {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.controller.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    if (textPainter.width > _width - 15) {
      setState(() {
        _width = (_width + widget.increment).clamp(0.0, widget.maxWidth);
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_adjustWidth);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        style: widget.style,
        cursorColor: widget.cursorColor,
        decoration: widget.decoration,
      ),
    );
  }
}

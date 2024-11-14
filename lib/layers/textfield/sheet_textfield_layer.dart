import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';

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
    return ValueListenableBuilder<EditableViewportCell?>(
      valueListenable: widget.sheetController.activeCellNotifier,
      builder: (BuildContext context, EditableViewportCell? activeCell, Widget? child) {
        if (activeCell == null) {
          return const SizedBox();
        }

        return Stack(
          children: <Widget>[
            Positioned(
              left: activeCell.cell.rect.left,
              top: activeCell.cell.rect.top,
              child: SheetTextfieldLayout(
                maxWidth: widget.sheetController.viewport.width - activeCell.cell.rect.left - 10,
                maxHeight: widget.sheetController.viewport.height - activeCell.cell.rect.top - 10,
                backgroundColor: activeCell.cell.properties.style.backgroundColor,
                onSizeChanged: (Rect? rect) {
                  widget.sheetController.mouse.ignorePointerRect = rect;
                },
                onCompleted: (bool shouldSaveValue, SheetRichText richText, Size size) {
                  if(shouldSaveValue) {
                    widget.sheetController.setCellValue(activeCell.cell.index, richText, size: size);
                    SheetSelectionMoveGesture(1, 0).resolve(widget.sheetController);
                  } else {
                    widget.sheetController.resetActiveCell();
                  }
                },
                controller: activeCell.controller,
                viewportCell: activeCell.cell,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SheetTextfieldLayout extends StatefulWidget {
  SheetTextfieldLayout({
    required this.onSizeChanged,
    required this.controller,
    required this.viewportCell,
    required this.onCompleted,
    required this.maxWidth,
    required this.maxHeight,
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
    this.contentPadding = contentPadding ?? const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 1);

    controller.layout(
      minWidth: viewportCell.rect.width - paddingHorizontal,
      minHeight: viewportCell.rect.height - paddingVertical,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      step: 100,
    );
  }

  final SheetTextEditingController controller;
  final ValueChanged<Rect?> onSizeChanged;
  final ViewportCell viewportCell;
  final void Function(bool shouldSaveValue, SheetRichText richText, Size size) onCompleted;
  final Color backgroundColor;
  final Offset offset;
  final double maxWidth;
  final double maxHeight;
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
    properties.add(DiagnosticsProperty<SheetTextEditingController>('controller', controller));
    properties.add(ObjectFlagProperty<ValueChanged<Rect>>.has('onSizeChanged', onSizeChanged));
    properties.add(ObjectFlagProperty<void Function(bool shouldSaveValue, SheetRichText richText, Size size)>.has('onCompleted', onCompleted));
    properties.add(DoubleProperty('maxWidth', maxWidth));
    properties.add(DoubleProperty('maxHeight', maxHeight));
    properties.add(DoubleProperty('paddingHorizontal', paddingHorizontal));
    properties.add(DoubleProperty('paddingVertical', paddingVertical));
  }

  double get paddingHorizontal {
    double borderWidth = innerBorder.left.width + innerBorder.right.width;
    double padding = contentPadding.left + contentPadding.right;

    return borderWidth + padding;
  }

  double get paddingVertical {
    double borderWidth = innerBorder.top.width + innerBorder.bottom.width;
    double padding = contentPadding.top + contentPadding.bottom;

    return borderWidth + padding;
  }

  @override
  State<StatefulWidget> createState() => _SheetTextfieldLayoutState();
}

class _SheetTextfieldLayoutState extends State<SheetTextfieldLayout> {
  ViewportCell get viewportCell => widget.viewportCell;
  bool controlPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.onSizeChanged(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: widget.outerBorder,
        color: widget.backgroundColor,
      ),
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(border: widget.innerBorder),
        padding: widget.contentPadding,
        child: SheetTextField(
          controller: widget.controller,
          backgroundColor: widget.backgroundColor,
          onSizeChanged: (Size size) {
            Rect textfieldRect = Rect.fromLTWH(viewportCell.rect.left, viewportCell.rect.top, size.width, size.height);
            widget.onSizeChanged(textfieldRect);
          },
          onCompleted: (bool shouldSaveValue, TextSpan textSpan, Size size) {
            SheetRichText sheetRichText = SheetRichText.fromTextSpan(textSpan);
            Size newSize = Size(size.width + widget.paddingHorizontal, size.height + widget.paddingVertical);
            widget.onCompleted(shouldSaveValue, sheetRichText, newSize);
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ViewportCell>('viewportCell', viewportCell));
    properties.add(DiagnosticsProperty<bool>('controlPressed', controlPressed));
  }
}

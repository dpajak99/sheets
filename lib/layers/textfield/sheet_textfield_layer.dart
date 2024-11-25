import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/config/sheet_constants.dart' as constants;
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_text_field.dart';

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
    return ValueListenableBuilder<ActiveCell?>(
      valueListenable: widget.sheetController.activeCellNotifier,
      builder: (BuildContext context, ActiveCell? activeCell, Widget? child) {
        if (activeCell == null) {
          return const SizedBox();
        }

        return Stack(
          children: <Widget>[
            Positioned(
              left: activeCell.cell.rect.left,
              top: activeCell.cell.rect.top + constants.borderWidth,
              child: SheetTextfieldLayout(
                onSizeChanged: (Rect? rect) {
                  widget.sheetController.mouse.ignorePointerRect = rect;
                },
                controller: activeCell.controller,
                viewportCell: activeCell.cell,
                onEditingCompleted: (String value, Size? newSize) {
                  widget.sheetController.setCellValue(activeCell.cell.index, value, size: newSize);
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

class SheetTextfieldLayout extends StatefulWidget {
  SheetTextfieldLayout({
    required this.onSizeChanged,
    required this.controller,
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
    this.contentPadding = contentPadding ?? const EdgeInsets.symmetric(horizontal: 2);
  }

  final SheetTextEditingController controller;
  final ValueChanged<Rect?> onSizeChanged;
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
    properties.add(DiagnosticsProperty<SheetTextEditingController>('controller', controller));
    properties.add(ObjectFlagProperty<ValueChanged<Rect>>.has('onSizeChanged', onSizeChanged));
  }

  @override
  State<StatefulWidget> createState() => _SheetTextfieldLayoutState();
}

class _SheetTextfieldLayoutState extends State<SheetTextfieldLayout> {
  late final FocusNode focusNode;

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
            widget.onEditingCompleted(widget.controller.text, newSize);
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
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    widget.onSizeChanged(null);
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
      child: Container(
        decoration: BoxDecoration(border: widget.innerBorder),
        padding: widget.contentPadding,
        child: SheetTextField(
          focusNode: focusNode,
          controller: widget.controller,
          width: textfieldWidth,
          height: textfieldHeight,
          onSizeChanged: (Size size) {
            Rect textfieldRect = Rect.fromLTWH(viewportCell.rect.left, viewportCell.rect.top, size.width, size.height);
            widget.onSizeChanged(textfieldRect);
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ViewportCell>('viewportCell', viewportCell));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(DiagnosticsProperty<bool>('controlPressed', controlPressed));
    properties.add(DiagnosticsProperty<Size>('textfieldSize', textfieldSize));
    properties.add(DoubleProperty('textfieldWidth', textfieldWidth));
    properties.add(DoubleProperty('textfieldHeight', textfieldHeight));
    properties.add(DiagnosticsProperty<Size?>('newSize', newSize));
  }

  double get textfieldWidth {
    double innerBorderWidth = widget.innerBorder.left.width + widget.innerBorder.right.width;
    return textfieldSize.width - innerBorderWidth - constants.borderWidth - widget.contentPadding.horizontal;
  }

  double get textfieldHeight {
    double innerBorderWidth = widget.innerBorder.top.width + widget.innerBorder.bottom.width;
    double outerBorderWidth = widget.outerBorder.top.width + widget.outerBorder.bottom.width;
    return textfieldSize.height - innerBorderWidth - outerBorderWidth - constants.borderWidth - widget.contentPadding.vertical;
  }
}

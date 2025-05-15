import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';

class SheetTextfieldLayer extends StatefulWidget {
  const SheetTextfieldLayer({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

  @override
  State<StatefulWidget> createState() => _SheetTextfieldLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}

class _SheetTextfieldLayerState extends State<SheetTextfieldLayer> {
  @override
  Widget build(BuildContext context) {
    Border outerBorder = Border.all(
      color: const Color(0xffB2C5F4),
      width: 2,
      strokeAlign: BorderSide.strokeAlignOutside,
    );
    Border innerBorder = Border.all(color: const Color(0xff3056C6), width: 2);
    EdgeInsets contentPadding = const EdgeInsets.only(left: 3, right: 3, top: 1);

    double horizontalBorderWidth = innerBorder.left.width + innerBorder.right.width;
    double horizontalPadding = horizontalBorderWidth + contentPadding.horizontal;

    double verticalBorderWidth = innerBorder.top.width + innerBorder.bottom.width;
    double verticalPadding = verticalBorderWidth + contentPadding.vertical;

    return ValueListenableBuilder<EditableViewportCell?>(
      valueListenable: widget.worksheet.editableCellNotifier,
      builder: (BuildContext context, EditableViewportCell? activeCell, Widget? child) {
        if (activeCell == null) {
          return const SizedBox();
        }
        ViewportCell viewportCell = activeCell.cell;
        activeCell.controller.layout(
          minWidth: viewportCell.rect.width - horizontalPadding,
          minHeight: viewportCell.rect.height - verticalPadding,
          maxWidth: widget.worksheet.viewport.width - activeCell.cell.rect.left - 10,
          maxHeight: widget.worksheet.viewport.height - activeCell.cell.rect.top - 10,
          step: 100,
        );

        return Stack(
          children: <Widget>[
            ValueListenableBuilder<Size>(
              valueListenable: activeCell.controller.sizeNotifier,
              builder: (BuildContext context, Size size, _) {
                double expandedWidth = size.width - activeCell.cell.rect.width + horizontalPadding;
                double horizontalShift = switch (activeCell.cell.properties.visibleTextAlign) {
                  TextAlign.left => 0,
                  TextAlign.center => expandedWidth / 2,
                  TextAlign.right => expandedWidth,
                  (_) => 0,
                };

                return Positioned(
                  left: activeCell.cell.rect.left - horizontalShift,
                  top: activeCell.cell.rect.top,
                  child: SheetTextfieldLayout(
                    outerBorder: outerBorder,
                    innerBorder: innerBorder,
                    contentPadding: contentPadding,
                    worksheet: widget.worksheet,
                    textAlign: activeCell.cell.properties.visibleTextAlign,
                    backgroundColor: activeCell.cell.properties.style.backgroundColor,
                    onCompleted: (bool shouldSaveValue, bool shouldMove) {
                      widget.worksheet.resolve(DisableEditingEvent(save: shouldSaveValue, move: shouldMove));
                    },
                    editableViewportCell: activeCell,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SheetTextfieldLayout extends StatefulWidget {
  const SheetTextfieldLayout({
    required this.worksheet,
    required this.editableViewportCell,
    required this.textAlign,
    required this.onCompleted,
    required this.outerBorder,
    required this.innerBorder,
    required this.contentPadding,
    this.backgroundColor = Colors.white,
    this.offset = Offset.zero,
    super.key,
  });

  final Worksheet worksheet;
  final EditableViewportCell editableViewportCell;
  final TextAlign textAlign;
  final void Function(bool shouldSaveValue, bool shouldMove) onCompleted;
  final Color backgroundColor;
  final Offset offset;
  final Border outerBorder;
  final Border innerBorder;
  final EdgeInsets contentPadding;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Border>('outerBorder', outerBorder));
    properties.add(DiagnosticsProperty<Border>('innerBorder', innerBorder));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DiagnosticsProperty<EdgeInsets>('contentPadding', contentPadding));
    properties.add(DoubleProperty('paddingHorizontal', paddingHorizontal));
    properties.add(DoubleProperty('paddingVertical', paddingVertical));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
    properties.add(DiagnosticsProperty<EditableViewportCell>('editableViewportCell', editableViewportCell));
    properties.add(ObjectFlagProperty<void Function(bool shouldSaveValue, bool shouldMove)>.has('onCompleted', onCompleted));
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
  ViewportCell get viewportCell => widget.editableViewportCell.cell;
  bool controlPressed = false;

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
        child: Align(
          alignment: Alignment.centerLeft,
          child: SheetTextField(
            controller: widget.editableViewportCell.controller,
            focusNode: widget.editableViewportCell.focusNode,
            backgroundColor: widget.backgroundColor,
            onSizeChanged: (Size size) {},
            onCompleted: (bool shouldSaveValue, bool shouldMove) {
              widget.onCompleted(shouldSaveValue, shouldMove);
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
    properties.add(DiagnosticsProperty<bool>('controlPressed', controlPressed));
  }
}

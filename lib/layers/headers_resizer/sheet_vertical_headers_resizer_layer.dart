import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_draggable.dart';

class SheetVerticalHeadersResizerLayer extends StatefulWidget {
  const SheetVerticalHeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetVerticalHeadersResizerLayersState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetVerticalHeadersResizerLayersState extends State<SheetVerticalHeadersResizerLayer> {
  List<ViewportColumn> _visibleColumns = <ViewportColumn>[];

  @override
  void initState() {
    super.initState();
    widget.sheetController.addListener(_handleSheetControllerChanged);
    _updateVisibleColumns();
  }

  @override
  void dispose() {
    widget.sheetController.removeListener(_handleSheetControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: _visibleColumns.map((ViewportColumn column) {
        return _VerticalHeaderResizer(
          sheetController: widget.sheetController,
          height: widget.sheetController.viewport.height,
          column: column,
          // TODO(Dominik): Duplication?
          onResize: (Offset delta) => widget.sheetController.resolve(ResizeColumnEvent(column.index, delta.dx)),
        );
      }).toList(),
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildProperties properties = widget.sheetController.value;
    if (properties.rebuildVerticalHeaderResizer) {
      _updateVisibleColumns();
    }
  }

  void _updateVisibleColumns() {
    setState(() => _visibleColumns = widget.sheetController.viewport.visibleContent.columns);
  }
}

class _VerticalHeaderResizer extends StatefulWidget {
  const _VerticalHeaderResizer({
    required this.height,
    required this.column,
    required this.onResize,
    required this.sheetController,
  });

  final double height;
  final ViewportColumn column;
  final ValueChanged<Offset> onResize;
  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _VerticalHeaderResizerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<ViewportColumn>('column', column));
    properties.add(ObjectFlagProperty<ValueChanged<Offset>>.has('onResize', onResize));
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _VerticalHeaderResizerState extends State<_VerticalHeaderResizer> {
  late final MouseColumnResizeGestureHandler _handler = MouseColumnResizeGestureHandler(widget.column);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _handler,
      builder: (BuildContext context, _) {
        Rect columnRect = widget.column.rect;
        double marginTop = columnRect.top + (columnRect.height - resizerLength) / 2;
        double dividerWidth = resizerGapSize + resizerWeight * 2;

        double columnRightX = _handler.newWidth != null ? widget.column.rect.left + _handler.newWidth! : widget.column.rect.right;

        Rect draggableAreaRect = Rect.fromLTWH(
          columnRightX - (resizerGapSize / 2) - resizerWeight,
          widget.column.rect.top,
          resizerLength,
          columnRect.height,
        );

        return Positioned(
          top: draggableAreaRect.top,
          left: draggableAreaRect.left,
          bottom: 0,
          width: dividerWidth,
          child: SheetDraggable(
            draggableAreaRect: draggableAreaRect,
            mouseListener: widget.sheetController.mouse,
            handler: _handler,
            child: SizedBox.expand(
              child: _handler.isHovered
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: resizerWeight,
                          height: resizerLength,
                          margin: EdgeInsets.only(top: marginTop),
                          color: Colors.black,
                        ),
                        if (_handler.isActive) ...<Widget>[
                          Container(width: resizerGapSize, height: widget.height, color: const Color(0xffc4c7c5)),
                        ] else ...<Widget>[
                          SizedBox(width: resizerGapSize),
                        ],
                        Container(
                          width: resizerWeight,
                          height: resizerLength,
                          margin: EdgeInsets.only(top: marginTop),
                          color: Colors.black,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_draggable.dart';

class SheetVerticalHeadersResizerLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetVerticalHeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetVerticalHeadersResizerLayersState();
}

class _SheetVerticalHeadersResizerLayersState extends State<SheetVerticalHeadersResizerLayer> {
  List<ViewportColumn> _visibleColumns = <ViewportColumn>[];

  @override
  void initState() {
    super.initState();
    _updateVisibleColumns();
    widget.sheetController.viewport.visibleContent.addListener(_updateVisibleColumns);
  }

  @override
  void dispose() {
    widget.sheetController.viewport.visibleContent.removeListener(_updateVisibleColumns);
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
          onResize: (Offset delta) => widget.sheetController.resizeColumn(column.index, delta.dx),
        );
      }).toList(),
    );
  }

  void _updateVisibleColumns() {
    setState(() => _visibleColumns = widget.sheetController.viewport.visibleContent.columns);
  }
}

class _VerticalHeaderResizer extends StatefulWidget {
  final double height;
  final ViewportColumn column;
  final ValueChanged<Offset> onResize;
  final SheetController sheetController;

  const _VerticalHeaderResizer({
    required this.height,
    required this.column,
    required this.onResize,
    required this.sheetController,
  });

  @override
  State<StatefulWidget> createState() => _VerticalHeaderResizerState();
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

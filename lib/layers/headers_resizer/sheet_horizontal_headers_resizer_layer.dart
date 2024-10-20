import 'package:flutter/material.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/mouse/sheet_draggable.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class SheetHorizontalHeadersResizerLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetHorizontalHeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SheetHorizontalHeadersResizerLayerState();
}

class _SheetHorizontalHeadersResizerLayerState extends State<SheetHorizontalHeadersResizerLayer> {
  List<ViewportRow> _visibleRows = <ViewportRow>[];

  @override
  void initState() {
    super.initState();
    _updateVisibleRows();
    widget.sheetController.viewport.visibleContent.addListener(_updateVisibleRows);
  }

  @override
  void dispose() {
    widget.sheetController.viewport.visibleContent.removeListener(_updateVisibleRows);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: _visibleRows.map((ViewportRow row) {
        return _HorizontalHeaderResizer(
          sheetController: widget.sheetController,
          width: widget.sheetController.viewport.width,
          row: row,
          onResize: (Offset delta) => widget.sheetController.resizeRow(row.index, delta.dy),
        );
      }).toList(),
    );
  }

  void _updateVisibleRows() {
    setState(() => _visibleRows = widget.sheetController.viewport.visibleContent.rows);
  }
}

class _HorizontalHeaderResizer extends StatefulWidget {
  final double width;
  final ViewportRow row;
  final ValueChanged<Offset> onResize;
  final SheetController sheetController;

  const _HorizontalHeaderResizer({
    required this.width,
    required this.row,
    required this.onResize,
    required this.sheetController,
  });

  @override
  State<StatefulWidget> createState() => _HorizontalHeaderResizerState();
}

class _HorizontalHeaderResizerState extends State<_HorizontalHeaderResizer> {
  late final MouseRowResizeGestureHandler _handler = MouseRowResizeGestureHandler(widget.row);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _handler,
      builder: (BuildContext context, _) {
        Rect rowRect = widget.row.rect;
        double marginLeft = rowRect.left + (rowRect.width - resizerLength) / 2;
        double dividerHeight = resizerGapSize + resizerWeight * 2;

        double rowBottomY = _handler.newHeight != null ? widget.row.rect.top + _handler.newHeight! : widget.row.rect.bottom;

        Rect draggableAreaRect = Rect.fromLTWH(
          widget.row.rect.left,
          rowBottomY - (resizerGapSize / 2) - resizerWeight,
          rowRect.width,
          resizerLength,
        );

        return Positioned(
          left: draggableAreaRect.left,
          top: draggableAreaRect.top,
          right: 0,
          height: dividerHeight,
          child: SheetDraggable(
            draggableAreaRect: draggableAreaRect,
            mouseListener: widget.sheetController.mouse,
            handler: _handler,
            child: SizedBox.expand(
                child: _handler.isHovered
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              height: resizerWeight,
                              width: resizerLength,
                              margin: EdgeInsets.only(left: marginLeft),
                              color: Colors.black),
                          if (_handler.isActive) ...<Widget>[
                            Container(height: resizerGapSize, width: widget.width, color: const Color(0xffc4c7c5)),
                          ] else ...<Widget>[
                            SizedBox(height: resizerGapSize),
                          ],
                          Container(
                              height: resizerWeight,
                              width: resizerLength,
                              margin: EdgeInsets.only(left: marginLeft),
                              color: Colors.black),
                        ],
                      )
                    : null),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/mouse/sheet_draggable.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/controller/sheet_controller.dart';

double _kGapSize = 5;
double _kWeight = 3;
double _kLength = 16;

class HeadersResizerLayer extends StatelessWidget {
  final SheetController sheetController;

  const HeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: _VerticalHeadersResizerLayer(sheetController: sheetController)),
        Positioned.fill(child: _HorizontalHeadersResizerLayer(sheetController: sheetController)),
      ],
    );
  }
}

class _VerticalHeadersResizerLayer extends StatefulWidget {
  final SheetController sheetController;

  const _VerticalHeadersResizerLayer({required this.sheetController});

  @override
  State<StatefulWidget> createState() => _VerticalHeadersResizerLayerState();
}

class _VerticalHeadersResizerLayerState extends State<_VerticalHeadersResizerLayer> {
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
        double marginTop = columnRect.top + (columnRect.height - _kLength) / 2;
        double dividerWidth = _kGapSize + _kWeight * 2;

        double columnRightX = _handler.newWidth != null ? widget.column.rect.left + _handler.newWidth! : widget.column.rect.right;

        Rect draggableAreaRect = Rect.fromLTWH(
          columnRightX - (_kGapSize / 2) - _kWeight,
          widget.column.rect.top,
          _kLength,
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
                        Container(width: _kWeight, height: _kLength, margin: EdgeInsets.only(top: marginTop), color: Colors.black),
                        if (_handler.isActive) ...<Widget>[
                          Container(width: _kGapSize, height: widget.height, color: const Color(0xffc4c7c5)),
                        ] else ...<Widget>[
                          SizedBox(width: _kGapSize),
                        ],
                        Container(width: _kWeight, height: _kLength, margin: EdgeInsets.only(top: marginTop), color: Colors.black),
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

class _HorizontalHeadersResizerLayer extends StatefulWidget {
  final SheetController sheetController;

  const _HorizontalHeadersResizerLayer({required this.sheetController});

  @override
  State<StatefulWidget> createState() => _HorizontalHeadersResizerLayerState();
}

class _HorizontalHeadersResizerLayerState extends State<_HorizontalHeadersResizerLayer> {
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
        double marginLeft = rowRect.left + (rowRect.width - _kLength) / 2;
        double dividerHeight = _kGapSize + _kWeight * 2;

        double rowBottomY = _handler.newHeight != null ? widget.row.rect.top + _handler.newHeight! : widget.row.rect.bottom;

        Rect draggableAreaRect = Rect.fromLTWH(
          widget.row.rect.left,
          rowBottomY - (_kGapSize / 2) - _kWeight,
          rowRect.width,
          _kLength,
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
                          Container(height: _kWeight, width: _kLength, margin: EdgeInsets.only(left: marginLeft), color: Colors.black),
                          if (_handler.isActive) ...<Widget>[
                            Container(height: _kGapSize, width: widget.width, color: const Color(0xffc4c7c5)),
                          ] else ...<Widget>[
                            SizedBox(height: _kGapSize),
                          ],
                          Container(height: _kWeight, width: _kLength, margin: EdgeInsets.only(left: marginLeft), color: Colors.black),
                        ],
                      )
                    : null),
          ),
        );
      },
    );
  }
}

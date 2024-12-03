import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_draggable.dart';

class SheetHorizontalHeadersResizerLayer extends StatefulWidget {
  const SheetHorizontalHeadersResizerLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetHorizontalHeadersResizerLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetHorizontalHeadersResizerLayerState extends State<SheetHorizontalHeadersResizerLayer> {
  List<ViewportRow> _visibleRows = <ViewportRow>[];

  @override
  void initState() {
    super.initState();
    widget.sheetController.addListener(_handleSheetControllerChanged);
    _updateVisibleRows();
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
      children: _visibleRows.map((ViewportRow row) {
        return _HorizontalHeaderResizer(
          sheetController: widget.sheetController,
          width: widget.sheetController.viewport.width,
          row: row,
          // TODO(Dominik): Duplication?
          onResize: (Offset delta) => widget.sheetController.resolve(ResizeRowEvent(row.index, delta.dy)),
        );
      }).toList(),
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildConfig rebuildConfig = widget.sheetController.value;
    if (rebuildConfig.rebuildHorizontalHeaderResizer) {
      _updateVisibleRows();
    }
  }

  void _updateVisibleRows() {
    setState(() => _visibleRows = widget.sheetController.viewport.visibleContent.rows);
  }
}

class _HorizontalHeaderResizer extends StatefulWidget {
  const _HorizontalHeaderResizer({
    required this.width,
    required this.row,
    required this.onResize,
    required this.sheetController,
  });

  final double width;
  final ViewportRow row;
  final ValueChanged<Offset> onResize;
  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _HorizontalHeaderResizerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DiagnosticsProperty<ViewportRow>('row', row));
    properties.add(ObjectFlagProperty<ValueChanged<Offset>>.has('onResize', onResize));
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
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

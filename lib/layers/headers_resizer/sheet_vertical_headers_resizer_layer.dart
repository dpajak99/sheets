import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_mouse_region.dart';

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
          onResize: (Offset delta) => widget.sheetController.resolve(ResizeColumnEvent(column.index, delta.dx)),
        );
      }).toList(),
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildConfig rebuildConfig = widget.sheetController.value;
    if (rebuildConfig.rebuildVerticalHeaderResizer) {
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
  bool _hovered = false;
  bool _dragged = false;
  double _resizeValue = 0;

  @override
  Widget build(BuildContext context) {
    Rect columnRect = widget.column.rect;
    double marginTop = columnRect.top + (columnRect.height - resizerLength) / 2;

    double dividerWidth = resizerGapSize + resizerWeight * 2;
    double columnRightX = columnRect.right;

    Rect draggableAreaRect = Rect.fromLTWH(
      columnRightX - (resizerGapSize / 2) - resizerWeight,
      columnRect.top,
      resizerLength,
      columnRect.height,
    );

    return Positioned(
      left: draggableAreaRect.left + _resizeValue,
      top: 0,
      width: dividerWidth,
      child: SheetMouseRegion(
        onEnter: (PointerEnterEvent event) {
          setState(() => _hovered = true);
        },
        onExit: (PointerExitEvent event) {
          setState(() => _hovered = false);
        },
        onDragStart: (PointerDownEvent event) {
          setState(() => _dragged = true);
        },
        onDragUpdate: (PointerMoveEvent event) {
          double deltaX = event.delta.dx;
          double newWidth = columnRect.width + _resizeValue + deltaX;
          _resizeValue += deltaX;
          if (newWidth > minColumnWidth) {
            setState(() {});
          }
        },
        onDragEnd: () {
          double newWidth = columnRect.width + _resizeValue;
          newWidth = newWidth > minColumnWidth ? newWidth : minColumnWidth;
          widget.onResize(Offset(newWidth, 0));
          setState(() {
            _dragged = false;
            _resizeValue = 0;
          });
        },
        cursor: SystemMouseCursors.resizeColumn,
        child: _hovered
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: resizerWeight,
                    height: resizerLength,
                    margin: EdgeInsets.only(top: marginTop),
                    color: Colors.black,
                  ),
                  if (_dragged) ...<Widget>[
                    Container(
                      width: resizerGapSize,
                      height: widget.height,
                      color: const Color(0xffc4c7c5),
                    ),
                  ] else ...<Widget>[
                    SizedBox(width: resizerGapSize, height: columnRect.height),
                  ],
                  Container(
                    width: resizerWeight,
                    height: resizerLength,
                    margin: EdgeInsets.only(top: marginTop),
                    color: Colors.black,
                  ),
                ],
              )
            : SizedBox(
                width: resizerWeight,
                height: columnRect.height,
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sheets/core/events/sheet_fill_events.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/core/viewport/sheet_viewport_content_manager.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/widgets/sheet_mouse_region.dart';

class SheetFillHandleLayer extends StatefulWidget {
  const SheetFillHandleLayer({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

  @override
  State<StatefulWidget> createState() => SheetFillHandleLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}

class SheetFillHandleLayerState extends State<SheetFillHandleLayer> {
  static const double _size = 10;

  late bool _visible;
  Offset? _offset;

  @override
  void initState() {
    super.initState();
    SheetSelectionRenderer<SheetSelection> selectionRenderer =
        widget.worksheet.selection.createRenderer(widget.worksheet.viewport);
    _visible = selectionRenderer.fillHandleVisible;
    _offset = selectionRenderer.fillHandleOffset;

    widget.worksheet.addListener(_handleWorksheetChanged);
  }

  @override
  void dispose() {
    widget.worksheet.removeListener(_handleWorksheetChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (_visible && _offset != null)
          Builder(
            builder: (BuildContext context) {
              Rect draggableAreaRect = Rect.fromLTWH(_offset!.dx - _size / 2, _offset!.dy - _size / 2, _size, _size);

              return Positioned(
                left: draggableAreaRect.left,
                top: draggableAreaRect.top,
                child: SheetMouseRegion(
                  cursor: SystemMouseCursors.precise,
                  onDragStart: _handleFillStart,
                  onDragUpdate: _handleFillUpdate,
                  onDragEnd: _handleFillEnd,
                  child: const _FillHandle(size: _size),
                ),
              );
            },
          ),
      ],
    );
  }

  void _handleFillStart(PointerDownEvent event) {
    Offset sheetPosition = widget.worksheet.viewport.globalOffsetToLocal(event.position);
    ViewportItem? viewportItem = _visibleContent.findAnyByOffset(sheetPosition);
    if (viewportItem != null) {
      widget.worksheet.resolve(StartFillSelectionEvent(viewportItem));
    }
  }

  void _handleFillUpdate(PointerMoveEvent event) {
    Offset sheetPosition = widget.worksheet.viewport.globalOffsetToLocal(event.position);
    ViewportItem? viewportItem = _visibleContent.findAnyByOffset(sheetPosition);
    if (viewportItem != null) {
      widget.worksheet.resolve(UpdateFillSelectionEvent(viewportItem));
    }
  }

  void _handleFillEnd() {
    widget.worksheet.resolve(CompleteFillSelectionEvent());
  }

  SheetViewportContentManager get _visibleContent => widget.worksheet.viewport.visibleContent;

  void _handleWorksheetChanged() {
    SheetRebuildConfig rebuildConfig = widget.worksheet.value;
    if (rebuildConfig.rebuildFillHandle) {
      _updateFillHandle();
    }
  }

  void _updateFillHandle() {
    SheetSelectionRenderer<SheetSelection> selectionRenderer =
        widget.worksheet.selection.createRenderer(widget.worksheet.viewport);

    setState(() {
      _visible = selectionRenderer.fillHandleVisible;
      _offset = selectionRenderer.fillHandleOffset;
    });
  }
}

class _FillHandle extends StatelessWidget {
  const _FillHandle({
    required double size,
  }) : _size = size;

  final double _size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff3572e3),
        border: Border.all(color: const Color(0xffffffff)),
      ),
    );
  }
}

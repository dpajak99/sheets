import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/mouse/mouse_gesture_handler.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/widgets/sheet_draggable.dart';

class SheetFillHandleLayer extends StatefulWidget {
  const SheetFillHandleLayer({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => SheetFillHandleLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
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
        widget.sheetController.selection.createRenderer(widget.sheetController.viewport);
    _visible = selectionRenderer.fillHandleVisible;
    _offset = selectionRenderer.fillHandleOffset;

    widget.sheetController.addListener(_handleSheetControllerChanged);
  }

  @override
  void dispose() {
    widget.sheetController.removeListener(_handleSheetControllerChanged);
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
                child: SheetDraggable(
                  handler: MouseFillGestureHandler(),
                  draggableAreaRect: draggableAreaRect,
                  mouseListener: widget.sheetController.mouse,
                  child: const _FillHandle(size: _size),
                ),
              );
            },
          ),
      ],
    );
  }

  void _handleSheetControllerChanged() {
    SheetRebuildProperties properties = widget.sheetController.value;
    if (properties.rebuildFillHandle) {
      _updateFillHandle();
    }
  }

  void _updateFillHandle() {
    SheetSelectionRenderer<SheetSelection> selectionRenderer =
        widget.sheetController.selection.createRenderer(widget.sheetController.viewport);

    setState(() {
      _visible = selectionRenderer.fillHandleVisible;
      _offset = selectionRenderer.fillHandleOffset;
    });
  }
}

class _FillHandle extends StatelessWidget {
  const _FillHandle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff3572e3),
        border: Border.all(color: const Color(0xffffffff)),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('size', size));
  }
}

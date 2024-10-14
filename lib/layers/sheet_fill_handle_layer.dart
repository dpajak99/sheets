import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/selection/sheet_selection_renderer.dart';
import 'package:sheets/widgets/sheet_draggable.dart';

class SheetFillHandleLayer extends StatefulWidget {
  final SheetController sheetController;

  const SheetFillHandleLayer({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => SheetFillHandleLayerState();
}

class SheetFillHandleLayerState extends State<SheetFillHandleLayer> {
  static const double _size = 10.0;

  late bool _visible;
  Offset? _offset;

  bool _dragInProgress = false;

  @override
  void initState() {
    super.initState();
    SheetSelectionRenderer selectionRenderer = widget.sheetController.selectionController.visibleSelection.createRenderer(widget.sheetController.viewport);
    _visible = selectionRenderer.fillHandleVisible;
    _offset = selectionRenderer.fillHandleOffset;

    widget.sheetController.sheetProperties.addListener(_updateFillHandle);
    widget.sheetController.selectionController.addListener(_updateFillHandle);
    widget.sheetController.scrollController.addListener(_updateFillHandle);
  }

  @override
  void dispose() {
    widget.sheetController.sheetProperties.removeListener(_updateFillHandle);
    widget.sheetController.selectionController.removeListener(_updateFillHandle);
    widget.sheetController.scrollController.removeListener(_updateFillHandle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_visible && _offset != null)
          Positioned(
            left: _offset!.dx - _size / 2,
            top: _offset!.dy - _size / 2,
            child: SheetDraggable(
              actionSize: const Size(_size, _size),
              cursor: SystemMouseCursors.precise,
              onDragStart: (_) {
                _dragInProgress = true;
                widget.sheetController.mouse.fillStart();
              },
              onDragDeltaChanged: (_) {
                widget.sheetController.mouse.fillUpdate();
              },
              onDragEnd: (_) {
                _dragInProgress = false;
                widget.sheetController.mouse.fillEnd();
              },
              child: const FillHandle(size: _size),
            ),
          ),
      ],
    );
  }

  void _updateFillHandle() {
    SheetSelectionRenderer selectionRenderer = widget.sheetController.selectionController.visibleSelection.createRenderer(widget.sheetController.viewport);

    setState(() {
      _visible = selectionRenderer.fillHandleVisible;
      _offset = selectionRenderer.fillHandleOffset;
    });
  }
}

class FillHandle extends StatelessWidget {
  final double size;

  const FillHandle({
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff3572e3),
        border: Border.all(color: const Color(0xffffffff), width: 1),
      ),
    );
  }
}

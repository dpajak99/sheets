import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_draggable.dart';

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

  @override
  void initState() {
    super.initState();
    _visible = widget.sheetController.selectionController.selection.fillHandleVisible;
    _offset = widget.sheetController.selectionController.selection.fillHandleOffset;

    widget.sheetController.selectionController.addListener(_updateFillHandle);
  }

  @override
  void dispose() {
    widget.sheetController.selectionController.removeListener(_updateFillHandle);
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
                widget.sheetController.mouse.fillStart();
              },
              onDragDeltaChanged: (_) {
                widget.sheetController.mouse.fillUpdate();
              },
              onDragEnd: (_) {
                widget.sheetController.mouse.fillEnd();
              },
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff3572e3),
                  border: Border.all(color: const Color(0xffffffff), width: 1),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _updateFillHandle() {
    setState(() {
      _visible = widget.sheetController.selectionController.selection.fillHandleVisible;
      _offset = widget.sheetController.selectionController.selection.fillHandleOffset;
    });
  }
}

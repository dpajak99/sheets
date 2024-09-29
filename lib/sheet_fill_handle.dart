import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_gesture_detector.dart';

class SheetFillHandle extends StatefulWidget {
  final SheetController sheetController;

  const SheetFillHandle({
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => SheetFillHandleState();
}

class SheetFillHandleState extends State<SheetFillHandle> {
  static const size = 10.0;

  @override
  Widget build(BuildContext context) {
    bool visible = widget.sheetController.selectionController.selection.fillHandleVisible;
    Offset? fillHandleOffset = widget.sheetController.selectionController.selection.fillHandleOffset;

    return Stack(
      children: [
        if (visible && fillHandleOffset != null)
          Positioned(
            left: fillHandleOffset.dx - size / 2,
            top: fillHandleOffset.dy - size / 2,
            child: SheetGestureDetector(
              disableTapOnHover: true,
              actionSize: const Size(size, size),
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
                width: size,
                height: size,
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
}

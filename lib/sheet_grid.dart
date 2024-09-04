import 'package:flutter/material.dart';
import 'package:sheets/sheet_controller.dart';
import 'package:sheets/sheet_painter.dart';

class SheetGrid extends StatelessWidget {
  final SheetController sheetController;

  const SheetGrid({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: RepaintBoundary(
        child: ListenableBuilder(
          listenable: sheetController.sheetPainterNotifier,
          builder: (BuildContext context, _) {
            return CustomPaint(
              isComplex: true,
              painter: SheetPainter(
                sheetController: sheetController,
              ),
            );
          },
        ),
      ),
    );
  }
}

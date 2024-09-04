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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          Size size = Size(constraints.maxWidth, constraints.maxHeight);
          SheetVisibilityConfig visibilityConfig = sheetController.getVisibilityConfig(size);

          return Stack(
            children: [
              RepaintBoundary(
                child: ListenableBuilder(
                  listenable: sheetController.gridPainterNotifier,
                  builder: (BuildContext context, _) {
                    return CustomPaint(
                      isComplex: true,
                      painter: SheetPainter(
                        sheetController: sheetController,
                        visibilityConfig: visibilityConfig,
                      ),
                    );
                  },
                ),
              ),
              RepaintBoundary(
                child: ListenableBuilder(
                  listenable: sheetController.selectionPainterNotifier,
                  builder: (BuildContext context, _) {
                    return CustomPaint(
                      isComplex: true,
                      painter: HeadersPainter(sheetController: sheetController),
                    );
                  },
                ),
              ),
              RepaintBoundary(
                child: ListenableBuilder(
                  listenable: sheetController.selectionPainterNotifier,
                  builder: (BuildContext context, _) {
                    return CustomPaint(
                      isComplex: true,
                      painter: SelectionPainter(sheetController: sheetController),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sheets/multi_listenable_builder.dart';
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
          sheetController.setSheetSize(Size(constraints.maxWidth, constraints.maxHeight));

          return Stack(
            children: [
              RepaintBoundary(
                child: MultiListenableBuilder(
                  listenables: [
                    sheetController.scrollNotifier,
                  ],
                  builder: (BuildContext context) {
                    return CustomPaint(
                      painter: SheetPainter(sheetController: sheetController),
                    );
                  },
                ),
              ),
              RepaintBoundary(
                child: MultiListenableBuilder(
                  listenables: [
                    sheetController.selectionPainterNotifier,
                    sheetController.scrollNotifier,
                  ],
                  builder: (BuildContext context) {
                    return CustomPaint(
                      isComplex: true,
                      painter: ColumnHeadersPainter(sheetController: sheetController),
                    );
                  },
                ),
              ),
              RepaintBoundary(
                child: MultiListenableBuilder(
                  listenables: [
                    sheetController.selectionPainterNotifier,
                    sheetController.scrollNotifier,
                  ],
                  builder: (BuildContext context) {
                    return CustomPaint(
                      isComplex: true,
                      painter: RowHeadersPainter(sheetController: sheetController),
                    );
                  },
                ),
              ),
              RepaintBoundary(
                child: MultiListenableBuilder(
                  listenables: [
                    sheetController.selectionPainterNotifier,
                    sheetController.scrollNotifier,
                  ],
                  builder: (BuildContext context) {
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

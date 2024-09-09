import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/multi_listenable_builder.dart';
import 'package:sheets/painters/column_headers_painter.dart';
import 'package:sheets/painters/row_headers_painter.dart';
import 'package:sheets/painters/selection_painter.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/painters/sheet_painter.dart';

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
          sheetController.resize(Size(constraints.maxWidth, constraints.maxHeight));

          return Stack(
            children: [
              RepaintBoundary(
                child: MultiListenableBuilder(
                  listenables: [
                    sheetController.paintConfig,
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
                    sheetController.paintConfig,
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
                    sheetController.paintConfig,
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
                    sheetController.paintConfig,
                  ],
                  builder: (BuildContext context) {
                    return CustomPaint(
                      isComplex: true,
                      painter: SelectionPainter(sheetController: sheetController),
                    );
                  },
                ),
              ),
              ValueListenableBuilder<CellConfig?>(
                valueListenable: sheetController.editNotifier,
                builder: (BuildContext context, CellConfig? cellConfig, _) {
                  if (cellConfig == null) {
                    return const SizedBox();
                  }

                  return Positioned(
                    left: cellConfig.rect.left,
                    top: cellConfig.rect.top,
                    width: cellConfig.rect.width,
                    height: cellConfig.rect.height,
                    child: Container(
                      width: cellConfig.rect.width,
                      height: cellConfig.rect.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xff3572e3), width: 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        autofocus: true,
                        controller: TextEditingController(text: cellConfig.value),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          height: 1
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

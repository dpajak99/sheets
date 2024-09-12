import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/custom_scroll_controller.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/painters/paint/sheet_paint_config.dart';
import 'package:sheets/scroll_wrapper.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';

class SheetWidget extends StatefulWidget {
  const SheetWidget({super.key});

  @override
  State<SheetWidget> createState() => SheetWidgetState();
}

class SheetWidgetState extends State<SheetWidget> {
  final SheetController sheetController = SheetController(
    scrollController: SheetScrollController(),
    sheetProperties: SheetProperties(
      customColumnProperties: {
        // ColumnIndex(3): ColumnStyle(width: 200),
      },
      customRowProperties: {
        // RowIndex(8): RowStyle(height: 100),
      },
    ),
  );

  CellIndex? dragStart;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ScrollWrapper(
            sheetController: sheetController,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onPanStart: sheetController.cursorController.dragStart,
                    onPanUpdate: sheetController.cursorController.dragUpdate,
                    onPanEnd: sheetController.cursorController.dragEnd,
                    onTap: sheetController.cursorController.tap,
                    behavior: HitTestBehavior.opaque,
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerSignal: (PointerSignalEvent event) {
                        if (event is PointerScrollEvent) {
                          if (sheetController.keyboardController.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
                            sheetController.cursorController.scrollBy(Offset(event.scrollDelta.dy, event.scrollDelta.dx));
                          } else {
                            sheetController.cursorController.scrollBy(event.scrollDelta);
                          }
                        }
                      },
                      child: SheetGrid(sheetController: sheetController, cursorController: sheetController.cursorController),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: sheetController.cursorController.cursorListener,
                  builder: (BuildContext context, SystemMouseCursor cursor, _) {
                    return Positioned.fill(
                      child: MouseRegion(
                        opaque: false,
                        cursor: cursor,
                        onHover: (event) => sheetController.cursorController.updateOffset(event.localPosition),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SheetFooter(sheetController: sheetController),
      ],
    );
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      sheetController.keyboardController.addKey(event.logicalKey);
    } else if (event is KeyUpEvent) {
      sheetController.keyboardController.removeKey(event.logicalKey);
    }
    return false;
  }
}

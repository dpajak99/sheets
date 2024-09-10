import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';
import 'package:sheets/utils.dart';



class SheetWidget extends StatefulWidget {
  const SheetWidget({super.key});

  @override
  State<SheetWidget> createState() => SheetWidgetState();
}

class SheetWidgetState extends State<SheetWidget> {
  final SheetController sheetController = SheetController(
    customColumnProperties: {
      ColumnIndex(3): ColumnStyle(width: 200),
    },
    customRowProperties: {
      RowIndex(3): RowStyle(height: 100),
    },
  );

  CellIndex? dragStart;

  bool shiftPressed = false;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    sheetController.mouseListener.dragStart(details);
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    sheetController.mouseListener.dragUpdate(details);
                  },
                  onPanEnd: (DragEndDetails details) {
                    sheetController.mouseListener.dragEnd(details);
                  },
                  onTap: () {
                    sheetController.mouseListener.tap();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerSignal: (PointerSignalEvent event) {
                      if (event is PointerScrollEvent) {
                        int scrolledColumns = event.scrollDelta.dx ~/ 50;
                        int scrolledRows = event.scrollDelta.dy ~/ 50;

                        if (shiftPressed) {
                          sheetController.scroll(IntOffset(scrolledRows, scrolledColumns));
                        } else {
                          sheetController.scroll(IntOffset(scrolledColumns, scrolledRows));
                        }
                      }
                    },
                    child: SheetGrid(sheetController: sheetController, mouseListener: sheetController.mouseListener),
                  ),
                ),
              ),
              SheetFooter(sheetController: sheetController, mouseListener: sheetController.mouseListener),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: sheetController.mouseListener.cursorListener,
          builder: (BuildContext context, SystemMouseCursor cursor, _) {
            return Positioned.fill(
              child: MouseRegion(
                opaque: false,
                cursor: cursor,
                onHover: (event) => sheetController.mouseListener.updateOffset(event.localPosition),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _onKey(KeyEvent event) {
    int key = event.logicalKey.keyId;

    if (event is KeyDownEvent) {
      if (key == 8589934850) {
        shiftPressed = true;
      }
    } else if (event is KeyUpEvent) {
      if (key == 8589934850) {
        shiftPressed = false;
      }
    } else if (event is KeyRepeatEvent) {
      if (key == 8589934850) {
        shiftPressed = true;
      }
    }

    return false;
  }
}

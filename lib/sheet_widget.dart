import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';
import 'package:sheets/utils.dart';

class MouseListener extends ChangeNotifier {
  final SheetController sheetController;

  Offset offset = Offset.zero;
  SheetItemConfig? hoveredElement;

  CellConfig? dragStartElement;
  CellConfig? previousDragElement;

  MouseListener({
    required this.sheetController,
  });

  void dragStart(Offset offset) {
    this.offset = offset;
    SheetItemConfig? hoveredElement = sheetController.getHoveredElement(offset);
    this.hoveredElement = hoveredElement;

    if (hoveredElement is CellConfig) {
      dragStartElement = hoveredElement;
      previousDragElement = hoveredElement;
      sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellIndex));
      notifyListeners();
    }
  }

  void dragUpdate(Offset offset) {
    if (dragStartElement == null) {
      return;
    }
    this.offset = offset;
    SheetItemConfig? hoveredElement = sheetController.getHoveredElement(offset);
    this.hoveredElement = hoveredElement;

    if (hoveredElement is CellConfig) {
      if (hoveredElement == dragStartElement) {
        sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellIndex));
      } else if (hoveredElement != previousDragElement) {
        sheetController.updateSelection(SheetRangeSelection(start: dragStartElement!.cellIndex, end: hoveredElement.cellIndex, completed: false));
      }
    }
    notifyListeners();
  }

  void dragEnd(Offset offset) {
    if (dragStartElement == null) {
      return;
    }
    this.offset = offset;
    SheetItemConfig? hoveredElement = sheetController.getHoveredElement(offset);
    if (hoveredElement is CellConfig) {
      if (hoveredElement == dragStartElement) {
        sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellIndex));
      } else if (hoveredElement != previousDragElement) {
        sheetController.updateSelection(SheetRangeSelection(start: dragStartElement!.cellIndex, end: hoveredElement.cellIndex, completed: true));
      }
    }

    dragStartElement = null;
    previousDragElement = null;
    notifyListeners();
  }

  void updateOffset(Offset newOffset) {
    offset = newOffset;
    hoveredElement = sheetController.getHoveredElement(offset);
    notifyListeners();
  }

  void tap() {
    if (hoveredElement is CellConfig) {
      sheetController.updateSelection(SheetSingleSelection((hoveredElement as CellConfig).cellIndex));
    }
  }
}

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
  late final MouseListener mouseListener = MouseListener(sheetController: sheetController);

  CellIndex? dragStart;

  bool shiftPressed = false;

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
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              mouseListener.dragStart(details.globalPosition);
            },
            onPanUpdate: (DragUpdateDetails details) {
              mouseListener.dragUpdate(details.globalPosition);
            },
            onPanEnd: (DragEndDetails details) {
              mouseListener.dragEnd(details.globalPosition);
            },
            onTap: () {
              mouseListener.tap();
            },
            child: Listener(
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
              child: MouseRegion(
                onHover: (event) => mouseListener.updateOffset(event.localPosition),
                child: SheetGrid(sheetController: sheetController),
              ),
            ),
          ),
        ),
        SheetFooter(sheetController: sheetController, mouseListener: mouseListener),
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

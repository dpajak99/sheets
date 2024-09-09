import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/style.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';
import 'package:sheets/utils.dart';

class MouseListener extends ChangeNotifier {
  final SheetController sheetController;

  Offset offset = Offset.zero;
  SheetItemConfig? hoveredElement;

  DateTime? lastTap;

  MouseListener({
    required this.sheetController,
  });

  void dragStart(Offset offset) {
    this.offset = offset;
    hoveredElement = sheetController.getHoveredElement(offset);

    switch (hoveredElement) {
      case CellConfig cellConfig:
        sheetController.selectSingle(cellConfig.cellIndex);
    }

    notifyListeners();
  }

  void dragUpdate(Offset offset) {
    this.offset = offset;
    hoveredElement = sheetController.getHoveredElement(offset);

    switch (hoveredElement) {
      case CellConfig cellConfig:
        sheetController.selectRange(end: cellConfig.cellIndex, completed: false);
    }

    notifyListeners();
  }

  void dragEnd(Offset offset) {
    this.offset = offset;
    hoveredElement = sheetController.getHoveredElement(offset);

    switch (hoveredElement) {
      case CellConfig cellConfig:
        sheetController.selectRange(end: cellConfig.cellIndex, completed: true);
    }

    notifyListeners();
  }

  void updateOffset(Offset newOffset) {
    offset = newOffset;
    hoveredElement = sheetController.getHoveredElement(offset);
    notifyListeners();
  }

  void tap() {
    DateTime tapTime = DateTime.now();
    if (lastTap != null && tapTime.difference(lastTap!) < const Duration(milliseconds: 300)) {
      doubleTap();
    } else {
      sheetController.cancelEdit();
      switch (hoveredElement) {
        case CellConfig cellConfig:
          sheetController.selectSingle(cellConfig.cellIndex);
      }
    }
    lastTap = tapTime;
  }

  void doubleTap() {
    switch (hoveredElement) {
      case CellConfig cellConfig:
        sheetController.edit(cellConfig);
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
            behavior: HitTestBehavior.opaque,
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

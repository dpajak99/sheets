import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheets/sheet_controller.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';
import 'package:sheets/utils.dart';

class MouseListener extends ChangeNotifier {
  final SheetController sheetController;

  Offset offset = Offset.zero;
  ProgramElementConfig? hoveredElement;

  ProgramCellConfig? dragStartElement;
  ProgramCellConfig? previousDragElement;

  MouseListener({
    required this.sheetController,
  });

  void dragStart(Offset offset) {
    this.offset = offset;
    ProgramElementConfig? hoveredElement = sheetController.getHoveredElement(offset);
    this.hoveredElement = hoveredElement;

    if (hoveredElement is ProgramCellConfig) {
      dragStartElement = hoveredElement;
      previousDragElement = hoveredElement;
      sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellKey));
      notifyListeners();
    }
  }

  void dragUpdate(Offset offset) {
    if (dragStartElement == null) {
      return;
    }
    this.offset = offset;
    ProgramElementConfig? hoveredElement = sheetController.getHoveredElement(offset);
    this.hoveredElement = hoveredElement;

    if (hoveredElement is ProgramCellConfig) {
      if (hoveredElement == dragStartElement) {
        sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellKey));
      } else if (hoveredElement != previousDragElement) {
        sheetController.updateSelection(SheetRangeSelection(start: dragStartElement!.cellKey, end: hoveredElement.cellKey, completed: false));
      }
    }
    notifyListeners();
  }

  void dragEnd(Offset offset) {
    if (dragStartElement == null) {
      return;
    }
    this.offset = offset;
    ProgramElementConfig? hoveredElement = sheetController.getHoveredElement(offset);
    if (hoveredElement is ProgramCellConfig) {
      if (hoveredElement == dragStartElement) {
        sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellKey));
      } else if (hoveredElement != previousDragElement) {
        sheetController.updateSelection(SheetRangeSelection(start: dragStartElement!.cellKey, end: hoveredElement.cellKey, completed: true));
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
    if (hoveredElement is ProgramCellConfig) {
      sheetController.updateSelection(SheetSingleSelection((hoveredElement as ProgramCellConfig).cellKey));
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
      ColumnKey(3): ColumnProperties(width: 200),
    },
    customRowProperties: {
      RowKey(3): RowProperties(height: 100),
    },
  );
  late final MouseListener mouseListener = MouseListener(sheetController: sheetController);

  CellKey? dragStart;

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

                  sheetController.scroll(IntOffset(scrolledColumns, scrolledRows));
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
}

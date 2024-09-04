import 'package:flutter/material.dart';
import 'package:sheets/sheet_controller.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';

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

    if( hoveredElement is ProgramCellConfig ) {
      dragStartElement = hoveredElement;
      previousDragElement = hoveredElement;
      sheetController.updateSelection(SheetSingleSelection(hoveredElement.cellKey));
      notifyListeners();
    }
  }

  void dragUpdate(Offset offset) {
    this.offset = offset;
    ProgramElementConfig? hoveredElement = sheetController.getHoveredElement(offset);
    this.hoveredElement = hoveredElement;

    if( hoveredElement is ProgramCellConfig && hoveredElement != previousDragElement) {
      sheetController.updateSelection(SheetRangeSelection(start: dragStartElement!.cellKey, end: hoveredElement.cellKey));
      notifyListeners();
    }
  }

  void dragEnd(Offset offset) {
    this.offset = offset;
    ProgramElementConfig? hoveredElement = sheetController.getHoveredElement(offset);
    this.hoveredElement = hoveredElement;

    if( hoveredElement is ProgramCellConfig) {
      sheetController.updateSelection(SheetRangeSelection(start: dragStartElement!.cellKey, end: hoveredElement.cellKey));
      dragStartElement = null;
      previousDragElement = null;
      notifyListeners();
    }
  }

  void updateOffset(Offset newOffset) {
    offset = newOffset;
    hoveredElement = sheetController.getHoveredElement(offset);
    notifyListeners();
  }

  void tap() {
    if( hoveredElement is ProgramCellConfig ) {
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
  final SheetController sheetController = SheetController();
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
            child: MouseRegion(
              onHover: (event) => mouseListener.updateOffset(event.localPosition),

              child: SheetGrid(sheetController: sheetController),
            ),
          ),
        ),
        SheetFooter(sheetController: sheetController, mouseListener: mouseListener),
      ],
    );
  }
}

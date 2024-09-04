import 'package:flutter/material.dart';
import 'package:sheets/sheet_controller.dart';
import 'package:sheets/sheet_footer.dart';
import 'package:sheets/sheet_grid.dart';

class SheetWidget extends StatefulWidget {
  const SheetWidget({super.key});

  @override
  State<SheetWidget> createState() => SheetWidgetState();
}

class SheetWidgetState extends State<SheetWidget> {
  final SheetController sheetController = SheetController();
  final ValueNotifier<Offset> mousePosition = ValueNotifier(Offset.zero);

  CellKey? dragStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              ProgramElementConfig? selectedElement = sheetController.getHoveredElement(details.globalPosition);
              if( selectedElement is ProgramCellConfig ) {
                dragStart = selectedElement.cellKey;
                sheetController.updateSelection(SheetSingleSelection(dragStart!));
              }
            },
            onPanUpdate: (DragUpdateDetails details) {
              ProgramElementConfig? selectedElement = sheetController.getHoveredElement(details.globalPosition);
              if( selectedElement is ProgramCellConfig ) {
                sheetController.updateSelection(SheetRangeSelection(start: dragStart!, end: selectedElement.cellKey));
              }
            },
            onPanEnd: (DragEndDetails details) {
              ProgramElementConfig? selectedElement = sheetController.getHoveredElement(details.globalPosition);
              if( selectedElement is ProgramCellConfig ) {
                sheetController.updateSelection(SheetRangeSelection(start: dragStart!, end: selectedElement.cellKey));
              }
              dragStart = null;
            },
            onTap: () {
              ProgramElementConfig? selectedElement = sheetController.getHoveredElement(mousePosition.value);
              if( selectedElement is ProgramCellConfig ) {
                sheetController.updateSelection(SheetSingleSelection(selectedElement.cellKey));
              }
            },
            child: MouseRegion(
              onHover: (event) => mousePosition.value = event.localPosition,

              child: SheetGrid(sheetController: sheetController),
            ),
          ),
        ),
        SheetFooter(sheetController: sheetController, mousePosition: mousePosition),
      ],
    );
  }
}

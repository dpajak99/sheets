import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/types/sheet_selection.dart';
import 'package:sheets/utils/direction.dart';

class SelectionFillRecognizer {
  final SheetController sheetController;
  final SheetSelection sheetSelection;

  SelectionFillRecognizer.from(this.sheetSelection, this.sheetController);

  void handle(SheetItemConfig selectionEnd) {
    SelectionCellCorners? corners = sheetSelection.selectionCellCorners;
    if (selectionEnd is! CellConfig) return;
    if (corners == null) return;

    Direction direction = corners.getRelativePosition(selectionEnd.index);

    if(sheetSelection.contains(selectionEnd.index)) {
      return sheetController.selectionController.custom(sheetSelection);
    }

    late CellIndex start;
    late CellIndex end;

    switch (direction) {
      case Direction.top:
        start = corners.topLeft.move(-1, 0);
        end = CellIndex(rowIndex: selectionEnd.index.rowIndex, columnIndex: corners.topRight.columnIndex);
        break;
      case Direction.bottom:
        start = CellIndex(rowIndex: selectionEnd.index.rowIndex, columnIndex: corners.bottomLeft.columnIndex);
        end = corners.bottomRight.move(1, 0);
        break;
      case Direction.left:
        start = corners.topLeft.move(0, -1);
        end = CellIndex(rowIndex: corners.bottomLeft.rowIndex, columnIndex: selectionEnd.index.columnIndex);
        break;
      case Direction.right:
        start = CellIndex(rowIndex: corners.topRight.rowIndex, columnIndex: selectionEnd.index.columnIndex);
        end = corners.bottomRight.move(0, 1);
        break;
    }

    SheetFillSelection sheetFillSelection = SheetFillSelection(
      fillDirection: direction,
      baseSelection: sheetSelection,
      start: start,
      end: end,
      completed: false,
    );

    sheetController.selectionController.custom(sheetFillSelection);
  }
}

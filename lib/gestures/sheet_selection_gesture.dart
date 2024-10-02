import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/sheet_selection_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_drag_gesture.dart';
import 'package:sheets/core/sheet_item_config.dart';
import 'package:sheets/gestures/sheet_tap_gesture.dart';
import 'package:sheets/selection/selection_utils.dart';
import 'package:sheets/selection/types/sheet_selection.dart';

class SheetSingleSelectionGesture extends SheetTapGesture {
  SheetSingleSelectionGesture(super.details);

  SheetSingleSelectionGesture.from(SheetTapGesture tapGesture) : super(tapGesture.details);

  @override
  void resolve(SheetController controller) {
    SheetSelectionController selectionController = controller.selectionController;

    if (controller.keyboard.areKeysPressed([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft])) {
      CellIndex selectionStart = selectionController.selection.end;
      SheetSelection? sheetSelection = switch (_hoveredItemIndex) {
        CellIndex index => SelectionUtils.getRangeSelection(start: selectionStart, end: index, completed: true),
        ColumnIndex index => SelectionUtils.getColumnRangeSelection(start: selectionStart.columnIndex, end: index),
        RowIndex index => SelectionUtils.getRowRangeSelection(start: selectionStart.rowIndex, end: index),
        (_) => null,
      };

      if (sheetSelection != null) {
        return selectionController.selectMultiple(
          <CellIndex>[...selectionController.selection.selectedCells, ...sheetSelection.selectedCells],
          endCell: sheetSelection.end,
        );
      }
    }

    if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      return switch (_hoveredItemIndex) {
        CellIndex index => selectionController.toggleCell(index),
        ColumnIndex index => selectionController.toggleColumn(index),
        RowIndex index => selectionController.toggleRow(index),
        (_) => () {},
      };
    }

    if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
      CellIndex selectionStart = selectionController.selection.start;
      return switch (_hoveredItemIndex) {
        CellIndex index => selectionController.selectRange(start: selectionStart, end: index, completed: true),
        ColumnIndex index => selectionController.selectColumnRange(start: selectionStart.columnIndex, end: index),
        RowIndex index => selectionController.selectRowRange(start: selectionStart.rowIndex, end: index),
        (_) => () {},
      };
    }

    return switch (_hoveredItemIndex) {
      CellIndex index => selectionController.selectSingle(index),
      ColumnIndex index => selectionController.selectColumn(index),
      RowIndex index => selectionController.selectRow(index),
      (_) => () {},
    };
  }

  SheetItemIndex? get _hoveredItemIndex => details.hoveredItem?.index;

  @override
  List<Object?> get props => [details];
}

class SheetSelectionStartGesture extends SheetDragGesture {
  SheetSelectionStartGesture(super.endDetails);

  SheetSelectionStartGesture.from(SheetDragGesture dragGesture) : super(dragGesture.endDetails);

  @override
  void resolve(SheetController controller) {}
}

class SheetSelectionUpdateGesture extends SheetDragUpdateGesture {
  SheetSelectionUpdateGesture(super.endDetails, {required MouseSelectionDetails super.startDetails});

  factory SheetSelectionUpdateGesture.from(SheetDragUpdateGesture dragGesture, {required SheetSelection selection}) {
    return SheetSelectionUpdateGesture(
      dragGesture.endDetails,
      startDetails: MouseSelectionDetails(
        mousePosition: dragGesture.startDetails.mousePosition,
        hoveredItem: dragGesture.startDetails.hoveredItem,
        initialSelection: selection,
      ),
    );
  }

  @override
  List<Object?> get props => [endDetails, startDetails];

  @override
  void resolve(SheetController controller) {
    SheetSelection? sheetSelection = switch (startDetails.hoveredItem?.index) {
      CellIndex index => _handleCellDragUpdate(index),
      ColumnIndex index => _handleColumnDragUpdate(index),
      RowIndex index => _handleRowDragUpdate(index),
      _ => null,
    };

    if (sheetSelection != null) {
      if (controller.keyboard.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
        controller.selectionController.selectMultiple(<CellIndex>[...startDetails.initialSelection.selectedCells, ...sheetSelection.selectedCells]);
      } else {
        controller.selectionController.custom(sheetSelection);
      }
    }
  }

  @override
  MouseSelectionDetails get startDetails => super.startDetails as MouseSelectionDetails;

  SheetSelection? _handleCellDragUpdate(CellIndex start) {
    return switch (endDetails.hoveredItem?.index) {
      CellIndex index => SelectionUtils.getRangeSelection(start: start, end: index),
      (_) => null,
    };
  }

  SheetSelection? _handleColumnDragUpdate(ColumnIndex start) {
    late ColumnIndex end;

    switch (endDetails.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.cellIndex.columnIndex;
        break;
      case ColumnConfig columnConfig:
        end = columnConfig.columnIndex;
        break;
      default:
        return null;
    }

    return SelectionUtils.getColumnRangeSelection(start: start, end: end);
  }

  SheetSelection? _handleRowDragUpdate(RowIndex start) {
    late RowIndex end;

    switch (endDetails.hoveredItem) {
      case CellConfig cellConfig:
        end = cellConfig.cellIndex.rowIndex;
        break;
      case RowConfig rowConfig:
        end = rowConfig.rowIndex;
        break;
      default:
        return null;
    }

    return SelectionUtils.getRowRangeSelection(start: start, end: end);
  }
}

class SheetSelectionEndGesture extends SheetDragGesture {
  SheetSelectionEndGesture(super.endDetails);

  SheetSelectionEndGesture.from(SheetDragGesture dragGesture) : super(dragGesture.endDetails);

  @override
  List<Object?> get props => [endDetails];

  @override
  void resolve(SheetController controller) {
    controller.selectionController.completeSelection();
  }
}

class MouseSelectionDetails extends SheetDragDetails {
  final SheetSelection initialSelection;

  MouseSelectionDetails({
    required super.mousePosition,
    required super.hoveredItem,
    required this.initialSelection,
  });
}

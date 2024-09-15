import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/controller/selection/recognizers/selection_drag_recognizer.dart';
import 'package:sheets/controller/selection/recognizers/selection_tap_recognizer.dart';
import 'package:sheets/controller/sheet_controller.dart';

class SheetTapDetails with EquatableMixin {
  final DateTime tapTime;
  final SheetItemConfig hoveredItem;

  SheetTapDetails({
    required this.tapTime,
    required this.hoveredItem,
  });

  SheetTapDetails.create(SheetItemConfig hoveredItem) : this(tapTime: DateTime.now(), hoveredItem: hoveredItem);

  bool isDoubleTap(SheetTapDetails other) {
    return tapTime.difference(other.tapTime) < const Duration(milliseconds: 300) && hoveredItem == other.hoveredItem;
  }

  @override
  List<Object?> get props => [tapTime, hoveredItem];
}

class SheetCursorController extends ChangeNotifier {
  final SheetController sheetController;

  Offset position = Offset.zero;
  SheetItemConfig? hoveredElement;

  ValueNotifier<SystemMouseCursor> cursorListener = ValueNotifier(SystemMouseCursors.basic);

  SheetTapDetails? lastTap;

  SelectionDragRecognizer? selectionDragRecognizer;

  SheetCursorController(this.sheetController);

  ColumnConfig? _resizedColumn;

  void setCursor(SystemMouseCursor previous, SystemMouseCursor next) {
    if (cursorListener.value == previous) {
      cursorListener.value = next;
    }
  }

  set resizedColumn(ColumnConfig? resizedColumn) {
    if (selectionDragRecognizer == null) {
      _resizedColumn = resizedColumn;
      cursorListener.value = resizedColumn != null ? SystemMouseCursors.resizeColumn : SystemMouseCursors.basic;
    }
  }

  RowConfig? _resizedRow;

  set resizedRow(RowConfig? resizedRow) {
    if (selectionDragRecognizer == null) {
      _resizedRow = resizedRow;
      cursorListener.value = resizedRow != null ? SystemMouseCursors.resizeRow : SystemMouseCursors.basic;
    }
  }

  void scrollBy(Offset delta) {
    sheetController.scrollBy(delta);
    hoveredElement = sheetController.getHoveredElement(position);
    notifyListeners();
  }

  bool get hasActiveAction {
    return isResizing || selectionDragRecognizer != null;
  }

  bool get isResizing => _resizedRow != null || _resizedColumn != null;

  void dragStart(DragStartDetails details) {
    position = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position);
    hoveredElement = dragHoveredElement;

    if (isResizing) {
    } else if (dragHoveredElement != null) {
      selectionDragRecognizer = SelectionDragRecognizer(sheetController, dragHoveredElement);
    }

    notifyListeners();
  }

  void dragUpdate(DragUpdateDetails details) {
    position = details.globalPosition;
    SheetItemConfig? dragHoveredElement = sheetController.getHoveredElement(position);
    hoveredElement = dragHoveredElement;

    if (isResizing) {
    } else if (dragHoveredElement != null) {
      selectionDragRecognizer?.handleDragUpdate(dragHoveredElement);
    }

    notifyListeners();
  }

  void dragEnd(DragEndDetails details) {
    position = details.globalPosition;

    if (isResizing) {
    } else {
      selectionDragRecognizer?.complete();
      selectionDragRecognizer = null;
    }
    notifyListeners();
  }

  void updateOffset(Offset newOffset) {
    position = newOffset;
    hoveredElement = sheetController.getHoveredElement(position);
    notifyListeners();
  }

  void tap() {
    if (hoveredElement != null) {
      SheetTapDetails currentTap = SheetTapDetails.create(hoveredElement!);

      if (lastTap != null && currentTap.isDoubleTap(lastTap!) && sheetController.keyboardController.anyKeyActive == false) {
        doubleTap();
      } else if (hoveredElement != null) {
        SelectionTapRecognizer(sheetController).handleItemTap(hoveredElement!);
      }
      lastTap = currentTap;
    }
  }

  void doubleTap() {
    switch (hoveredElement) {
      case CellConfig cellConfig:
        sheetController.edit(cellConfig);
    }
  }
}

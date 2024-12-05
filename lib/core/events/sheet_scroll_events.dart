import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';

abstract class ScrollEvent extends SheetEvent {
  @override
  SheetAction<SheetEvent> createAction(SheetController controller);
}

abstract class ScrollAction<T extends ScrollEvent> extends SheetAction<T> {
  ScrollAction(super.event, super.controller);
}

// Scroll By
class ScrollByEvent extends ScrollEvent {
  ScrollByEvent(this.delta);

  final Offset delta;

  @override
  SheetAction<SheetEvent> createAction(SheetController controller) => ScrollByAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
      rebuildHorizontalScroll: true,
      rebuildVerticalScroll: true,
      rebuildViewport: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[delta];
}

class ScrollByAction extends ScrollAction<ScrollByEvent> {
  ScrollByAction(super.event, super.controller);

  @override
  void execute() {
    HardwareKeyboard keyboard = HardwareKeyboard.instance;

    if (keyboard.isShiftPressed) {
      controller.scroll.scrollBy(event.delta.reverse());
    } else {
      controller.scroll.scrollBy(event.delta);
    }
  }
}

// Scroll To Element
class ScrollToElementEvent extends ScrollEvent {
  ScrollToElementEvent(this.index);

  final SheetIndex index;

  @override
  SheetAction<SheetEvent> createAction(SheetController controller) => ScrollToElementAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
      rebuildHorizontalScroll: true,
      rebuildVerticalScroll: true,
      rebuildViewport: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[index];
}

class ScrollToElementAction extends ScrollAction<ScrollToElementEvent> {
  ScrollToElementAction(super.event, super.controller);

  @override
  void execute() {
    Offset scrollOffset = controller.scroll.offset;

    Rect cellSheetCoords = event.index.getSheetCoordinates(controller.data);

    double sheetWidth = controller.viewport.rect.innerLocal.width;
    double sheetHeight = controller.viewport.rect.innerLocal.height;

    double topMargin = cellSheetCoords.top;
    double bottomMargin = cellSheetCoords.bottom;
    double leftMargin = cellSheetCoords.left;
    double rightMargin = cellSheetCoords.right;

    if (topMargin < scrollOffset.dy) {
      double shift = cellSheetCoords.top - 1;
      controller.scroll.scrollToVertical(shift);
    } else if (bottomMargin > scrollOffset.dy + sheetHeight) {
      double shift = cellSheetCoords.bottom - sheetHeight + 1;
      controller.scroll.scrollToVertical(shift);
    } else if (leftMargin < scrollOffset.dx) {
      double shift = cellSheetCoords.left - 1;
      controller.scroll.scrollToHorizontal(shift);
    } else if (rightMargin > scrollOffset.dx + sheetWidth) {
      double shift = cellSheetCoords.right - sheetWidth + 1;
      controller.scroll.scrollToHorizontal(shift);
    }
  }
}

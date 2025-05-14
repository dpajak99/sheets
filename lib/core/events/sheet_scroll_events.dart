import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/utils/extensions/offset_extensions.dart';

abstract class ScrollEvent extends SheetEvent {
  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet);
}

abstract class ScrollAction<T extends ScrollEvent> extends SheetAction<T> {
  ScrollAction(super.event, super.worksheet);
}

// Scroll By
class ScrollByEvent extends ScrollEvent {
  ScrollByEvent(this.delta);

  final Offset delta;

  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet) => ScrollByAction(this, worksheet);

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
  ScrollByAction(super.event, super.worksheet);

  @override
  void execute() {
    HardwareKeyboard keyboard = HardwareKeyboard.instance;

    if (keyboard.isShiftPressed) {
      worksheet.scroll.scrollBy(event.delta.reverse());
    } else {
      worksheet.scroll.scrollBy(event.delta);
    }
  }
}

// Scroll To Element
class ScrollToElementEvent extends ScrollEvent {
  ScrollToElementEvent(this.index);

  final SheetIndex index;

  @override
  SheetAction<SheetEvent> createAction(Worksheet worksheet) => ScrollToElementAction(this, worksheet);

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
  ScrollToElementAction(super.event, super.worksheet);

  @override
  void execute() {
    Offset scrollOffset = worksheet.scroll.offset;

    Rect cellSheetCoords = event.index.getSheetCoordinates(worksheet.data);

    double sheetWidth = worksheet.viewport.rect.innerLocal.width;
    double sheetHeight = worksheet.viewport.rect.innerLocal.height;

    double topMargin = cellSheetCoords.top;
    double bottomMargin = cellSheetCoords.bottom;
    double leftMargin = cellSheetCoords.left;
    double rightMargin = cellSheetCoords.right;

    if (topMargin < scrollOffset.dy) {
      double shift = cellSheetCoords.top - 1;
      worksheet.scroll.scrollToVertical(shift);
    } else if (bottomMargin > scrollOffset.dy + sheetHeight) {
      double shift = cellSheetCoords.bottom - sheetHeight + 1;
      worksheet.scroll.scrollToVertical(shift);
    } else if (leftMargin < scrollOffset.dx) {
      double shift = cellSheetCoords.left - 1;
      worksheet.scroll.scrollToHorizontal(shift);
    } else if (rightMargin > scrollOffset.dx + sheetWidth) {
      double shift = cellSheetCoords.right - sheetWidth + 1;
      worksheet.scroll.scrollToHorizontal(shift);
    }
  }
}

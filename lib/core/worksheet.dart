import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/silent_value_notifier.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';

class SheetRebuildNotifier extends ChangeNotifier {
  SheetRebuildConfig _value = SheetRebuildConfig();

  void notify(SheetRebuildConfig value) {
    _value = value;
    notifyListeners();
  }

  SheetRebuildConfig get value => _value;
}

class Worksheet extends SheetRebuildNotifier {
  Worksheet({
    required this.data,
  }) {
    editableCellNotifier = SilentValueNotifier<EditableViewportCell?>(null);

    scroll = SheetScrollController();
    viewport = SheetViewport(data);
    selection = SelectionState.defaultSelection();

    scroll.setContentSize(data.scrollableContentSize);
  }

  final FocusNode sheetFocusNode = FocusNode()..requestFocus();
  final WorksheetData data;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final SilentValueNotifier<EditableViewportCell?> editableCellNotifier;

  late SelectionState selection;

  final List<SheetEvent> _eventsQueue = <SheetEvent>[];

  void resolve(SheetEvent event) {
    final bool isMainEvent = _eventsQueue.isEmpty;
    final SheetAction<SheetEvent>? action = event.createAction(this);
    if (action == null) return;

    _eventsQueue.add(event);
    unawaited(_executeAction(isMainEvent, action));
  }

  Future<void> _executeAction(
    bool isMainAction,
    SheetAction<SheetEvent> action,
  ) async {
    await action.execute();
    if (!isMainAction) return;

    final SheetRebuildConfig config = _collectRebuildConfig();
    _rebuildViewportIfNeeded(config);
    notify(config);
    _eventsQueue.clear();
  }

  SheetRebuildConfig _collectRebuildConfig() {
    return _eventsQueue.fold(
      SheetRebuildConfig(),
      (SheetRebuildConfig value, SheetEvent event) =>
          value.combine(event.rebuildConfig),
    );
  }

  void _rebuildViewportIfNeeded(SheetRebuildConfig config) {
    if (config.rebuildViewport || config.rebuildCellsLayer) {
      viewport.rebuild(scroll.offset);
    }
  }

  bool isFullyVisible(SheetIndex index) {
    Offset scrollOffset = scroll.offset;
    Rect cellSheetCoords = index.getSheetCoordinates(data);
    Rect sheetInnerRect = viewport.rect.innerLocal;

    return cellSheetCoords.top >= scrollOffset.dy &&
        cellSheetCoords.bottom <= scrollOffset.dy + sheetInnerRect.height &&
        cellSheetCoords.left >= scrollOffset.dx &&
        cellSheetCoords.right <= scrollOffset.dx + sheetInnerRect.width;
  }

  List<CellIndex> get selectedCells {
    return selection.value.getSelectedCells(data.columnCount, data.rowCount);
  }

  bool get isEditingMode => editableCellNotifier.value != null;

  SelectionStyle getSelectionStyle() {
    CellProperties cellProperties = data.cells.get(selection.value.mainCell);

    if (editableCellNotifier.value == null) {
      return CellSelectionStyle(cellProperties: cellProperties);
    }

    SheetTextEditingController textEditingController =
        editableCellNotifier.value!.controller;
    if (textEditingController.selection.isCollapsed) {
      return CursorSelectionStyle(
        cellProperties: cellProperties,
        textStyle: textEditingController.previousStyle,
      );
    } else {
      return CursorRangeSelectionStyle(
        cellProperties: cellProperties,
        textStyles: textEditingController.selectionStyles,
      );
    }
  }
}

class EditableViewportCell with EquatableMixin {
  EditableViewportCell({
    required this.focusNode,
    required this.cell,
  }) {
    SheetRichText richText = cell.properties.editableRichText;
    controller = SheetTextEditingController(
      textAlign: cell.properties.visibleTextAlign,
      text: EditableTextSpan.fromTextSpan(richText.toTextSpan()),
    );
  }

  final FocusNode focusNode;
  final ViewportCell cell;
  late final SheetTextEditingController controller;

  @override
  List<Object?> get props => <Object?>[cell];
}

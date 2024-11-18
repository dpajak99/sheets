import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:sheets/core/auto_fill_engine.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/gestures/sheet_resize_gestures.dart';
import 'package:sheets/core/keyboard/keyboard_listener.dart';
import 'package:sheets/core/keyboard/keyboard_shortcuts.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/values/actions/cell_style_format_action.dart';
import 'package:sheets/core/values/actions/text_style_format_actions.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/extensions/silent_value_notifier.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';
import 'package:sheets/widgets/text/sheet_text_field_actions.dart';

class SheetController {
  SheetController({
    required this.properties,
  }) {
    _editableCellNotifier = SilentValueNotifier<EditableViewportCell?>(null);

    scroll = SheetScrollController();
    viewport = SheetViewport(properties, scroll);
    keyboard = KeyboardListener();
    mouse = MouseListener(
      mouseActionRecognizers: <MouseGestureRecognizer>[
        MouseDoubleTapRecognizer(),
        MouseSelectionGestureRecognizer(),
      ],
      sheetController: this,
    );
    selection = SelectionState.defaultSelection(
      onChanged: (_) => resetActiveCell(),
      onFill: fill,
    );

    _setupKeyboardShortcuts();
  }

  final SheetProperties properties;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final KeyboardListener keyboard;
  late final MouseListener mouse;
  late final SilentValueNotifier<EditableViewportCell?> _editableCellNotifier;

  late SelectionState selection;

  List<CellIndex> get selectedCells {
    return selection.value.getSelectedCells(properties.columnCount, properties.rowCount);
  }

  Future<void> dispose() async {
    await keyboard.dispose();
  }

  SilentValueNotifier<EditableViewportCell?> get activeCellNotifier => _editableCellNotifier;

  void formatSelection(FormatAction formatAction) {
    List<CellIndex> selectedCells = selection.value.getSelectedCells(properties.columnCount, properties.rowCount);
    if (activeCellNotifier.value != null && formatAction is TextStyleFormatAction) {
      TextStyleFormatAction textStyleFormatAction = formatAction;

      SheetTextEditingController controller = activeCellNotifier.value!.controller;
      unawaited(controller.handleAction(
        SheetTextFieldActions.format((material.TextStyle mergedTextStyle, material.TextStyle previousTextStyle) {
          return textStyleFormatAction.format(mergedTextStyle, previousTextStyle);
        }),
      ));
    } else {
      properties.formatSelection(selectedCells, formatAction);
      if (formatAction.autoresize) {
        properties.ensureMinimalRowsHeight(selectedCells.map((CellIndex cellIndex) => cellIndex.row).toSet().toList());
      }
    }
  }

  SelectionStyle getSelectionStyle() {
    CellProperties cellProperties = properties.getCellProperties(selection.value.mainCell);

    if (activeCellNotifier.value == null) {
      return CellSelectionStyle(cellProperties: cellProperties);
    }

    SheetTextEditingController textEditingController = activeCellNotifier.value!.controller;
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

  Future<void> fill(SheetFillSelection selection) async {
    List<CellIndex> selectedCells = selection.baseSelection.getSelectedCells(properties.columnCount, properties.rowCount);
    List<CellIndex> fillCells = selection.getSelectedCells(properties.columnCount, properties.rowCount);

    Map<CellIndex, CellProperties> baseProperties = <CellIndex, CellProperties>{
      for (CellIndex index in selectedCells) index: properties.getCellProperties(index),
    };
    Map<CellIndex, CellProperties> fillProperties = <CellIndex, CellProperties>{
      for (CellIndex index in fillCells) index: properties.getCellProperties(index),
    };

    await AutoFillEngine(selection.fillDirection, baseProperties, fillProperties).resolve(this);
  }

  void resizeColumn(ColumnIndex column, double width) {
    SheetResizeColumnGesture(column, width).resolve(this);
  }

  void resizeRow(RowIndex row, double height) {
    SheetResizeRowGesture(row, height).resolve(this);
  }

  CellProperties getCellProperties(CellIndex index) {
    return properties.getCellProperties(index);
  }

  void setCellValue(CellIndex index, SheetRichText value, {Size? size}) {
    properties.setRichText(index, value);
    if (size != null) {
      SheetResizeCellGesture(index, size).resolve(this);
    }
    resetActiveCell();
  }

  void resetActiveCell() {
    _editableCellNotifier.setValue(null);
    keyboard.enableListener();
  }

  void setActiveCellIndex(SheetIndex index, {String? value}) {
    ViewportCell? cell = viewport.ensureIndexFullyVisible(index) as ViewportCell?;
    if (cell == null) {
      return;
    }
    setActiveViewportCell(cell, value: value);
  }

  void setActiveViewportCell(ViewportCell cell, {String? value}) {
    selection.update(SheetSingleSelection(cell.index, fillHandleVisible: false), notifyAll: false);

    if (value != null) {
      _editableCellNotifier.setValue(EditableViewportCell(cell..setText(value)));
    } else {
      _editableCellNotifier.setValue(EditableViewportCell(cell));
    }

    keyboard.disableListener();
  }

  void _setupKeyboardShortcuts() {
    keyboard.pressStream.listen((KeyboardState state) {
      return switch (state) {
        KeyboardShortcuts.selectAll => selection.update(SheetSelectionFactory.all()),
        KeyboardShortcuts.addRows => properties.addRows(10),
        KeyboardShortcuts.addColumns => properties.addColumns(10),
        KeyboardShortcuts.enter => setActiveCellIndex(selection.value.mainCell),
        (_) => _handleKeyboardKey(state.keys),
      };
    });

    keyboard.pressOrHoldStream.listen((KeyboardState state) {
      if (state.containsState(KeyboardShortcuts.moveUp)) {
        SheetSelectionMoveGesture(-1, 0).resolve(this);
      }
      if (state.containsState(KeyboardShortcuts.moveDown)) {
        SheetSelectionMoveGesture(1, 0).resolve(this);
      }
      if (state.containsState(KeyboardShortcuts.moveLeft)) {
        SheetSelectionMoveGesture(0, -1).resolve(this);
      }
      if (state.containsState(KeyboardShortcuts.moveRight)) {
        SheetSelectionMoveGesture(0, 1).resolve(this);
      }
    });
  }

  void _handleKeyboardKey(List<LogicalKeyboardKey> key) {
    List<String> keyLabels = key
        .map((LogicalKeyboardKey logicalKeyboardKey) => logicalKeyboardKey.keyLabel)
        .toList()
        .where((String label) => label.length == 1)
        .toList();

    if (keyLabels.isNotEmpty) {
      bool uppercase = key.contains(LogicalKeyboardKey.shiftLeft) || key.contains(LogicalKeyboardKey.shiftRight);
      String value = keyLabels.first;

      if (uppercase) {
        value = value.toUpperCase();
      } else {
        value = value.toLowerCase();
      }

      setActiveCellIndex(selection.value.mainCell, value: value);
    }

    bool clearCell = key.contains(LogicalKeyboardKey.delete) || key.contains(LogicalKeyboardKey.backspace);
    if (clearCell) {
      setCellValue(selection.value.mainCell, SheetRichText());
    }
  }
}

class EditableViewportCell with EquatableMixin {
  EditableViewportCell(this.cell) {
    SheetRichText richText = cell.properties.editableRichText;
    controller = SheetTextEditingController(
      textAlign: cell.properties.visibleTextAlign,
      text: EditableTextSpan.fromTextSpan(richText.toTextSpan()),
    );
  }

  late final ViewportCell cell;
  late final SheetTextEditingController controller;

  @override
  List<Object?> get props => <Object?>[cell];
}

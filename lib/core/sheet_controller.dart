import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/auto_fill_engine.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/gestures/sheet_resize_gestures.dart';
import 'package:sheets/core/mouse/mouse_gesture_recognizer.dart';
import 'package:sheets/core/mouse/mouse_listener.dart';
import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
import 'package:sheets/core/selection/selection_state.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/selection/sheet_selection_gesture.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/extensions/silent_value_notifier.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';
import 'package:sheets/widgets/text/sheet_text_field_actions.dart';

class SheetController {
  SheetController({
    required this.properties,
  }) {
    _editableCellNotifier = SilentValueNotifier<EditableViewportCell?>(null);

    scroll = SheetScrollController();
    viewport = SheetViewport(properties, scroll);
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
  }

  final FocusNode sheetFocusNode = FocusNode()..requestFocus();
  final SheetProperties properties;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final MouseListener mouse;
  late final SilentValueNotifier<EditableViewportCell?> _editableCellNotifier;

  late SelectionState selection;

  List<CellIndex> get selectedCells {
    return selection.value.getSelectedCells(properties.columnCount, properties.rowCount);
  }

  Future<void> dispose() async {}

  SilentValueNotifier<EditableViewportCell?> get activeCellNotifier => _editableCellNotifier;

  bool get hasActiveCell => activeCellNotifier.value != null;

  void formatSelection(StyleFormatIntent intent) {
    List<CellIndex> selectedCells = selection.value.getSelectedCells(properties.columnCount, properties.rowCount);
    SelectionStyle selectionStyle = getSelectionStyle();

    if (hasActiveCell && intent is TextStyleFormatIntent) {
      SheetTextEditingController controller = activeCellNotifier.value!.controller;
      unawaited(controller.handleAction(SheetTextFieldActions.format(intent)));
      return;
    }

    switch (intent) {
      case TextStyleFormatIntent intent:
        TextStyleFormatAction<TextStyleFormatIntent> formatAction = intent.createAction(baseTextStyle: selectionStyle.textStyle);
        properties.formatSelection(selectedCells, formatAction);
      case CellStyleFormatIntent intent:
        CellStyleFormatAction<CellStyleFormatIntent> formatAction = intent.createAction(cellStyle: selectionStyle.cellStyle);
        properties.formatSelection(selectedCells, formatAction);
      case SheetStyleFormatIntent intent:
        SheetStyleFormatAction<SheetStyleFormatIntent> formatAction = intent.createAction();
        properties.formatSelection(selectedCells, formatAction);
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
    sheetFocusNode.requestFocus();
    _editableCellNotifier.setValue(null);
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

    sheetFocusNode.unfocus();
    material.FocusNode textFieldFocusNode = material.FocusNode();
    if (value != null) {
      _editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: cell..setText(value)));
    } else {
      _editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: cell));
    }
  }

  void startEditing([String? initialValue]) {
    if (activeCellNotifier.value == null) {
      setActiveCellIndex(selection.value.mainCell, value: initialValue);
    }
  }

  void moveSelection(Offset offset) {
    SheetSelectionMoveGesture(offset.dx.toInt(), offset.dy.toInt()).resolve(this);
  }

  void clearSelection() {
    properties.clearCells(selectedCells);
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

  final material.FocusNode focusNode;
  final ViewportCell cell;
  late final SheetTextEditingController controller;

  @override
  List<Object?> get props => <Object?>[cell];
}

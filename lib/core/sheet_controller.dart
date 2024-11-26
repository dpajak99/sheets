import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
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
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/utils/silent_value_notifier.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';
import 'package:sheets/widgets/text/sheet_text_field_actions.dart';

class SheetController {
  SheetController({
    required this.dataManager,
  }) {
    _editableCellNotifier = SilentValueNotifier<EditableViewportCell?>(null);

    scroll = SheetScrollController();
    viewport = SheetViewport(dataManager, scroll);
    mouse = MouseListener(
      mouseActionRecognizers: <MouseGestureRecognizer>[
        MouseDoubleTapRecognizer(),
        MouseSelectionGestureRecognizer(),
      ],
      sheetController: this,
    );
    selection = SelectionState.defaultSelection(
      onChanged: (_) => disableEditing(),
      onFill: fill,
    );
  }

  final FocusNode sheetFocusNode = FocusNode()..requestFocus();
  final SheetDataManager dataManager;
  late final SheetViewport viewport;
  late final SheetScrollController scroll;
  late final MouseListener mouse;
  late final SilentValueNotifier<EditableViewportCell?> _editableCellNotifier;

  late SelectionState selection;

  List<CellIndex> get selectedCells {
    return selection.value.getSelectedCells(dataManager.columnCount, dataManager.rowCount);
  }

  Future<void> dispose() async {}

  SilentValueNotifier<EditableViewportCell?> get editableCellNotifier => _editableCellNotifier;

  bool get isEditingMode => editableCellNotifier.value != null;

  void formatSelection(StyleFormatIntent intent) {
    List<CellIndex> selectedCells = selection.value.getSelectedCells(dataManager.columnCount, dataManager.rowCount);
    SelectionStyle selectionStyle = getSelectionStyle();

    if (isEditingMode && intent is TextStyleFormatIntent) {
      SheetTextEditingController controller = editableCellNotifier.value!.controller;
      unawaited(controller.handleAction(SheetTextFieldActions.format(intent)));
      return;
    }

    StyleFormatAction<StyleFormatIntent> formatAction = switch (intent) {
      TextStyleFormatIntent intent => intent.createAction(baseTextStyle: selectionStyle.textStyle),
      CellStyleFormatIntent intent => intent.createAction(cellStyle: selectionStyle.cellStyle),
      SheetStyleFormatIntent intent => intent.createAction(),
      (_) => throw UnimplementedError(),
    };

    dataManager.write((SheetData data) {
      data.formatSelection(selectedCells, formatAction);
    });
  }

  SelectionStyle getSelectionStyle() {
    CellProperties cellProperties = dataManager.getCellProperties(selection.value.mainCell);

    if (editableCellNotifier.value == null) {
      return CellSelectionStyle(cellProperties: cellProperties);
    }

    SheetTextEditingController textEditingController = editableCellNotifier.value!.controller;
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
    List<CellIndex> selectedCells = selection.baseSelection.getSelectedCells(dataManager.columnCount, dataManager.rowCount);
    List<CellIndex> fillCells = selection.getSelectedCells(dataManager.columnCount, dataManager.rowCount);

    List<IndexedCellProperties> baseProperties = <IndexedCellProperties>[
      for (CellIndex index in selectedCells)
        IndexedCellProperties(index: index, properties: dataManager.getCellProperties(index)),
    ];
    List<IndexedCellProperties> fillProperties = <IndexedCellProperties>[
      for (CellIndex index in fillCells) IndexedCellProperties(index: index, properties: dataManager.getCellProperties(index)),
    ];

    List<IndexedCellProperties> filledCells = AutoFillEngine(selection.fillDirection, baseProperties, fillProperties).resolve();
    dataManager.write((SheetData data) => data.setCellsProperties(filledCells));
  }

  void resizeColumn(ColumnIndex column, double width) {
    SheetResizeColumnGesture(column, width).resolve(this);
  }

  void resizeRow(RowIndex row, double height) {
    SheetResizeRowGesture(row, height).resolve(this);
  }

  CellProperties getCellProperties(CellIndex index) {
    return dataManager.getCellProperties(index);
  }

  void setCellValue(CellIndex index, SheetRichText value) {
    dataManager.write((SheetData data) {
      data.setText(index, value);
      data.adjustCellHeight(index);
    });
  }

  void mergeSelection() {
    if(selection.value is SheetRangeSelection) {
      List<CellIndex> selectedCells = selection.value.getSelectedCells(dataManager.columnCount, dataManager.rowCount);
      selection.update(SheetSingleSelection(selection.value.mainCell));
      dataManager.write((SheetData data) {
        data.mergeCells(selectedCells);
      });
    }
  }

  void enableEditing([String? initialValue]) {
    if (editableCellNotifier.value == null) {
      setActiveCellIndex(selection.value.mainCell, value: initialValue);
    }
  }

  void disableEditing() {
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
      _editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: cell.withText(value)));
    } else {
      _editableCellNotifier.setValue(EditableViewportCell(focusNode: textFieldFocusNode, cell: cell));
    }
  }

  void moveSelection(Offset offset) {
    SheetSelectionMoveGesture(offset.dx.toInt(), offset.dy.toInt()).resolve(this);
  }

  void clearSelection() {
    dataManager.write((SheetData data) => data.clearCells(selectedCells));
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

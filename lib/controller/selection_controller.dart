import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_single_selection.dart';

class SelectionState extends ChangeNotifier {
  late SheetProperties properties;
  late SheetSelection selection;

  SelectionState.defaultState() {
    selection = SheetSingleSelection.defaultSelection();
  }

  void save() {
    selection = selection.complete();
    notifyListeners();
  }

  void update(SheetSelection selection) {
    this.selection = selection;
    notifyListeners();
  }

  void updateProperties(SheetProperties properties) {
    this.properties = properties;
  }
}

class SelectionController extends ChangeNotifier {
  SelectionState state = SelectionState.defaultState();

  SheetSelection get visibleSelection => state.selection;

  SelectionController() {
    state.addListener(notifyListeners);
  }

  void applyTo(SheetController controller) {
    state.updateProperties(controller.sheetProperties);
  }

  void customSelection(SheetSelection customSelection) {
    state.update(customSelection);
  }

  void selectSingle(SheetIndex sheetItemIndex, {bool completed = false}) {
    state.update(SheetSelection.single(sheetItemIndex, completed: completed));
  }

  void selectRange({required SheetIndex start, required SheetIndex end, bool completed = false}) {
    state.update(SheetSelection.range(start: start, end: end, completed: completed));
  }

  void combine(SheetSelection selection, SheetSelection appendedSelection) {
    if (selection is SheetMultiSelection) {
      List<SheetSelection> previousSelections = selection.selections.toList();
      state.update(SheetSelection.multi(selections: [...previousSelections, appendedSelection]));
    } else {
      SheetSelection? previousSelection = selection;
      if (previousSelection is SheetSingleSelection) {
        previousSelection = SheetSelection.multi(selections: [previousSelection]);
      }

      state.update(SheetSelection.multi(selections: [previousSelection, appendedSelection]));
    }
  }

  void selectAll() {
    state.update(SheetSelection.all());
  }

  void completeSelection() {
    state.save();
  }
}

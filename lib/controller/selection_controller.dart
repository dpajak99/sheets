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
    SheetSelection completedSelection = selection.complete();
    completedSelection.applyProperties(properties);

    selection = completedSelection.simplify();

    notifyListeners();
  }

  void update(SheetSelection selection) {
    this.selection = selection;
    this.selection.applyProperties(properties);

    notifyListeners();
  }

  void updateProperties(SheetProperties properties) {
    this.properties = properties;
    selection.applyProperties(properties);
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

  void selectSingle(SheetItemIndex sheetItemIndex, {bool completed = false}) {
    state.update(SheetSelection.single(sheetItemIndex, completed: completed));
  }

  void selectRange({required SheetItemIndex start, required SheetItemIndex end, bool completed = false}) {
    state.update(SheetSelection.range(start: start, end: end, completed: completed));
  }

  void combine(SheetSelection selection, SheetSelection appendedSelection) {
    selection.applyProperties(state.properties);
    appendedSelection.applyProperties(state.properties);

    if (selection is SheetMultiSelection) {
      List<SheetSelection> previousSelections = selection.mergedSelections;
      state.update(SheetSelection.multi(
        selections: [
          ...previousSelections,
          appendedSelection,
        ],
        mainCell: appendedSelection.mainCell,
      ));
    } else {
      SheetSelection? previousSelection = selection;
      if (previousSelection is SheetSingleSelection) {
        previousSelection = SheetSelection.multi(selections: [previousSelection], mainCell: previousSelection.mainCell);
      }

      state.update(SheetSelection.multi(
        selections: [previousSelection, appendedSelection],
        mainCell: appendedSelection.mainCell,
      ));
    }
  }

  void selectAll() {
    state.update(SheetSelection.all());
  }

  void completeSelection() {
    state.save();
  }
}

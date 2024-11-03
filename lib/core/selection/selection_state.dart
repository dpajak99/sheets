import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_renderer.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/viewport/sheet_viewport.dart';

class SelectionState extends ChangeNotifier {
  SelectionState(this.value, {this.onChanged, this.onFill});

  SelectionState.defaultSelection({this.onChanged, this.onFill}) {
    value = SheetSingleSelection.defaultSelection();
  }

  final ValueChanged<SheetSelection>? onChanged;
  final ValueChanged<SheetFillSelection>? onFill;
  late SheetSelection value;

  void update(SheetSelection selection, {bool notifyAll = true}) {
    if (value != selection) {
      value = selection;
      if (notifyAll) {
        onChanged?.call(value);
      }
      notifyListeners();
    }
  }

  void complete() {
    if(value is SheetFillSelection) {
      onFill?.call(value as SheetFillSelection);
    }
    SheetSelection completedSelection = value.complete();
    if (value != completedSelection) {
      value = completedSelection;
      notifyListeners();
    }
  }

  String stringify() {
    return value.stringifySelection();
  }

  SheetSelectionRenderer<SheetSelection> createRenderer(SheetViewport viewport) {
    return value.createRenderer(viewport);
  }
}

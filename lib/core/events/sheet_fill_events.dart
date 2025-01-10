import 'package:sheets/core/auto_fill_engine.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/events/sheet_selection_events.dart';
import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';

// Start Fill
class StartFillSelectionEvent extends StartSelectionEvent {
  StartFillSelectionEvent(super.selectionStart);

  @override
  StartFillSelectionAction createAction(SheetController controller) => StartFillSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class StartFillSelectionAction extends StartSelectionAction {
  StartFillSelectionAction(super.event, super.controller);

  @override
  void execute() {}
}

// Update fill
class UpdateFillSelectionEvent extends UpdateSelectionEvent {
  UpdateFillSelectionEvent(super.selectionEnd);

  @override
  UpdateFillSelectionAction createAction(SheetController controller) => UpdateFillSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[selectionEnd];
}

class UpdateFillSelectionAction extends UpdateSelectionAction {
  UpdateFillSelectionAction(super.event, super.controller);

  @override
  void execute() {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      event.selectionEnd.index,
      controller.viewport.firstVisibleRow,
      controller.viewport.firstVisibleColumn,
    );
    selectedIndex = controller.worksheet.fillCellIndex(selectedIndex);

    SheetSelection previousSelection = controller.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);
    selectionBuilder.setStrategy(GestureSelectionStrategyFill(controller.worksheet));

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);

    controller.selection.update(updatedSelection);
    ensureFullyVisible(selectedIndex);
  }
}

// Complete fill
class CompleteFillSelectionEvent extends CompleteSelectionEvent {
  @override
  CompleteFillSelectionAction createAction(SheetController controller) => CompleteFillSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(
      rebuildSelection: true,
      rebuildData: true,
    );
  }

  @override
  List<Object?> get props => <Object?>[];
}

class CompleteFillSelectionAction extends CompleteSelectionAction {
  CompleteFillSelectionAction(super.event, super.controller);

  @override
  void execute() {
    if (controller.selection.value is! SheetFillSelection) {
      return;
    }
    Worksheet worksheet = controller.worksheet;
    SheetFillSelection fillSelection = controller.selection.value as SheetFillSelection;

    List<CellIndex> fillCells = fillSelection.getSelectedCells(worksheet.cols, worksheet.rows);
    List<CellIndex> templateCells = fillSelection.baseSelection.getSelectedCells(worksheet.cols, worksheet.rows);

    List<CellProperties> baseProperties = <CellProperties>[
      for (CellIndex index in templateCells) worksheet.getCell(index),
    ];
    List<CellProperties> fillProperties = <CellProperties>[
      for (CellIndex index in fillCells) worksheet.getCell(index),
    ];

    AutoFillEngine(fillSelection.fillDirection, baseProperties, fillProperties).resolve(worksheet);

    SheetSelection newSelection = controller.selection.value.complete();
    SelectionCellCorners? corners = newSelection.cellCorners?.includeMergedCells(controller.worksheet);
    if (corners != null) {
      controller.selection.update(SheetRangeSelection<CellIndex>(corners.topLeft, corners.bottomRight));
    } else {
      controller.selection.update(newSelection);
    }
  }

  int missingToBeDivisible(int b, int a) {
    int remainder = a % b;
    return remainder == 0 ? 0 : b - remainder;
  }
}

import 'package:sheets/core/auto_fill_engine.dart';
import 'package:sheets/core/cell_properties.dart';
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
import 'package:sheets/core/sheet_data.dart';
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
    selectedIndex = controller.data.fillCellIndex(selectedIndex);

    SheetSelection previousSelection = controller.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);
    selectionBuilder.setStrategy(GestureSelectionStrategyFill(controller.data));

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
    SheetData data = controller.data;
    SheetFillSelection fillSelection = controller.selection.value as SheetFillSelection;


    List<CellIndex> fillCells = fillSelection.getSelectedCells(data.columnCount, data.rowCount);
    List<CellIndex> templateCells = fillSelection.baseSelection.getSelectedCells(data.columnCount, data.rowCount);

    List<IndexedCellProperties> baseProperties = <IndexedCellProperties>[
      for (CellIndex index in templateCells) IndexedCellProperties(index: index, properties: data.getCellProperties(index)),
    ];
    List<IndexedCellProperties> fillProperties = <IndexedCellProperties>[
      for (CellIndex index in fillCells) IndexedCellProperties(index: index, properties: data.getCellProperties(index)),
    ];

    AutoFillEngine(data, fillSelection.fillDirection, baseProperties, fillProperties).resolve();

    SheetSelection newSelection = controller.selection.value.complete();
    SelectionCellCorners? corners = newSelection.cellCorners?.includeMergedCells(controller.data);
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

import 'package:sheets/core/auto_fill_engine.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_scroll_events.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class FillSelectionEvent extends SheetEvent {
  @override
  FillSelectionAction<FillSelectionEvent> createAction(SheetController controller);
}

abstract class FillSelectionAction<T extends FillSelectionEvent> extends SheetAction<T> {
  FillSelectionAction(super.event, super.controller);
}

// Start Fill
class StartFillSelectionEvent extends FillSelectionEvent {
  @override
  StartFillSelectionAction createAction(SheetController controller) => StartFillSelectionAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class StartFillSelectionAction extends FillSelectionAction<StartFillSelectionEvent> {
  StartFillSelectionAction(super.event, super.controller);

  @override
  void execute() {}
}

// Update fill
class UpdateFillSelectionEvent extends FillSelectionEvent {
  UpdateFillSelectionEvent(this.selectionStart, this.selectionEnd);

  final ViewportItem selectionStart;
  final ViewportItem selectionEnd;

  @override
  UpdateFillSelectionAction createAction(SheetController controller) => UpdateFillSelectionAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[selectionStart, selectionEnd];
}

class UpdateFillSelectionAction extends FillSelectionAction<UpdateFillSelectionEvent> {
  UpdateFillSelectionAction(super.event, super.controller);

  @override
  void execute() {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      event.selectionEnd.index,
      controller.viewport.firstVisibleRow,
      controller.viewport.firstVisibleColumn,
    );

    SheetSelection previousSelection = controller.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);
    selectionBuilder.setStrategy(GestureSelectionStrategyFill());

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);
    controller.selection.update(updatedSelection);
    ensureFullyVisible(selectedIndex);
  }
}

// Complete fill
class CompleteFillSelectionEvent extends FillSelectionEvent {
  @override
  CompleteFillSelectionAction createAction(SheetController controller) => CompleteFillSelectionAction(this, controller);

  @override
  SheetRebuildProperties get rebuildProperties {
    return SheetRebuildProperties(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class CompleteFillSelectionAction extends FillSelectionAction<CompleteFillSelectionEvent> {
  CompleteFillSelectionAction(super.event, super.controller);

  @override
  void execute() {
    SheetData data = controller.data;
    SheetFillSelection selection = controller.selection.value as SheetFillSelection;

    List<CellIndex> selectedCells = selection.baseSelection.getSelectedCells(data.columnCount, data.rowCount);
    List<CellIndex> fillCells = selection.getSelectedCells(data.columnCount, data.rowCount);

    List<IndexedCellProperties> baseProperties = <IndexedCellProperties>[
      for (CellIndex index in selectedCells) IndexedCellProperties(index: index, properties: data.getCellProperties(index)),
    ];
    List<IndexedCellProperties> fillProperties = <IndexedCellProperties>[
      for (CellIndex index in fillCells) IndexedCellProperties(index: index, properties: data.getCellProperties(index)),
    ];

    List<IndexedCellProperties> filledCells = AutoFillEngine(selection.fillDirection, baseProperties, fillProperties).resolve();
    data.setCellsProperties(filledCells);

    controller.selection.complete();
  }
}

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
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/worksheet.dart';

// Start Fill
class StartFillSelectionEvent extends StartSelectionEvent {
  StartFillSelectionEvent(super.selectionStart);

  @override
  StartFillSelectionAction createAction(Worksheet worksheet) => StartFillSelectionAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[];
}

class StartFillSelectionAction extends StartSelectionAction {
  StartFillSelectionAction(super.event, super.worksheet);

  @override
  void execute() {}
}

// Update fill
class UpdateFillSelectionEvent extends UpdateSelectionEvent {
  UpdateFillSelectionEvent(super.selectionEnd);

  @override
  UpdateFillSelectionAction createAction(Worksheet worksheet) => UpdateFillSelectionAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig {
    return SheetRebuildConfig(rebuildSelection: true);
  }

  @override
  List<Object?> get props => <Object?>[selectionEnd];
}

class UpdateFillSelectionAction extends UpdateSelectionAction {
  UpdateFillSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      event.selectionEnd.index,
      worksheet.viewport.firstVisibleRow,
      worksheet.viewport.firstVisibleColumn,
    );
    selectedIndex = worksheet.data.fillCellIndex(selectedIndex);

    SheetSelection previousSelection = worksheet.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);
    selectionBuilder.setStrategy(GestureSelectionStrategyFill(worksheet.data));

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);

    worksheet.selection.update(updatedSelection);
    ensureFullyVisible(selectedIndex);
  }
}

// Complete fill
class CompleteFillSelectionEvent extends CompleteSelectionEvent {
  @override
  CompleteFillSelectionAction createAction(Worksheet worksheet) => CompleteFillSelectionAction(this, worksheet);

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
  CompleteFillSelectionAction(super.event, super.worksheet);

  @override
  void execute() {
    if (worksheet.selection.value is! SheetFillSelection) {
      return;
    }
    WorksheetData data = worksheet.data;
    SheetFillSelection fillSelection = worksheet.selection.value as SheetFillSelection;

    List<CellIndex> fillCells = fillSelection.getSelectedCells(data.columnCount, data.rowCount);
    List<CellIndex> templateCells = fillSelection.baseSelection.getSelectedCells(data.columnCount, data.rowCount);

    List<IndexedCellProperties> baseProperties = <IndexedCellProperties>[
      for (CellIndex index in templateCells) IndexedCellProperties(index: index, properties: data.cells.get(index)),
    ];
    List<IndexedCellProperties> fillProperties = <IndexedCellProperties>[
      for (CellIndex index in fillCells) IndexedCellProperties(index: index, properties: data.cells.get(index)),
    ];

    AutoFillEngine(data, fillSelection.fillDirection, baseProperties, fillProperties).resolve();

    SheetSelection newSelection = worksheet.selection.value.complete();
    SelectionCellCorners? corners = newSelection.cellCorners?.includeMergedCells(worksheet.data);
    if (corners != null) {
      worksheet.selection.update(SheetRangeSelection<CellIndex>(corners.topLeft, corners.bottomRight));
    } else {
      worksheet.selection.update(newSelection);
    }
  }

  int missingToBeDivisible(int b, int a) {
    int remainder = a % b;
    return remainder == 0 ? 0 : b - remainder;
  }
}

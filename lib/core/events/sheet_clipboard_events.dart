import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/worksheet.dart';

abstract class SheetClipboardEvent extends SheetEvent {
  @override
  SheetClipboardAction<SheetClipboardEvent> createAction(Worksheet worksheet);
}

abstract class SheetClipboardAction<T extends SheetClipboardEvent> extends SheetAction<T> {
  SheetClipboardAction(super.event, super.worksheet);
}

class CopySelectionEvent extends SheetClipboardEvent {
  CopySelectionEvent();

  @override
  CopySelectionAction createAction(Worksheet worksheet) => CopySelectionAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig();

  @override
  List<Object?> get props => <Object?>[];
}

class CopySelectionAction extends SheetClipboardAction<CopySelectionEvent> {
  CopySelectionAction(super.event, super.worksheet);

  @override
  Future<void> execute() async {
    List<CellIndex> selectedCells =
        worksheet.selection.value.getSelectedCells(worksheet.data.columnCount, worksheet.data.rowCount);

    List<IndexedCellProperties> cellsProperties = selectedCells.map((CellIndex index) {
      return IndexedCellProperties(
        index: index,
        properties: worksheet.data.cells.get(index),
      );
    }).toList();

    await SheetClipboard.write(cellsProperties);
  }
}

class PasteSelectionEvent extends SheetClipboardEvent {
  PasteSelectionEvent({
    this.valuesOnly = false,
  });

  final bool valuesOnly;

  @override
  PasteSelectionAction createAction(Worksheet worksheet) => PasteSelectionAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig(
        rebuildData: true,
        rebuildSelection: true,
      );

  @override
  List<Object?> get props => <Object?>[];
}

class PasteSelectionAction extends SheetClipboardAction<PasteSelectionEvent> {
  PasteSelectionAction(super.event, super.worksheet);

  @override
  Future<void> execute() async {
    CellIndex selectionAnchor = worksheet.selection.value.mainCell;

    List<PastedCellProperties> pastedCells = await SheetClipboard.read(html: !event.valuesOnly);
    List<IndexedCellProperties> cellsProperties = pastedCells.map((PastedCellProperties cell) {
      return cell.position(selectionAnchor);
    }).toList();

    List<MergedCell> mergedCells = cellsProperties
        .map((IndexedCellProperties cell) {
          return cell.properties.mergeStatus;
        })
        .whereType<MergedCell>()
        .toList();

    for (MergedCell mergedCell in mergedCells) {
      worksheet.data.cells.merge(mergedCell.mergedCells);
    }

    worksheet.data.cells.setAll(cellsProperties);

    List<RowIndex> rows = cellsProperties.map((IndexedCellProperties cell) => cell.index.row).toSet().toList();
    for (RowIndex row in rows) {
      double minRowHeight = worksheet.data.getMinRowHeight(row);
      worksheet.data.rows.setHeight(row, minRowHeight);
    }

    worksheet.selection.update(SheetSelectionFactory.range(
      start: cellsProperties.first.index,
      end: cellsProperties.last.index,
      completed: true,
    ));
  }
}

class CutSelectionEvent extends SheetClipboardEvent {
  CutSelectionEvent();

  @override
  CutSelectionAction createAction(Worksheet worksheet) => CutSelectionAction(this, worksheet);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig(
        rebuildData: true,
      );

  @override
  List<Object?> get props => <Object?>[];
}

class CutSelectionAction extends SheetClipboardAction<CutSelectionEvent> {
  CutSelectionAction(super.event, super.worksheet);

  @override
  Future<void> execute() async {
    worksheet.resolve(CopySelectionEvent());
    worksheet.resolve(ClearSelectionEvent());
  }
}

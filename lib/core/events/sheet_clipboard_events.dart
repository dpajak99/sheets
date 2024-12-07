import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_encoder.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_encoder.dart';
import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';
import 'package:super_clipboard/super_clipboard.dart';

abstract class SheetClipboardEvent extends SheetEvent {
  @override
  SheetClipboardAction<SheetClipboardEvent> createAction(SheetController controller);
}

abstract class SheetClipboardAction<T extends SheetClipboardEvent> extends SheetAction<T> {
  SheetClipboardAction(super.event, super.controller);
}

class CopySelectionEvent extends SheetClipboardEvent {
  CopySelectionEvent();

  @override
  CopySelectionAction createAction(SheetController controller) => CopySelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig();

  @override
  List<Object?> get props => <Object?>[];
}

class CopySelectionAction extends SheetClipboardAction<CopySelectionEvent> {
  CopySelectionAction(super.event, super.controller);

  @override
  Future<void> execute() async {
    List<CellIndex> selectedCells =
        controller.selection.value.getSelectedCells(controller.data.columnCount, controller.data.rowCount);

    List<IndexedCellProperties> cellsProperties = selectedCells.map((CellIndex index) {
      return IndexedCellProperties(
        index: index,
        properties: controller.data.getCellProperties(index),
      );
    }).toList();

    await SheetClipboard.write(cellsProperties);
  }
}

class PasteSelectionEvent extends SheetClipboardEvent {
  PasteSelectionEvent();

  @override
  PasteSelectionAction createAction(SheetController controller) => PasteSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig(
        rebuildData: true,
        rebuildViewport: true,
      );

  @override
  List<Object?> get props => <Object?>[];
}

class PasteSelectionAction extends SheetClipboardAction<PasteSelectionEvent> {
  PasteSelectionAction(super.event, super.controller);

  @override
  Future<void> execute() async {
    CellIndex selectionAnchor = controller.selection.value.mainCell;

    List<PastedCellProperties> pastedCells = await SheetClipboard.read();
    List<IndexedCellProperties> cellsProperties = pastedCells.map((PastedCellProperties cell) {
      return cell.position(selectionAnchor);
    }).toList();

    List<MergedCell> mergedCells = cellsProperties.map((IndexedCellProperties cell) {
      return cell.properties.mergeStatus;
    }).whereType<MergedCell>().toList();

    for(MergedCell mergedCell in mergedCells) {
      controller.data.mergeCells(mergedCell.mergedCells);
    }

    controller.data.setCellsProperties(cellsProperties);

    List<RowIndex> rows = cellsProperties.map((IndexedCellProperties cell) => cell.index.row).toSet().toList();
    for(RowIndex row in rows) {
      double minRowHeight = controller.data.getMinRowHeight(row);
      controller.data.setRowHeight(row, minRowHeight);
    }

    controller.selection.update(SheetSelectionFactory.range(
      start: cellsProperties.first.index,
      end: cellsProperties.last.index,
      completed: true,
    ));
  }
}

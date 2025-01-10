import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/data/worksheet_event.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';

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
    List<CellIndex> selectedCells = controller.selection.value.getSelectedCells(
      controller.worksheet.cols,
      controller.worksheet.rows,
    );

    List<CellProperties> cellsProperties = controller.worksheet.getCells(selectedCells);
    await SheetClipboard.write(cellsProperties);
  }
}

class PasteSelectionEvent extends SheetClipboardEvent {
  PasteSelectionEvent({
    this.valuesOnly = false,
  });

  final bool valuesOnly;

  @override
  PasteSelectionAction createAction(SheetController controller) => PasteSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig(
        rebuildData: true,
        rebuildSelection: true,
      );

  @override
  List<Object?> get props => <Object?>[];
}

class PasteSelectionAction extends SheetClipboardAction<PasteSelectionEvent> {
  PasteSelectionAction(super.event, super.controller);

  @override
  Future<void> execute() async {
    CellIndex selectionAnchor = controller.selection.value.mainCell;

    List<PastedCellProperties> pastedCells = await SheetClipboard.read(html: !event.valuesOnly);
    List<CellProperties> cellsProperties = pastedCells.map((PastedCellProperties cell) {
      return cell.position(selectionAnchor);
    }).toList();

    controller.worksheet.dispatchEvent(InsertCellsWorksheetEvent(cellsProperties));
    controller.selection.update(SheetSelectionFactory.range(
      start: cellsProperties.first.index,
      end: cellsProperties.last.index,
      completed: true,
    ));
  }
}

class CutSelectionEvent extends SheetClipboardEvent {
  CutSelectionEvent();

  @override
  CutSelectionAction createAction(SheetController controller) => CutSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig => SheetRebuildConfig(
        rebuildData: true,
      );

  @override
  List<Object?> get props => <Object?>[];
}

class CutSelectionAction extends SheetClipboardAction<CutSelectionEvent> {
  CutSelectionAction(super.event, super.controller);

  @override
  Future<void> execute() async {
    controller.resolve(CopySelectionEvent());
    controller.resolve(ClearSelectionEvent());
  }
}

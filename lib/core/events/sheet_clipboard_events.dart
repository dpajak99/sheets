import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/html/clipboard_data/html_encoder/html_clipboard_data_decoder.dart';
import 'package:sheets/core/html/clipboard_data/html_encoder/html_clipboard_data_encoder.dart';
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

    HtmlClipboardDataEncoder encoder = HtmlClipboardDataEncoder(controller.data);
    String htmlString = encoder.encode(cellsProperties);

    StringBuffer plainTextBuffer = StringBuffer();
    Map<RowIndex, List<IndexedCellProperties>> rowsMap = cellsProperties.groupByRows();
    for (MapEntry<RowIndex, List<IndexedCellProperties>> entry in rowsMap.entries) {
      List<IndexedCellProperties> rowCellsProperties = entry.value;
      for (IndexedCellProperties cellProperties in rowCellsProperties) {
        plainTextBuffer.write(cellProperties.properties.value.toPlainText());
        plainTextBuffer.write('\t');
      }
      plainTextBuffer.write('\n');
    }

    SystemClipboard? clipboard = SystemClipboard.instance;
    DataWriterItem item = DataWriterItem();
    item.add(Formats.htmlText.lazy(() => htmlString));
    item.add(Formats.plainText.lazy(() => plainTextBuffer.toString()));

    await clipboard?.write(<DataWriterItem>[item]);
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
    String? htmlData = await SystemClipboard.instance?.read().then((ClipboardReader reader) async {
      return reader.readValue(Formats.htmlText);
    });

    if (htmlData == null) {
      return;
    }

    // Decode HTML into a structured document.
    CellIndex selectionAnchor = controller.selection.value.mainCell;
    HtmlClipboardDataDecoder decoder = HtmlClipboardDataDecoder(controller.data, selectionAnchor);
    List<IndexedCellProperties> pastedCells = decoder.decode(htmlData);

    controller.data.setCellsProperties(pastedCells);
    Set<RowIndex> rows = pastedCells.map((IndexedCellProperties cell) => cell.index.row).toSet();
    for(RowIndex row in rows) {
      double minRowHeight = controller.data.getMinRowHeight(row);
      controller.data.setRowHeight(row, minRowHeight);
    }

    controller.selection.update(SheetSelectionFactory.range(
      start: pastedCells.first.index,
      end: pastedCells.last.index,
      completed: true,
    ));
  }
}

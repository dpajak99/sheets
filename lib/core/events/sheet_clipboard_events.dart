import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_rebuild_config.dart';
import 'package:sheets/core/html/elements/html_google_sheets_html_origin.dart';
import 'package:sheets/core/html/html_encoder.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
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

    HtmlGoogleSheetsHtmlOrigin htmlDocument = HtmlGoogleSheetsHtmlOrigin(
      table: IndexedCellPropertiesParser(controller.data, controller.selection.value.mainCell).buildHtmlTable(cellsProperties),
    );

    String htmlString = htmlDocument.toHtml();
    SystemClipboard? clipboard = SystemClipboard.instance;
    DataWriterItem item = DataWriterItem();
    item.add(Formats.htmlText.lazy(() => htmlString));
    await clipboard?.write(<DataWriterItem>[item]);
  }
}

class PasteSelectionEvent extends SheetClipboardEvent {
  PasteSelectionEvent();

  @override
  PasteSelectionAction createAction(SheetController controller) => PasteSelectionAction(this, controller);

  @override
  SheetRebuildConfig get rebuildConfig =>
      SheetRebuildConfig(
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
    HtmlGoogleSheetsHtmlOrigin parsedDocument = HtmlParser.parseDocument(htmlData);

    // Convert parsed HTML back into cell properties and apply to the sheet.
    List<CellIndex> pastedCells = IndexedCellPropertiesParser(controller.data, controller.selection.value.mainCell).applyHtmlDocumentToSheet(parsedDocument);

    controller.selection.update(SheetSelectionFactory.range(start: pastedCells.first, end: pastedCells.last, completed: true));
  }
}

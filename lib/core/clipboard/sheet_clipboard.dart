import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_encoder.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_encoder.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:super_clipboard/super_clipboard.dart';

class SheetClipboard {
  static Future<List<PastedCellProperties>> read() async {
    ClipboardReader? reader = await SystemClipboard.instance?.read();
    if (reader == null) {
      return <PastedCellProperties>[];
    }

    String? htmlData = await reader.readValue(Formats.htmlText);
    if( htmlData != null ) {
      return HtmlClipboardDecoder.decode(htmlData);
    }

    String? plainText = await reader.readValue(Formats.plainText);
    if( plainText != null ) {
      return PlaintextClipboardDecoder.decode(plainText);
    }

    return <PastedCellProperties>[];
  }

  static Future<void> write(List<IndexedCellProperties> cells) async {
    String htmlString = HtmlClipboardEncoder.encode(cells);
    String plainText = PlaintextClipboardEncoder.encode(cells);

    SystemClipboard? clipboard = SystemClipboard.instance;
    DataWriterItem item = DataWriterItem();
    item.add(Formats.htmlText.lazy(() => htmlString));
    item.add(Formats.plainText.lazy(() => plainText));

    await clipboard?.write(<DataWriterItem>[item]);
  }
}

class PastedCellProperties {
  PastedCellProperties({
    required this.text,
    required this.style,
    required this.colOffset,
    required this.rowOffset,
    int? rowSpan,
    int? colSpan,
  })  : rowSpan = rowSpan ?? 1,
        colSpan = colSpan ?? 1;

  final SheetRichText text;
  final CellStyle style;
  final int colOffset;
  final int rowOffset;
  final int rowSpan;
  final int colSpan;

  IndexedCellProperties position(CellIndex anchor) {
    CellIndex index = CellIndex(
      row: anchor.row + rowOffset,
      column: anchor.column + colOffset,
    );

    CellMergeStatus mergeStatus = NoCellMerge();
    if( rowSpan > 1 || colSpan > 1 ) {
      mergeStatus = MergedCell(
        start: index,
        end: CellIndex(row: index.row + rowSpan - 1, column: index.column + colSpan - 1),
      );
    }

    return IndexedCellProperties(
      index: CellIndex(
        row: anchor.row + rowOffset,
        column: anchor.column + colOffset,
      ),
      properties: CellProperties(
        value: text,
        style: style,
        mergeStatus: mergeStatus,
      ),
    );
  }
}

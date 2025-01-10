import 'package:equatable/equatable.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/encoders/html/html_clipboard_encoder.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_decoder.dart';
import 'package:sheets/core/clipboard/encoders/plaintext/plaintext_clipboard_encoder.dart';
import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:super_clipboard/super_clipboard.dart';

class SheetClipboard {
  static Future<List<PastedCellProperties>> read({
    bool html = true,
    bool plaintext = true,
  }) async {
    ClipboardReader? reader = await SystemClipboard.instance?.read();
    if (reader == null) {
      return <PastedCellProperties>[];
    }

    String? htmlData = await reader.readValue(Formats.htmlText);
    if (htmlData != null && html) {
      return HtmlClipboardDecoder.decode(htmlData);
    }

    String? plainText = await reader.readValue(Formats.plainText);
    if (plainText != null && plaintext) {
      return PlaintextClipboardDecoder.decode(plainText);
    }

    return <PastedCellProperties>[];
  }

  static Future<void> write(List<CellProperties> cells) async {
    String htmlString = HtmlClipboardEncoder.encode(cells);
    String plainText = PlaintextClipboardEncoder.encode(cells);

    SystemClipboard? clipboard = SystemClipboard.instance;
    DataWriterItem item = DataWriterItem();
    item.add(Formats.htmlText.lazy(() => htmlString));
    item.add(Formats.plainText.lazy(() => plainText));

    await clipboard?.write(<DataWriterItem>[item]);
  }
}

class PastedCellProperties with EquatableMixin {
  PastedCellProperties({
    required this.text,
    required this.colOffset,
    required this.rowOffset,
    CellStyle? style,
    int? rowSpan,
    int? colSpan,
  })  : style = style ?? CellStyle(),
        rowSpan = rowSpan ?? 1,
        colSpan = colSpan ?? 1;

  final SheetRichText text;
  final CellStyle style;
  final int colOffset;
  final int rowOffset;
  final int rowSpan;
  final int colSpan;

  CellProperties position(CellIndex anchor) {
    CellIndex index = CellIndex(
      row: anchor.row + rowOffset,
      column: anchor.column + colOffset,
    );

    CellMergeStatus mergeStatus = const CellMergeStatus.noMerge();
    if (rowSpan > 1 || colSpan > 1) {
      mergeStatus = CellMergeStatus.merged(
        start: index,
        end: CellIndex(row: index.row + rowSpan - 1, column: index.column + colSpan - 1),
      );
    }

    return CellProperties(
      index: CellIndex(
        row: anchor.row + rowOffset,
        column: anchor.column + colOffset,
      ),
      value: text,
      style: style,
      mergeStatus: mergeStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[text, colOffset, rowOffset, style, rowSpan, colSpan];
}

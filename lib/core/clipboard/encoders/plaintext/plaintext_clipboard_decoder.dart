import 'package:sheets/core/clipboard/sheet_clipboard.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';

class PlaintextClipboardDecoder {
  static List<PastedCellProperties> decode(String rawData) {
    List<PastedCellProperties> pastedCells = <PastedCellProperties>[];
    List<String> rows = rawData.split('\n');
    for (int i = 0; i < rows.length; i++) {
      String row = rows[i];
      List<String> cells = row.split('\t');
      for (int j = 0; j < cells.length; j++) {
        pastedCells.add(
          PastedCellProperties(
            text: SheetRichText.single(text: cells[j]),
            style: CellStyle(),
            colOffset: j,
            rowOffset: i,
          ),
        );
      }
    }
    return pastedCells;
  }
}
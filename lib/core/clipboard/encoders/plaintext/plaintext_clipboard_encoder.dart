import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

class PlaintextClipboardEncoder {
  static String encode(List<IndexedCellProperties> cellsProperties) {
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

    return plainTextBuffer.toString().trimRight();
  }
}

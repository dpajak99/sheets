import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

class PlaintextClipboardEncoder {
  static String encode(List<IndexedCellProperties> cellsProperties) {
    StringBuffer plainTextBuffer = StringBuffer();
    Map<RowIndex, List<IndexedCellProperties>> rowsMap = cellsProperties.groupByRows();

    for (int rowIndex = 0; rowIndex < rowsMap.length; rowIndex++) {
      MapEntry<RowIndex, List<IndexedCellProperties>> entry = rowsMap.entries.elementAt(rowIndex);
      List<IndexedCellProperties> rowCellsProperties = entry.value;
      for (int colIndex = 0; colIndex < rowCellsProperties.length; colIndex++) {
        IndexedCellProperties cellProperties = rowCellsProperties[colIndex];

        plainTextBuffer.write(cellProperties.properties.value.toPlainText());
        if(colIndex < rowCellsProperties.length - 1) {
          plainTextBuffer.write('\t');
        }
      }
      if(rowIndex < rowsMap.length - 1) {
        plainTextBuffer.write('\n');
      }
    }

    return plainTextBuffer.toString().trimRight();
  }
}

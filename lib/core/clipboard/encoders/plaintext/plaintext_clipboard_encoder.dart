import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/extensions/cell_properties_extensions.dart';

class PlaintextClipboardEncoder {
  static String encode(List<CellProperties> cellsProperties) {
    StringBuffer plainTextBuffer = StringBuffer();
    Map<RowIndex, List<CellProperties>> rowsMap = cellsProperties.groupByRows();

    for (int rowIndex = 0; rowIndex < rowsMap.length; rowIndex++) {
      MapEntry<RowIndex, List<CellProperties>> entry = rowsMap.entries.elementAt(rowIndex);
      List<CellProperties> rowCellsProperties = entry.value;
      for (int colIndex = 0; colIndex < rowCellsProperties.length; colIndex++) {
        CellProperties cellProperties = rowCellsProperties[colIndex];

        plainTextBuffer.write(cellProperties.value.toPlainText());
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

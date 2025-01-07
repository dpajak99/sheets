import 'package:sheets/core/data/worksheet.dart';
import 'package:sheets/core/sheet_index.dart';

abstract class SheetDataEvent {
  void setCellStyle(Worksheet worksheet, CellIndex cellIndex, CellStyle Function(CellStyle) modifier) {
    CellProperties properties = worksheet.getCell(cellIndex);
    CellConfig cellConfig = CellConfig.fromProperties(properties);

    worksheet.cellConfigs[cellIndex] = cellConfig.copyWith(style: modifier(properties.style));
  }
}

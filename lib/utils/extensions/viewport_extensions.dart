import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

extension ViewportRowsExtensions on List<ViewportRow> {
  ViewportRow findByIndex(RowIndex index) {
    return firstWhere((ViewportRow row) => row.index == index, orElse: () => last);
  }
}

extension ViewportColumnsExtensions on List<ViewportColumn> {
  ViewportColumn findByIndex(ColumnIndex index) {
    return firstWhere((ViewportColumn column) => column.index == index, orElse: () => last);
  }
}

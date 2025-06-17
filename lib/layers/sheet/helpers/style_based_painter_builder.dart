import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

class StyleBasedPainterBuilder {
  StyleBasedPainterBuilder({required this.cells, required this.builder});

  final List<ViewportCell> cells;
  final void Function(CellStyle style, List<ViewportCell> cells) builder;

  void build() {
    final Map<CellStyle, List<ViewportCell>> cellsByStyle =
        <CellStyle, List<ViewportCell>>{};

    for (final ViewportCell cell in cells) {
      final CellStyle style = cell.properties.style;
      cellsByStyle.putIfAbsent(style, () => <ViewportCell>[]).add(cell);
    }

    for (final MapEntry<CellStyle, List<ViewportCell>> entry
        in cellsByStyle.entries) {
      builder(entry.key, entry.value);
    }
  }
}

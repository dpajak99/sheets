import 'package:sheets/viewport/viewport_item.dart';

/// [VisibleCellsRenderer] is responsible for generating a list of visible
/// cells based on the provided visible rows and columns within the viewport.
///
/// It constructs each visible cell by combining the corresponding row and
/// column and applying any additional configuration.
class VisibleCellsRenderer {
  /// The list of rows currently visible in the viewport.
  final List<ViewportRow> visibleRows;

  /// The list of columns currently visible in the viewport.
  final List<ViewportColumn> visibleColumns;

  /// Creates a [VisibleCellsRenderer] with the given [visibleRows] and
  /// [visibleColumns].
  VisibleCellsRenderer({
    required this.visibleRows,
    required this.visibleColumns,
  });

  /// Builds and returns a list of [ViewportCell] objects representing
  /// the cells visible in the current viewport.
  ///
  /// For each combination of a visible row and column, a [ViewportCell] is
  /// created using [ViewportCell.fromColumnRow] and added to the list of
  /// visible cells.
  List<ViewportCell> build() {
    List<ViewportCell> visibleCells = [];

    for (ViewportRow row in visibleRows) {
      for (ViewportColumn column in visibleColumns) {
        ViewportCell viewportCell = ViewportCell.fromColumnRow(column, row, value: '');
        visibleCells.add(viewportCell);
      }
    }

    return visibleCells;
  }
}

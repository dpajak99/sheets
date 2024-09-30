import 'package:equatable/equatable.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/utils/direction.dart';

class ClosestVisible<T extends SheetItemIndex> with EquatableMixin {
  final List<Direction> hiddenBorders;
  final T item;

  ClosestVisible._({required this.hiddenBorders, required this.item});

  ClosestVisible.fullyVisible(this.item) : hiddenBorders = [];

  ClosestVisible.partiallyVisible({required this.hiddenBorders, required this.item});

  static ClosestVisible<CellIndex> combineCellIndex(ClosestVisible<RowIndex> rowIndex, ClosestVisible<ColumnIndex> columnIndex) {
    return ClosestVisible<CellIndex>._(
      hiddenBorders: [...rowIndex.hiddenBorders, ...columnIndex.hiddenBorders],
      item: CellIndex(rowIndex: rowIndex.item, columnIndex: columnIndex.item),
    );
  }

  @override
  List<Object?> get props => [hiddenBorders, item];
}

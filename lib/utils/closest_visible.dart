import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

class ClosestVisible<T> with EquatableMixin {
  final List<Direction> hiddenBorders;
  final T value;

  ClosestVisible._({required this.hiddenBorders, required this.value});

  ClosestVisible.fullyVisible(this.value) : hiddenBorders = <Direction>[];

  ClosestVisible.partiallyVisible({required this.hiddenBorders, required this.value});

  static ClosestVisible<CellIndex> combineCellIndex(ClosestVisible<RowIndex> rowIndex, ClosestVisible<ColumnIndex> columnIndex) {
    return ClosestVisible<CellIndex>._(
      hiddenBorders: <Direction>[...rowIndex.hiddenBorders, ...columnIndex.hiddenBorders],
      value: CellIndex(row: rowIndex.value, column: columnIndex.value),
    );
  }

  @override
  List<Object?> get props => <Object?>[hiddenBorders, value];
}

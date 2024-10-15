import 'package:equatable/equatable.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_direction.dart';
import 'package:sheets/utils/direction.dart';

class SelectionCorners<T> with EquatableMixin {
  final T topLeft;
  final T topRight;
  final T bottomLeft;
  final T bottomRight;

  SelectionCorners(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  factory SelectionCorners.fromDirection({
    required T topLeft,
    required T topRight,
    required T bottomLeft,
    required T bottomRight,
    required SelectionDirection direction,
  }) {
    switch (direction) {
      case SelectionDirection.bottomRight:
        return SelectionCorners<T>(topLeft, topRight, bottomLeft, bottomRight);
      case SelectionDirection.bottomLeft:
        return SelectionCorners<T>(topRight, topLeft, bottomRight, bottomLeft);
      case SelectionDirection.topRight:
        return SelectionCorners<T>(bottomLeft, bottomRight, topLeft, topRight);
      case SelectionDirection.topLeft:
        return SelectionCorners<T>(bottomRight, bottomLeft, topRight, topLeft);
    }
  }

  @override
  List<Object?> get props => <Object?>[topLeft, topRight, bottomLeft, bottomRight];
}

class SelectionCellCorners extends SelectionCorners<CellIndex> {
  SelectionCellCorners(super.topLeft, super.topRight, super.bottomLeft, super.bottomRight);

  SelectionCellCorners.single(CellIndex cellIndex) : super(cellIndex, cellIndex, cellIndex, cellIndex);

  factory SelectionCellCorners.fromDirection({
    required CellIndex topLeft,
    required CellIndex topRight,
    required CellIndex bottomLeft,
    required CellIndex bottomRight,
    required SelectionDirection direction,
  }) {
    switch (direction) {
      case SelectionDirection.bottomRight:
        return SelectionCellCorners(topLeft, topRight, bottomLeft, bottomRight);
      case SelectionDirection.bottomLeft:
        return SelectionCellCorners(topRight, topLeft, bottomRight, bottomLeft);
      case SelectionDirection.topRight:
        return SelectionCellCorners(bottomLeft, bottomRight, topLeft, topRight);
      case SelectionDirection.topLeft:
        return SelectionCellCorners(bottomRight, bottomLeft, topRight, topLeft);
    }
  }

  Direction getRelativePosition(CellIndex cellIndex) {
    Map<Direction, int> directionSpaces = <Direction, int>{
      Direction.top: cellIndex.rowIndex.value - topLeft.rowIndex.value,
      Direction.left: cellIndex.columnIndex.value - topLeft.columnIndex.value,
      Direction.bottom: bottomRight.rowIndex.value - cellIndex.rowIndex.value,
      Direction.right: bottomRight.columnIndex.value - cellIndex.columnIndex.value,
    };

    return directionSpaces.entries.reduce((MapEntry<Direction, int> a, MapEntry<Direction, int> b) => a.value < b.value ? a : b).key;
  }

  bool isNestedIn(SelectionCellCorners corners) {
    return topLeft.rowIndex.value >= corners.topLeft.rowIndex.value &&
        topLeft.columnIndex.value >= corners.topLeft.columnIndex.value &&
        bottomRight.rowIndex.value <= corners.bottomRight.rowIndex.value &&
        bottomRight.columnIndex.value <= corners.bottomRight.columnIndex.value;
  }

  @override
  List<Object?> get props => <Object?>[topLeft, topRight, bottomLeft, bottomRight];
}

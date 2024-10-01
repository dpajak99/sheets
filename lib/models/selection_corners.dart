import 'package:equatable/equatable.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/models/selection_direction.dart';
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
        return SelectionCorners(topLeft, topRight, bottomLeft, bottomRight);
      case SelectionDirection.bottomLeft:
        return SelectionCorners(topRight, topLeft, bottomRight, bottomLeft);
      case SelectionDirection.topRight:
        return SelectionCorners(bottomLeft, bottomRight, topLeft, topRight);
      case SelectionDirection.topLeft:
        return SelectionCorners(bottomRight, bottomLeft, topRight, topLeft);
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
    Map<Direction, int> directionSpaces = {
      Direction.top: cellIndex.rowIndex.value - topLeft.rowIndex.value,
      Direction.left: cellIndex.columnIndex.value - topLeft.columnIndex.value,
      Direction.bottom: bottomRight.rowIndex.value - cellIndex.rowIndex.value,
      Direction.right: bottomRight.columnIndex.value - cellIndex.columnIndex.value,
    };

    return directionSpaces.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  int get topIndex => topLeft.rowIndex.value;

  int get bottomIndex => bottomLeft.rowIndex.value;

  int get leftIndex => topLeft.columnIndex.value;

  int get rightIndex => topRight.columnIndex.value;

  @override
  List<Object?> get props => <Object?>[topLeft, topRight, bottomLeft, bottomRight];
}

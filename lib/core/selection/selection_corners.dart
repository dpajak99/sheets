import 'package:equatable/equatable.dart';
import 'package:sheets/core/selection/selection_direction.dart';
import 'package:sheets/core/sheet_data.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

class SelectionCellCorners with EquatableMixin {
  SelectionCellCorners(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  SelectionCellCorners.single(CellIndex cellIndex) : this(cellIndex, cellIndex, cellIndex, cellIndex);

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

  final CellIndex topLeft;
  final CellIndex topRight;
  final CellIndex bottomLeft;
  final CellIndex bottomRight;

  int get width => bottomRight.column.value - topLeft.column.value + 1;
  int get height => bottomRight.row.value - topLeft.row.value + 1;

  SelectionCellCorners includeMergedCells(SheetData data) {
    ColumnIndex left = topLeft.column;
    ColumnIndex right = bottomRight.column;
    RowIndex top = topLeft.row;
    RowIndex bottom = bottomRight.row;

    bool changed;

    do {
      changed = false;
      for (int y = top.value; y <= bottom.value; y++) {
        for (int x = left.value; x <= right.value; x++) {
          CellIndex cellIndex = CellIndex(row: RowIndex(y), column: ColumnIndex(x));
          CellIndex filledCellIndex = data.fillCellIndex(cellIndex);

          if (filledCellIndex is MergedCellIndex) {
            if (filledCellIndex.start.column.value < left.value) {
              left = filledCellIndex.start.column;
              changed = true;
            }
            if (filledCellIndex.end.column.value > right.value) {
              right = filledCellIndex.end.column;
              changed = true;
            }
            if (filledCellIndex.start.row.value < top.value) {
              top = filledCellIndex.start.row;
              changed = true;
            }
            if (filledCellIndex.end.row.value > bottom.value) {
              bottom = filledCellIndex.end.row;
              changed = true;
            }
          }
        }
      }
    } while (changed);

    return SelectionCellCorners(
      CellIndex(row: top, column: left),
      CellIndex(row: top, column: right),
      CellIndex(row: bottom, column: left),
      CellIndex(row: bottom, column: right),
    );
  }


  Direction getRelativePosition(CellIndex cellIndex) {
    Map<Direction, int> directionSpaces = <Direction, int>{
      Direction.top: cellIndex.row.value - topLeft.row.value,
      Direction.left: cellIndex.column.value - topLeft.column.value,
      Direction.bottom: bottomRight.row.value - cellIndex.row.value,
      Direction.right: bottomRight.column.value - cellIndex.column.value,
    };

    return directionSpaces.entries
        .reduce((MapEntry<Direction, int> a, MapEntry<Direction, int> b) => a.value < b.value ? a : b)
        .key;
  }

  bool isAdjacent(SelectionCellCorners corners) {
    return topLeft.row.value == corners.bottomRight.row.value + 1 ||
        bottomRight.row.value == corners.topLeft.row.value - 1 ||
        topLeft.column.value == corners.bottomRight.column.value + 1 ||
        bottomRight.column.value == corners.topLeft.column.value - 1;
  }

  bool isNestedIn(SelectionCellCorners corners) {
    return topLeft.row.value >= corners.topLeft.row.value &&
        topLeft.column.value >= corners.topLeft.column.value &&
        bottomRight.row.value <= corners.bottomRight.row.value &&
        bottomRight.column.value <= corners.bottomRight.column.value;
  }

  @override
  List<Object?> get props => <Object?>[topLeft, topRight, bottomLeft, bottomRight];
}

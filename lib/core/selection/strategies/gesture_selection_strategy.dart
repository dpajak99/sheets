import 'package:sheets/core/selection/selection_corners.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/selection/types/sheet_fill_selection.dart';
import 'package:sheets/core/selection/types/sheet_multi_selection.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/utils/direction.dart';

abstract interface class GestureSelectionStrategy {
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex);
}

class GestureSelectionStrategySingle implements GestureSelectionStrategy {
  @override
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex) {
    return SheetSelectionFactory.single(selectedIndex);
  }
}

class GestureSelectionStrategyAppend implements GestureSelectionStrategy {
  @override
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex) {
    SheetSelection appendedSelection = SheetSelectionFactory.single(selectedIndex);

    if (previousSelection == appendedSelection) {
      return previousSelection;
    } else {
      return previousSelection.append(appendedSelection);
    }
  }
}

class GestureSelectionStrategyRange implements GestureSelectionStrategy {
  @override
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex) {
    SheetSelection baseSelection = previousSelection is SheetMultiSelection
        ? previousSelection.selections.last //
        : previousSelection;

    return baseSelection.modifyEnd(selectedIndex);
  }
}

class GestureSelectionStrategyModify implements GestureSelectionStrategy {
  @override
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex) {
    return previousSelection.modifyEnd(selectedIndex);
  }
}

class GestureSelectionStrategyFill implements GestureSelectionStrategy {
  @override
  SheetSelection execute(SheetSelection previousSelection, SheetIndex selectedIndex) {
    if (selectedIndex is! CellIndex) return previousSelection;

    SheetSelection baseSelection = previousSelection is SheetFillSelection
        ? previousSelection.baseSelection //
        : previousSelection;

    SelectionCellCorners? corners = baseSelection.cellCorners;

    if (corners == null) return previousSelection;
    if (baseSelection.contains(selectedIndex)) return baseSelection;

    Direction direction = corners.getRelativePosition(selectedIndex);

    late CellIndex start;
    late CellIndex end;

    switch (direction) {
      case Direction.top:
        start = corners.topLeft.move(-1, 0);
        end = CellIndex(row: selectedIndex.row, column: corners.topRight.column);
        break;
      case Direction.bottom:
        start = CellIndex(row: selectedIndex.row, column: corners.bottomLeft.column);
        end = corners.bottomRight.move(1, 0);
        break;
      case Direction.left:
        start = corners.topLeft.move(0, -1);
        end = CellIndex(row: corners.bottomLeft.row, column: selectedIndex.column);
        break;
      case Direction.right:
        start = CellIndex(row: corners.topRight.row, column: selectedIndex.column);
        end = corners.bottomRight.move(0, 1);
        break;
    }

    return SheetSelectionFactory.fill(
      start,
      end,
      fillDirection: direction,
      baseSelection: baseSelection,
    );
  }
}

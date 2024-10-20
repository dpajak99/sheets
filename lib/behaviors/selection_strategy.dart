import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/selection/selection_corners.dart';
import 'package:sheets/selection/types/sheet_fill_selection.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/selection/types/sheet_multi_selection.dart';
import 'package:sheets/utils/direction.dart';

abstract class SelectionStrategy {
  SheetSelection execute(SheetSelection previousSelection);
}

class SingleSelectionStrategy extends SelectionStrategy {
  final SheetIndex selectedIndex;

  SingleSelectionStrategy(this.selectedIndex);

  @override
  SheetSelection execute(SheetSelection previousSelection) {
    return SheetSelection.single(selectedIndex);
  }
}

class AppendSelectionStrategy extends SelectionStrategy {
  final SheetIndex selectionIndex;

  AppendSelectionStrategy(this.selectionIndex);

  @override
  SheetSelection execute(SheetSelection previousSelection) {
    SheetSelection appendedSelection = SheetSelection.single(selectionIndex);

    if (previousSelection == appendedSelection) {
      return previousSelection;
    } else {
      return previousSelection.append(appendedSelection);
    }
  }
}

class RangeSelectionStrategy extends SelectionStrategy {
  final SheetIndex selectionEnd;

  RangeSelectionStrategy(this.selectionEnd);

  @override
  SheetSelection execute(SheetSelection previousSelection) {
    SheetSelection baseSelection = previousSelection is SheetMultiSelection
        ? previousSelection.selections.last //
        : previousSelection;

    return baseSelection.modifyEnd(selectionEnd);
  }
}

class ModifySelectionRangeStrategy extends SelectionStrategy {
  final SheetIndex selectionEnd;

  ModifySelectionRangeStrategy(this.selectionEnd);

  @override
  SheetSelection execute(SheetSelection previousSelection) {
    return previousSelection.modifyEnd(selectionEnd);
  }
}

class FillSelectionStrategy extends SelectionStrategy {
  final SheetIndex selectionEnd;

  FillSelectionStrategy(this.selectionEnd);

  @override
  SheetSelection execute(SheetSelection previousSelection) {
    if (this.selectionEnd is! CellIndex) return previousSelection;
    CellIndex selectionEnd = this.selectionEnd as CellIndex;

    SheetSelection baseSelection = previousSelection is SheetFillSelection
        ? previousSelection.baseSelection //
        : previousSelection;

    SelectionCellCorners? corners = baseSelection.cellCorners;

    if (corners == null) return previousSelection;
    if (baseSelection.contains(selectionEnd)) return baseSelection;

    Direction direction = corners.getRelativePosition(selectionEnd);

    late CellIndex start;
    late CellIndex end;

    switch (direction) {
      case Direction.top:
        start = corners.topLeft.move(-1, 0);
        end = CellIndex(row: selectionEnd.row, column: corners.topRight.column);
        break;
      case Direction.bottom:
        start = CellIndex(row: selectionEnd.row, column: corners.bottomLeft.column);
        end = corners.bottomRight.move(1, 0);
        break;
      case Direction.left:
        start = corners.topLeft.move(0, -1);
        end = CellIndex(row: corners.bottomLeft.row, column: selectionEnd.column);
        break;
      case Direction.right:
        start = CellIndex(row: corners.topRight.row, column: selectionEnd.column);
        end = corners.bottomRight.move(0, 1);
        break;
    }

    return SheetSelection.fill(
      start,
      end,
      fillDirection: direction,
      baseSelection: baseSelection,
    );
  }
}

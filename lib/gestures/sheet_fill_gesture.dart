import 'package:sheets/behaviors/selection_strategy.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/gestures/sheet_gesture.dart';
import 'package:sheets/selection/sheet_selection.dart';
import 'package:sheets/viewport/viewport_item.dart';

abstract class SheetFillGesture extends SheetGesture {}

class SheetFillStartGesture extends SheetFillGesture {
  @override
  void resolve(SheetController controller) {}

  @override
  List<Object?> get props => <Object?>[];
}

class SheetFillUpdateGesture extends SheetFillGesture {
  final ViewportItem selectionStart;
  final ViewportItem selectionEnd;

  SheetFillUpdateGesture(this.selectionStart, this.selectionEnd);

  @override
  void resolve(SheetController controller) {
    SheetIndex selectionEndIndex = selectionEnd.index;

    SheetSelection selection = controller.selection.value;
    if (selection.selectionStart is CellIndex) {
      if (selectionEndIndex is ColumnIndex) {
        selectionEndIndex = CellIndex(row: controller.viewport.visibleContent.rows.first.index, column: selectionEndIndex).move(-1, 0);
      } else if (selectionEndIndex is RowIndex) {
        selectionEndIndex = CellIndex(row: selectionEndIndex, column: controller.viewport.visibleContent.columns.first.index).move(0, -1);
      }
    }

    controller.select(FillSelectionStrategy(selectionEndIndex).execute(controller.selection.value));
    controller.viewport.ensureIndexFullyVisible(selectionEndIndex);
  }

  @override
  List<Object?> get props => <Object?>[selectionEnd];
}

class SheetFillEndGesture extends SheetFillGesture {
  @override
  void resolve(SheetController controller) {
    controller.selection.complete();
  }

  @override
  List<Object?> get props => <Object?>[];
}

import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/selection/selection_overflow_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_builder.dart';
import 'package:sheets/core/selection/strategies/gesture_selection_strategy.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/viewport/viewport_item.dart';

abstract class SheetFillGesture extends SheetGesture {}

class SheetFillStartGesture extends SheetFillGesture {
  @override
  void resolve(SheetController controller) {}

  @override
  List<Object?> get props => <Object?>[];
}

class SheetFillUpdateGesture extends SheetFillGesture {
  SheetFillUpdateGesture(this.selectionStart, this.selectionEnd);

  final ViewportItem selectionStart;
  final ViewportItem selectionEnd;

  @override
  void resolve(SheetController controller) {
    SheetIndex selectedIndex = SelectionOverflowIndexAdapter.adaptToCellIndex(
      selectionEnd.index,
      controller.viewport.firstVisibleRow,
      controller.viewport.firstVisibleColumn,
    );

    SheetSelection previousSelection = controller.selection.value;
    GestureSelectionBuilder selectionBuilder = GestureSelectionBuilder(previousSelection);
    selectionBuilder.setStrategy(GestureSelectionStrategyFill());

    SheetSelection updatedSelection = selectionBuilder.build(selectedIndex);
    controller.selection.update(updatedSelection);

    controller.viewport.ensureIndexFullyVisible(selectedIndex);
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

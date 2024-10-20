import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/selection/selection_index_adapter.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/strategies/selection_strategy.dart';
import 'package:sheets/core/selection/strategies/selection_strategy_context.dart';
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
  final ViewportItem selectionStart;
  final ViewportItem selectionEnd;

  SheetFillUpdateGesture(this.selectionStart, this.selectionEnd);

  @override
  void resolve(SheetController controller) {
    SheetIndex selectedIndex = SelectionIndexAdapter.adaptToCellIndex(selectionEnd.index, controller.viewport.visibleContent);
    SheetSelection previousSelection = controller.selection.value;

    SelectionBuilder selectionBuilder = SelectionBuilder(previousSelection);
    selectionBuilder.setStrategy(SelectionStrategyFill());

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

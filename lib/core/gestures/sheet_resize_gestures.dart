import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_data_manager.dart';
import 'package:sheets/core/sheet_index.dart';

class SheetResizeColumnGesture extends SheetGesture {
  SheetResizeColumnGesture(this.columnIndex, this.width);

  final ColumnIndex columnIndex;
  final double width;

  @override
  void resolve(SheetController controller) {
    controller.dataManager.write((SheetData data) => data.setColumnWidth(columnIndex, width));
  }

  @override
  List<Object?> get props => <Object?>[columnIndex, width];
}

class SheetResizeRowGesture extends SheetGesture {
  SheetResizeRowGesture(this.rowIndex, this.height);

  final RowIndex rowIndex;
  final double height;

  @override
  void resolve(SheetController controller) {
    controller.dataManager.write((SheetData data) {
      data.setRowHeight(rowIndex, height, keepValue: true);
    });
  }

  @override
  List<Object?> get props => <Object?>[rowIndex, height];
}

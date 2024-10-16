import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/gestures/sheet_gesture.dart';

class SheetResizeColumnGesture extends SheetGesture {
  final ColumnIndex columnIndex;
  final double width;

  SheetResizeColumnGesture(this.columnIndex, this.width);

  @override
  void resolve(SheetController controller) {
    ColumnStyle columnStyle = controller.properties.getColumnStyle(columnIndex);
    controller.properties.setColumnStyle(columnIndex, columnStyle.copyWith(width: width));
  }

  @override
  List<Object?> get props => <Object?>[columnIndex, width];
}

class SheetResizeRowGesture extends SheetGesture {
  final RowIndex rowIndex;
  final double height;

  SheetResizeRowGesture(this.rowIndex, this.height);

  @override
  void resolve(SheetController controller) {
    RowStyle rowStyle = controller.properties.getRowStyle(rowIndex);
    controller.properties.setRowStyle(
      rowIndex,
      rowStyle.copyWith(height: height),
    );
  }

  @override
  List<Object?> get props => <Object?>[rowIndex, height];
}

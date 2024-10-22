import 'package:sheets/core/gestures/sheet_gesture.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/sheet_properties.dart';

class SheetResizeColumnGesture extends SheetGesture {
  SheetResizeColumnGesture(this.columnIndex, this.width);

  final ColumnIndex columnIndex;
  final double width;

  @override
  void resolve(SheetController controller) {
    ColumnStyle columnStyle = controller.properties.getColumnStyle(columnIndex);
    controller.properties.setColumnStyle(columnIndex, columnStyle.copyWith(width: width));
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
    RowStyle rowStyle = controller.properties.getRowStyle(rowIndex);
    controller.properties.setRowStyle(
      rowIndex,
      rowStyle.copyWith(height: height),
    );
  }

  @override
  List<Object?> get props => <Object?>[rowIndex, height];
}

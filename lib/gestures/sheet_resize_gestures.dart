import 'dart:math';

import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/core/sheet_item_index.dart';
import 'package:sheets/core/sheet_properties.dart';
import 'package:sheets/gestures/sheet_gesture.dart';

class SheetResizeColumnGesture extends SheetGesture {
  final ColumnIndex columnIndex;
  final double delta;

  SheetResizeColumnGesture(this.columnIndex, this.delta);

  @override
  void resolve(SheetController controller) {
    ColumnStyle columnStyle = controller.properties.getColumnStyle(columnIndex);
    controller.properties.setColumnStyle(
      columnIndex,
      columnStyle.copyWith(width: max(10, columnStyle.width + delta)),
    );
  }

  @override
  List<Object?> get props => <Object?>[columnIndex, delta];
}

class SheetResizeRowGesture extends SheetGesture {
  final RowIndex rowIndex;
  final double delta;

  SheetResizeRowGesture(this.rowIndex, this.delta);

  @override
  void resolve(SheetController controller) {
    RowStyle rowStyle = controller.properties.getRowStyle(rowIndex);
    controller.properties.setRowStyle(
      rowIndex,
      rowStyle.copyWith(height: max(10, rowStyle.height + delta)),
    );
  }

  @override
  List<Object?> get props => <Object?>[rowIndex, delta];
}
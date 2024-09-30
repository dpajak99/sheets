import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:sheets/models/selection_status.dart';
import 'package:sheets/models/sheet_item_index.dart';
import 'package:sheets/models/sheet_viewport_delegate.dart';
import 'package:sheets/config/sheet_constants.dart';
import 'package:sheets/models/selection_corners.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';


abstract class SheetSelection with EquatableMixin {
  final SheetViewportDelegate paintConfig;
  final bool _completed;

  SheetSelection({required this.paintConfig, required bool completed}) : _completed = completed;

  bool get isCompleted => _completed;

  CellIndex get start;

  CellIndex get end;

  List<CellIndex> get selectedCells;

  SelectionCellCorners? get selectionCorners;

  SelectionStatus isColumnSelected(ColumnIndex columnIndex);

  SelectionStatus isRowSelected(RowIndex rowIndex);

  SheetSelection complete() {
    return this;
  }

  SheetSelection simplify() {
    return this;
  }

  bool get fillHandleVisible;

  Offset? get fillHandleOffset;

  SheetSelectionPaint get paint;

  String stringifySelection();
}

abstract class SheetSelectionPaint {
  void paint(SheetViewportDelegate paintConfig, Canvas canvas, Size size);

  void paintMainCell(Canvas canvas, Rect rect) {
    Paint mainCellPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth * 2
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect.subtract(borderWidth / 2), mainCellPaint);
  }

  void paintSelectionBackground(Canvas canvas, Rect rect) {
    Paint backgroundPaint = Paint()
      ..color = const Color(0x203572e3)
      ..color = const Color(0x203572e3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);
  }

  void paintSelectionBorder(Canvas canvas, Rect rect, {top = true, right = true, bottom = true, left = true}) {
    Paint selectionPaint = Paint()
      ..color = const Color(0xff3572e3)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    if (top) canvas.drawLine(rect.topLeft, rect.topRight, selectionPaint);
    if (right) canvas.drawLine(rect.topRight, rect.bottomRight, selectionPaint);
    if (bottom) canvas.drawLine(rect.bottomLeft, rect.bottomRight, selectionPaint);
    if (left) canvas.drawLine(rect.topLeft, rect.bottomLeft, selectionPaint);
  }

  void paintFillBorder(Canvas canvas, Rect rect) {
    Paint selectionPaint = Paint()
      ..color = const Color(0xff818181)
      ..strokeWidth = borderWidth
      ..isAntiAlias = false
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    double dashWidth = 4;
    double dashSpace = 4;

    // Draw top dashes
    for (double x = rect.left; x < rect.right; x += dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, rect.top), Offset(x + dashWidth, rect.top), selectionPaint);
    }

    // Draw right dashes
    for (double y = rect.top; y < rect.bottom; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(rect.right, y), Offset(rect.right, y + dashWidth), selectionPaint);
    }

    // Draw bottom dashes
    for (double x = rect.right; x > rect.left; x -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, rect.bottom), Offset(x - dashWidth, rect.bottom), selectionPaint);
    }

    // Draw left dashes
    for (double y = rect.bottom; y > rect.top; y -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(rect.left, y), Offset(rect.left, y - dashWidth), selectionPaint);
    }
  }

  // void paintFillHandle(Canvas canvas, Offset offset) {
  //   Paint fillHandleBorderPaint = Paint()
  //     ..color = const Color(0xffffffff)
  //     ..style = PaintingStyle.fill;
  //
  //   canvas.drawCircle(offset, 5, fillHandleBorderPaint);
  //
  //   Paint fillHandlePaint = Paint()
  //     ..color = const Color(0xff3572e3)
  //     ..style = PaintingStyle.fill;
  //
  //   canvas.drawCircle(offset, 4, fillHandlePaint);
  // }
}

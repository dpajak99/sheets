import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:sheets/controller/index.dart';
import 'package:sheets/controller/selection.dart';
import 'package:sheets/controller/sheet_viewport_delegate.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils/extensions/rect_extensions.dart';

class Range<A extends NumericIndexMixin> with EquatableMixin {
  final A start;
  final A end;

  Range._(this.start, this.end);

  Range.equal(A value)
      : start = value,
        end = value;

  factory Range(A value1, A value2) {
    if (value1 < value2) {
      return Range._(value1, value2);
    } else {
      return Range._(value2, value1);
    }
  }

  bool contains(A value) {
    return value >= start && value <= end;
  }

  bool containsRange(Range<A> range) {
    return range.start >= start && range.end <= end;
  }

  @override
  List<Object?> get props => [start, end];
}

class SelectionStatus with EquatableMixin {
  final bool _isSelected;
  final bool _isFullySelected;

  SelectionStatus(this._isSelected, this._isFullySelected);

  static SelectionStatus statusFalse = SelectionStatus(false, false);

  static SelectionStatus statusTrue = SelectionStatus(true, false);

  T selectValue<T>({required T notSelected, required T selected, required T fullySelected}) {
    if (_isSelected && _isFullySelected) {
      return fullySelected;
    } else if (_isSelected) {
      return selected;
    } else {
      return notSelected;
    }
  }

  SelectionStatus merge(SelectionStatus other) {
    return SelectionStatus(_isSelected || other._isSelected, _isFullySelected && other._isFullySelected);
  }

  @override
  List<Object?> get props => [_isSelected, _isFullySelected];
}

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
